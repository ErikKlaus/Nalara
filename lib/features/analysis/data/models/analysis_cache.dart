import 'package:hive/hive.dart';

part 'analysis_cache.g.dart';

@HiveType(typeId: 1)
class AnalysisCache extends HiveObject {
  @HiveField(0)
  final String decisionId;

  @HiveField(1)
  final String rawJson;

  @HiveField(2)
  final DateTime cachedAt;

  @HiveField(3)
  final bool isSynced;

  @HiveField(4)
  final int version;

  AnalysisCache({
    required this.decisionId,
    required this.rawJson,
    required this.cachedAt,
    this.isSynced = false,
    this.version = 1,
  });
}
