import 'package:equatable/equatable.dart';

import 'scenario_entity.dart';

class AnalysisEntity extends Equatable {
  final String id;
  final String decisionId;
  final String? userId;
  final List<ScenarioEntity> scenarios;
  final String overallConfidence;
  final String? confidenceReason;
  final String? clarificationNeeded;
  final DateTime analyzedAt;
  final int version;
  final Map<String, dynamic> rawResult;

  const AnalysisEntity({
    required this.id,
    required this.decisionId,
    required this.scenarios,
    required this.overallConfidence,
    required this.analyzedAt,
    required this.version,
    required this.rawResult,
    this.userId,
    this.confidenceReason,
    this.clarificationNeeded,
  });

  @override
  List<Object?> get props => [
    id,
    decisionId,
    userId,
    scenarios,
    overallConfidence,
    confidenceReason,
    clarificationNeeded,
    analyzedAt,
    version,
    rawResult,
  ];
}
