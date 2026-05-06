import '../../../../core/errors/failures.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../domain/entities/analysis_entity.dart';
import '../../domain/repositories/analysis_repository.dart';
import '../datasources/analysis_local_data_source.dart';
import '../datasources/analysis_remote_data_source.dart';

class AnalysisRepositoryImpl implements AnalysisRepository {
  final AnalysisRemoteDataSource remoteDataSource;
  final AnalysisLocalDataSource localDataSource;
  final ConnectivityService connectivityService;

  AnalysisRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivityService,
  });

  @override
  Future<AnalyzeDecisionResult> analyzeDecision({
    required String inputText,
    required String category,
    required String language,
    String? decisionId,
  }) async {
    final isConnected = await connectivityService.isConnected;
    if (!isConnected) {
      throw const NetworkFailure('No internet connection');
    }

    final result = await remoteDataSource.analyzeDecision(
      inputText: inputText,
      category: category,
      language: language,
      decisionId: decisionId,
    );

    await localDataSource.cacheAnalysis(result.analysis);

    return result;
  }

  @override
  Future<UsageLimit> checkUsageLimit() {
    return remoteDataSource.checkUsageLimit();
  }

  @override
  Future<AnalysisEntity?> getCachedAnalysis(String decisionId) async {
    return localDataSource.getCachedAnalysis(decisionId);
  }
}
