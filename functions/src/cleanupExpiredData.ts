import { db, FieldValue } from './firebaseAdmin';

const DAY_MS = 24 * 60 * 60 * 1000;

async function deleteQueryInBatches(query: FirebaseFirestore.Query<FirebaseFirestore.DocumentData>) {
  let snapshot = await query.limit(500).get();

  while (!snapshot.empty) {
    const batch = db.batch();
    snapshot.docs.forEach((doc) => batch.delete(doc.ref));
    await batch.commit();
    snapshot = await query.limit(500).get();
  }
}

export async function cleanupExpiredData() {
  const now = Date.now();
  const aiLogsCutoff = new Date(now - 90 * DAY_MS);
  const remindersCutoff = new Date(now - 30 * DAY_MS);

  await db.collection('system_config').doc('ai_limits').set(
    {
      currentDailyUsage: 0,
      updatedAt: FieldValue.serverTimestamp(),
    },
    { merge: true },
  );

  const aiLogsQuery = db.collectionGroup('ai_usage_logs').where('createdAt', '<', aiLogsCutoff);
  await deleteQueryInBatches(aiLogsQuery);

  const remindersQuery = db.collectionGroup('reminders').where('dismissedAt', '<', remindersCutoff);
  await deleteQueryInBatches(remindersQuery);
}
