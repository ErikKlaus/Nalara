import 'package:hive/hive.dart';
import '../models/decision_model.dart';

abstract class DecisionLocalDataSource {
  Future<void> cacheDecisions(List<DecisionModel> decisions);
  List<DecisionModel> getCachedDecisions();
  Future<void> addDecisionToOutbox(DecisionModel decision);
  List<DecisionModel> getOutboxDecisions();
  Future<void> removeDecisionFromOutbox(String decisionId);
}

class DecisionLocalDataSourceImpl implements DecisionLocalDataSource {
  final Box<DecisionModel> decisionBox;
  final Box<DecisionModel> outboxBox;

  DecisionLocalDataSourceImpl({
    required this.decisionBox,
    required this.outboxBox,
  });

  @override
  Future<void> cacheDecisions(List<DecisionModel> decisions) async {
    await decisionBox.clear();
    final Map<dynamic, DecisionModel> map = {
      for (var d in decisions) d.id: d,
    };
    await decisionBox.putAll(map);
  }

  @override
  List<DecisionModel> getCachedDecisions() {
    return decisionBox.values.toList();
  }

  @override
  Future<void> addDecisionToOutbox(DecisionModel decision) async {
    await outboxBox.put(decision.id, decision);
  }

  @override
  List<DecisionModel> getOutboxDecisions() {
    return outboxBox.values.toList();
  }

  @override
  Future<void> removeDecisionFromOutbox(String decisionId) async {
    await outboxBox.delete(decisionId);
  }
}
