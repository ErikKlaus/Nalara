import 'package:hive/hive.dart';

import '../../features/decision/data/models/decision_model.dart';
import '../../features/decision/domain/repositories/decision_repository.dart';

class SyncManager {
  SyncManager._();

  static Future<void> syncOfflineDecisions({
    required DecisionRepository repository,
    required String userId,
  }) {
    return repository.syncOfflineDecisions(userId);
  }

  static Future<int> cleanupExpiredDrafts({
    required Box<DecisionModel> decisionBox,
    required Box<DecisionModel> outboxBox,
  }) async {
    final now = DateTime.now();
    int removed = 0;

    for (final decision in decisionBox.values.toList()) {
      final expiresAt = decision.expiresAt;
      if (expiresAt != null && expiresAt.isBefore(now)) {
        await decisionBox.delete(decision.id);
        removed += 1;
      }
    }

    for (final decision in outboxBox.values.toList()) {
      final expiresAt = decision.expiresAt;
      if (expiresAt != null && expiresAt.isBefore(now)) {
        await outboxBox.delete(decision.id);
        removed += 1;
      }
    }

    return removed;
  }
}
