import 'package:cloud_functions/cloud_functions.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/analysis_repository.dart';
import '../models/analysis_model.dart';

abstract class AnalysisRemoteDataSource {
  Future<AnalyzeDecisionResult> analyzeDecision({
    required String inputText,
    required String category,
    required String language,
    String? decisionId,
  });

  Future<UsageLimit> checkUsageLimit();
}

class AnalysisRemoteDataSourceImpl implements AnalysisRemoteDataSource {
  final FirebaseFunctions functions;

  AnalysisRemoteDataSourceImpl({required this.functions});

  @override
  Future<AnalyzeDecisionResult> analyzeDecision({
    required String inputText,
    required String category,
    required String language,
    String? decisionId,
  }) async {
    try {
      final callable = functions.httpsCallable('analyzeDecision');
      final response = await callable.call({
        'inputText': inputText,
        'category': category,
        'language': language,
        // ignore: use_null_aware_elements
        if (decisionId != null) 'decisionId': decisionId,
      });

      final data = Map<String, dynamic>.from(response.data as Map);
      final analysis = AnalysisModel.fromCallable(data);
      final usage = _parseUsage(data['usage'] as Map?);

      return AnalyzeDecisionResult(analysis: analysis, usage: usage);
    } on FirebaseFunctionsException catch (e) {
      if (e.code == 'resource-exhausted') {
        throw AiLimitReachedException(e.message ?? 'AI limit reached');
      }
      if (e.code == 'deadline-exceeded') {
        throw AiTimeoutException(e.message ?? 'AI request timed out');
      }
      if (e.code == 'unauthenticated') {
        throw const AuthFailure('Authentication required');
      }
      throw ServerFailure(e.message ?? 'Server error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<UsageLimit> checkUsageLimit() async {
    try {
      final callable = functions.httpsCallable('checkUsageLimit');
      final response = await callable.call();
      final data = Map<String, dynamic>.from(response.data as Map);
      return _parseUsage(data);
    } on FirebaseFunctionsException catch (e) {
      if (e.code == 'unauthenticated') {
        throw const AuthFailure('Authentication required');
      }
      throw ServerFailure(e.message ?? 'Server error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  UsageLimit _parseUsage(Map? raw) {
    final data = Map<String, dynamic>.from(raw ?? {});
    final resetAt =
        DateTime.tryParse(data['resetAt']?.toString() ?? '') ?? DateTime.now();
    return UsageLimit(
      dailyLimit: (data['dailyLimit'] as num?)?.toInt() ?? 0,
      used: (data['used'] as num?)?.toInt() ?? 0,
      remaining: (data['remaining'] as num?)?.toInt() ?? 0,
      resetAt: resetAt,
      aiEnabled: data['aiEnabled'] as bool? ?? true,
    );
  }
}
