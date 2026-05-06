import { onCall } from 'firebase-functions/v2/https';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import { analyzeDecision as analyzeDecisionHandler } from './analyzeDecision';
import { checkUsageLimit as checkUsageLimitHandler } from './checkUsageLimit';
import { cleanupExpiredData as cleanupExpiredDataHandler } from './cleanupExpiredData';

export const analyzeDecision = onCall(analyzeDecisionHandler);
export const checkUsageLimit = onCall(checkUsageLimitHandler);
export const cleanupExpiredData = onSchedule(
	{ schedule: '0 2 * * *', timeZone: 'Asia/Jakarta' },
	cleanupExpiredDataHandler,
);
