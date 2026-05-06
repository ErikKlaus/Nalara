import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/analysis_entity.dart';
import '../../domain/entities/scenario_entity.dart';
import 'scenario_model.dart';

class AnalysisModel extends AnalysisEntity {
  const AnalysisModel({
    required super.id,
    required super.decisionId,
    required super.scenarios,
    required super.overallConfidence,
    required super.analyzedAt,
    required super.version,
    required super.rawResult,
    super.userId,
    super.confidenceReason,
    super.clarificationNeeded,
  });

  factory AnalysisModel.fromCallable(Map<String, dynamic> data) {
    final result = Map<String, dynamic>.from(data['result'] as Map);
    return AnalysisModel.fromResult(
      result: result,
      decisionId: data['decisionId'] as String? ?? '',
      analysisId: data['analysisId'] as String? ?? '',
    );
  }

  factory AnalysisModel.fromResult({
    required Map<String, dynamic> result,
    required String decisionId,
    required String analysisId,
    String? userId,
    DateTime? analyzedAt,
    int version = 1,
  }) {
    final scenarios = _parseScenarios(result['scenarios']);
    return AnalysisModel(
      id: analysisId.isEmpty ? 'analysis-$decisionId' : analysisId,
      decisionId: decisionId,
      userId: userId,
      scenarios: scenarios,
      overallConfidence: result['overall_confidence'] as String? ?? '',
      confidenceReason: result['confidence_reason'] as String?,
      clarificationNeeded: result['clarification_needed'] as String?,
      analyzedAt: analyzedAt ?? DateTime.now(),
      version: version,
      rawResult: result,
    );
  }

  factory AnalysisModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    final raw = Map<String, dynamic>.from(data['rawResult'] as Map? ?? {});
    final analyzedAt = _parseDateTime(data['analyzedAt']);
    return AnalysisModel(
      id: documentId,
      decisionId: data['decisionId'] as String? ?? '',
      userId: data['uid'] as String?,
      scenarios: _parseScenarios(raw['scenarios']),
      overallConfidence: (data['overallConfidence'] as String?) ??
          (raw['overall_confidence'] as String?) ??
          '',
      confidenceReason: data['confidenceReason'] as String? ??
          raw['confidence_reason'] as String?,
      clarificationNeeded: raw['clarification_needed'] as String?,
      analyzedAt: analyzedAt,
      version: data['version'] as int? ?? 1,
      rawResult: raw,
    );
  }

  factory AnalysisModel.fromRawJson({
    required String rawJson,
    required String decisionId,
    String? analysisId,
  }) {
    final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
    return AnalysisModel.fromResult(
      result: decoded,
      decisionId: decisionId,
      analysisId: analysisId ?? 'analysis-$decisionId',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'decisionId': decisionId,
      'uid': userId,
      'rawResult': rawResult,
      'overallConfidence': overallConfidence,
      'confidenceReason': confidenceReason,
      'analyzedAt': Timestamp.fromDate(analyzedAt),
      'version': version,
    };
  }

  static List<ScenarioEntity> _parseScenarios(dynamic raw) {
    if (raw is List) {
      return raw
          .map((item) => ScenarioModel.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList();
    }
    return <ScenarioEntity>[];
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
