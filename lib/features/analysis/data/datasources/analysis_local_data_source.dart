import 'dart:convert';

import 'package:hive/hive.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../models/analysis_cache.dart';
import '../models/analysis_model.dart';
import '../../domain/entities/analysis_entity.dart';

abstract class AnalysisLocalDataSource {
  Future<void> cacheAnalysis(AnalysisEntity analysis);
  AnalysisModel? getCachedAnalysis(String decisionId);
  Future<void> removeCachedAnalysis(String decisionId);
}

class AnalysisLocalDataSourceImpl implements AnalysisLocalDataSource {
  final Box<AnalysisCache> analysisBox;

  AnalysisLocalDataSourceImpl({required this.analysisBox});

  @override
  Future<void> cacheAnalysis(AnalysisEntity analysis) async {
    try {
      final cache = AnalysisCache(
        decisionId: analysis.decisionId,
        rawJson: jsonEncode(analysis.rawResult),
        cachedAt: DateTime.now(),
        isSynced: true,
        version: analysis.version,
      );
      await analysisBox.put(cache.decisionId, cache);
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  @override
  AnalysisModel? getCachedAnalysis(String decisionId) {
    final cache = analysisBox.get(decisionId);
    if (cache == null) return null;

    try {
      return AnalysisModel.fromRawJson(
        rawJson: cache.rawJson,
        decisionId: cache.decisionId,
      );
    } catch (e) {
      throw InvalidJsonException(e.toString());
    }
  }

  @override
  Future<void> removeCachedAnalysis(String decisionId) async {
    try {
      await analysisBox.delete(decisionId);
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }
}
