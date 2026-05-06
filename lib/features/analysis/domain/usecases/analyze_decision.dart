import '../repositories/analysis_repository.dart';

class AnalyzeDecision {
  final AnalysisRepository repository;

  AnalyzeDecision(this.repository);

  Future<AnalyzeDecisionResult> call({
    required String inputText,
    required String category,
    required String language,
    String? decisionId,
  }) {
    return repository.analyzeDecision(
      inputText: inputText,
      category: category,
      language: language,
      decisionId: decisionId,
    );
  }
}
