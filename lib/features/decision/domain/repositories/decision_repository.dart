import '../entities/decision.dart';

abstract class DecisionRepository {
  Stream<List<Decision>> watchDecisions(String userId);
  Future<void> addDecision(Decision decision);
  Future<void> updateDecision(Decision decision);
  Future<void> syncOfflineDecisions(String userId);
}
