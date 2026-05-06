import '../entities/analysis_entity.dart';

class UsageLimit {
  final int dailyLimit;
  final int used;
  final int remaining;
  final DateTime resetAt;
  final bool aiEnabled;

  const UsageLimit({
    required this.dailyLimit,
    required this.used,
    required this.remaining,
    required this.resetAt,
    required this.aiEnabled,
  });
}

class AnalyzeDecisionResult {
  final AnalysisEntity analysis;
  final UsageLimit usage;

  const AnalyzeDecisionResult({required this.analysis, required this.usage});
}

abstract class AnalysisRepository {
  Future<AnalyzeDecisionResult> analyzeDecision({
    required String inputText,
    required String category,
    required String language,
    String? decisionId,
  });

  Future<UsageLimit> checkUsageLimit();

  Future<AnalysisEntity?> getCachedAnalysis(String decisionId);
}
