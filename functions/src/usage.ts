import { db } from './firebaseAdmin';

export interface SystemLimits {
  aiEnabled: boolean;
  dailyLimit: number;
  hardDailyCap: number;
  currentDailyUsage: number;
}

const DEFAULT_LIMITS: SystemLimits = {
  aiEnabled: true,
  dailyLimit: 3,
  hardDailyCap: 1400,
  currentDailyUsage: 0,
};

export function getJakartaDayBounds(date: Date = new Date()): {
  startOfDay: Date;
  startOfNextDay: Date;
} {
  const parts = new Intl.DateTimeFormat('en-US', {
    timeZone: 'Asia/Jakarta',
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).formatToParts(date);

  const lookup = (type: string) => parts.find((part) => part.type === type)?.value ?? '';
  const year = lookup('year');
  const month = lookup('month');
  const day = lookup('day');

  const startOfDay = new Date(`${year}-${month}-${day}T00:00:00+07:00`);
  const startOfNextDay = new Date(startOfDay.getTime() + 24 * 60 * 60 * 1000);

  return { startOfDay, startOfNextDay };
}

export async function getSystemLimits(): Promise<SystemLimits> {
  const configRef = db.collection('system_config').doc('ai_limits');
  const snapshot = await configRef.get();

  if (!snapshot.exists) {
    return DEFAULT_LIMITS;
  }

  const data = snapshot.data() ?? {};

  return {
    aiEnabled: typeof data.aiEnabled === 'boolean' ? data.aiEnabled : DEFAULT_LIMITS.aiEnabled,
    dailyLimit: typeof data.dailyLimit === 'number' ? data.dailyLimit : DEFAULT_LIMITS.dailyLimit,
    hardDailyCap:
      typeof data.hardDailyCap === 'number' ? data.hardDailyCap : DEFAULT_LIMITS.hardDailyCap,
    currentDailyUsage:
      typeof data.currentDailyUsage === 'number'
        ? data.currentDailyUsage
        : DEFAULT_LIMITS.currentDailyUsage,
  };
}

export async function getUserUsageCount(uid: string, startOfDay: Date): Promise<number> {
  const logsRef = db.collection('users').doc(uid).collection('ai_usage_logs');
  const snapshot = await logsRef
    .where('status', '==', 'success')
    .where('createdAt', '>=', startOfDay)
    .get();

  return snapshot.size;
}

export async function getUserMinuteCount(uid: string, since: Date): Promise<number> {
  const logsRef = db.collection('users').doc(uid).collection('ai_usage_logs');
  const snapshot = await logsRef.where('createdAt', '>=', since).get();

  return snapshot.size;
}
