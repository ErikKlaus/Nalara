import { CallableRequest, HttpsError } from 'firebase-functions/v2/https';

import { getJakartaDayBounds, getSystemLimits, getUserUsageCount } from './usage';

export async function checkUsageLimit(request: CallableRequest<unknown>) {
  if (!request.auth) {
    throw new HttpsError('unauthenticated', 'Authentication required.');
  }

  const uid = request.auth.uid;
  const { startOfDay, startOfNextDay } = getJakartaDayBounds();
  const [systemLimits, usedToday] = await Promise.all([
    getSystemLimits(),
    getUserUsageCount(uid, startOfDay),
  ]);

  const remaining = Math.max(systemLimits.dailyLimit - usedToday, 0);

  return {
    dailyLimit: systemLimits.dailyLimit,
    used: usedToday,
    remaining,
    resetAt: startOfNextDay.toISOString(),
    aiEnabled: systemLimits.aiEnabled,
  };
}
