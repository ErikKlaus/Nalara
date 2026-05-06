import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/constants/hive_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../data/datasources/analysis_local_data_source.dart';
import '../../data/datasources/analysis_remote_data_source.dart';
import '../../data/models/analysis_cache.dart';
import '../../data/repositories/analysis_repository_impl.dart';
import '../../domain/entities/analysis_entity.dart';
import '../../domain/repositories/analysis_repository.dart';

final analysisLocalDataSourceProvider = Provider<AnalysisLocalDataSource>((
  ref,
) {
  return AnalysisLocalDataSourceImpl(
    analysisBox: Hive.box<AnalysisCache>(HiveConstants.analysisBox),
  );
});

final analysisRemoteDataSourceProvider = Provider<AnalysisRemoteDataSource>((
  ref,
) {
  return AnalysisRemoteDataSourceImpl(functions: FirebaseFunctions.instance);
});

final analysisRepositoryProvider = Provider<AnalysisRepository>((ref) {
  return AnalysisRepositoryImpl(
    remoteDataSource: ref.watch(analysisRemoteDataSourceProvider),
    localDataSource: ref.watch(analysisLocalDataSourceProvider),
    connectivityService: ConnectivityService(),
  );
});

final analysisControllerProvider =
    StateNotifierProvider<AnalysisController, AnalysisState>((ref) {
      return AnalysisController(ref.watch(analysisRepositoryProvider));
    });

final usageLimitProvider = FutureProvider<UsageLimit>((ref) {
  return ref.watch(analysisRepositoryProvider).checkUsageLimit();
});

abstract class AnalysisState {
  const AnalysisState();
}

class AnalysisInitial extends AnalysisState {
  const AnalysisInitial();
}

class AnalysisLoading extends AnalysisState {
  const AnalysisLoading();
}

class AnalysisClarificationNeeded extends AnalysisState {
  final String question;

  const AnalysisClarificationNeeded(this.question);
}

class AnalysisSuccess extends AnalysisState {
  final AnalysisEntity analysis;
  final UsageLimit usage;

  const AnalysisSuccess({required this.analysis, required this.usage});
}

class AnalysisLowConfidence extends AnalysisState {
  final AnalysisEntity analysis;
  final UsageLimit usage;

  const AnalysisLowConfidence({required this.analysis, required this.usage});
}

class AnalysisLimitReached extends AnalysisState {
  final UsageLimit usage;

  const AnalysisLimitReached(this.usage);
}

class AnalysisError extends AnalysisState {
  final String message;

  const AnalysisError(this.message);
}

class AnalysisController extends StateNotifier<AnalysisState> {
  final AnalysisRepository _repository;

  AnalysisController(this._repository) : super(const AnalysisInitial());

  Future<void> analyzeDecision({
    required String inputText,
    required String category,
    required String language,
    String? decisionId,
  }) async {
    state = const AnalysisLoading();

    try {
      final result = await _repository
          .analyzeDecision(
            inputText: inputText,
            category: category,
            language: language,
            decisionId: decisionId,
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw const AiTimeoutException(),
          );

      final analysis = result.analysis;
      final clarification = analysis.clarificationNeeded;

      if (clarification != null && clarification.trim().isNotEmpty) {
        state = AnalysisClarificationNeeded(clarification);
        return;
      }

      if (analysis.overallConfidence == 'rendah') {
        state = AnalysisLowConfidence(analysis: analysis, usage: result.usage);
        return;
      }

      state = AnalysisSuccess(analysis: analysis, usage: result.usage);
    } on AiTimeoutException catch (e) {
      state = AnalysisError(e.toString());
    } on AiLimitReachedException {
      try {
        final usage = await _repository.checkUsageLimit();
        state = AnalysisLimitReached(usage);
      } catch (e) {
        state = AnalysisError(e.toString());
      }
    } on Failure catch (e) {
      state = AnalysisError(e.message);
    } catch (e) {
      state = AnalysisError(e.toString());
    }
  }

  Future<void> loadCachedAnalysis(String decisionId) async {
    try {
      final cached = await _repository.getCachedAnalysis(decisionId);
      if (cached == null) {
        state = const AnalysisError('No cached analysis available');
        return;
      }

      state = AnalysisSuccess(
        analysis: cached,
        usage: UsageLimit(
          dailyLimit: 0,
          used: 0,
          remaining: 0,
          resetAt: DateTime.now(),
          aiEnabled: false,
        ),
      );
    } catch (e) {
      state = AnalysisError(e.toString());
    }
  }
}
