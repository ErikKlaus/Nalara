import '../repositories/analysis_repository.dart';

class CheckUsageLimit {
  final AnalysisRepository repository;

  CheckUsageLimit(this.repository);

  Future<UsageLimit> call() {
    return repository.checkUsageLimit();
  }
}
