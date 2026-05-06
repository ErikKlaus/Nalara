import { CallableRequest, HttpsError } from 'firebase-functions/v2/https';
import { GoogleGenerativeAI, HarmCategory, HarmBlockThreshold } from '@google/generative-ai';

import { db, FieldValue } from './firebaseAdmin';
import { ANALYSIS_JSON_SCHEMA } from './schema';
import { buildPromptEn } from './prompts/promptEn';
import { buildPromptId } from './prompts/promptId';
import { parseAndValidateResponse } from './validators/responseValidator';
import { getJakartaDayBounds, getSystemLimits, getUserMinuteCount, getUserUsageCount } from './usage';

interface AnalyzeDecisionData {
  inputText: string;
  category: string;
  language?: string;
  decisionId?: string;
}

const MODEL_NAME = 'gemini-1.5-flash';
const MIN_WORDS = 10;
const RATE_LIMIT_PER_MINUTE = 10;
const ALLOWED_CATEGORIES = new Set(['karir', 'finansial']);

function sanitizeInput(text: string): string {
  return text.replace(/\s+/g, ' ').trim();
}

function countWords(text: string): number {
  if (!text.trim()) return 0;
  return text.trim().split(/\s+/).length;
}

function ensureAuth(request: CallableRequest<AnalyzeDecisionData>): string {
  if (!request.auth) {
    throw new HttpsError('unauthenticated', 'Authentication required.');
  }
  return request.auth.uid;
}

function getApiKey(): string {
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    throw new HttpsError('failed-precondition', 'GEMINI_API_KEY is not configured.');
  }
  return apiKey;
}

export async function analyzeDecision(request: CallableRequest<AnalyzeDecisionData>) {
  const uid = ensureAuth(request);
  const payload = request.data;

  if (!payload || typeof payload.inputText !== 'string') {
    throw new HttpsError('invalid-argument', 'inputText is required.');
  }

  const sanitizedInput = sanitizeInput(payload.inputText);
  if (countWords(sanitizedInput) < MIN_WORDS) {
    throw new HttpsError('invalid-argument', 'inputText must be at least 10 words.');
  }

  if (!payload.category || !ALLOWED_CATEGORIES.has(payload.category)) {
    throw new HttpsError('invalid-argument', 'category must be karir or finansial.');
  }

  const language = payload.language === 'en' ? 'en' : 'id';

  const { startOfDay, startOfNextDay } = getJakartaDayBounds();
  const [systemLimits, usedToday, usedLastMinute] = await Promise.all([
    getSystemLimits(),
    getUserUsageCount(uid, startOfDay),
    getUserMinuteCount(uid, new Date(Date.now() - 60 * 1000)),
  ]);

  if (!systemLimits.aiEnabled) {
    throw new HttpsError('failed-precondition', 'AI is currently disabled.');
  }

  if (systemLimits.currentDailyUsage >= systemLimits.hardDailyCap) {
    throw new HttpsError('resource-exhausted', 'System daily usage cap reached.');
  }

  if (usedLastMinute >= RATE_LIMIT_PER_MINUTE) {
    throw new HttpsError('resource-exhausted', 'Rate limit exceeded. Please wait a minute.');
  }

  if (usedToday >= systemLimits.dailyLimit) {
    throw new HttpsError('resource-exhausted', 'Daily limit reached.');
  }

  const genAI = new GoogleGenerativeAI(getApiKey());
  const model = genAI.getGenerativeModel({ model: MODEL_NAME });
  const prompt = language === 'en'
    ? buildPromptEn(payload.category, ANALYSIS_JSON_SCHEMA, sanitizedInput)
    : buildPromptId(payload.category, ANALYSIS_JSON_SCHEMA, sanitizedInput);

  let analysisResult = null as ReturnType<typeof parseAndValidateResponse> | null;
  let lastError: unknown = null;

  for (let attempt = 0; attempt < 2; attempt += 1) {
    try {
      const result = await model.generateContent({
        contents: [{ role: 'user', parts: [{ text: prompt }] }],
        generationConfig: {
          temperature: 0.3,
          maxOutputTokens: 800,
          responseMimeType: 'application/json',
        },
        safetySettings: [
          {
            category: HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT,
            threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
          },
        ],
      });

      const rawText = result.response.text();
      analysisResult = parseAndValidateResponse(rawText);
      break;
    } catch (error) {
      lastError = error;
      analysisResult = null;
    }
  }

  if (!analysisResult) {
    throw new HttpsError('internal', 'Invalid AI response.', String(lastError ?? 'unknown'));
  }

  const decisionsRef = db.collection('users').doc(uid).collection('decisions');
  const decisionRef = payload.decisionId ? decisionsRef.doc(payload.decisionId) : decisionsRef.doc();
  const analysisRef = decisionRef.collection('analyses').doc();
  const logRef = db.collection('users').doc(uid).collection('ai_usage_logs').doc();
  const now = FieldValue.serverTimestamp();

  const decisionData: Record<string, unknown> = {
    id: decisionRef.id,
    uid,
    inputText: sanitizedInput,
    category: payload.category,
    status: 'dianalisis',
    updatedAt: now,
  };

  if (!payload.decisionId) {
    decisionData.createdAt = now;
  }

  const analysisData = {
    id: analysisRef.id,
    decisionId: decisionRef.id,
    uid,
    rawResult: analysisResult,
    overallConfidence: analysisResult.overall_confidence,
    confidenceReason: analysisResult.confidence_reason ?? null,
    analyzedAt: now,
    version: 1,
  };

  const logData = {
    id: logRef.id,
    decisionId: decisionRef.id,
    analysisId: analysisRef.id,
    status: 'success',
    createdAt: now,
  };

  const batch = db.batch();
  batch.set(decisionRef, decisionData, { merge: true });
  batch.set(analysisRef, analysisData);
  batch.set(logRef, logData);
  batch.set(
    db.collection('system_config').doc('ai_limits'),
    {
      currentDailyUsage: FieldValue.increment(1),
      updatedAt: now,
    },
    { merge: true },
  );

  await batch.commit();

  const usedAfter = usedToday + 1;
  const remaining = Math.max(systemLimits.dailyLimit - usedAfter, 0);

  return {
    decisionId: decisionRef.id,
    analysisId: analysisRef.id,
    result: analysisResult,
    usage: {
      dailyLimit: systemLimits.dailyLimit,
      used: usedAfter,
      remaining,
      resetAt: startOfNextDay.toISOString(),
    },
  };
}
