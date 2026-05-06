import '../../domain/entities/scenario_entity.dart';

class PreventionActionModel extends PreventionActionEntity {
  const PreventionActionModel({required super.action, required super.timing});

  factory PreventionActionModel.fromMap(Map<String, dynamic> map) {
    return PreventionActionModel(
      action: map['action'] as String? ?? '',
      timing: map['timing'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'action': action, 'timing': timing};
  }
}

class ScenarioModel extends ScenarioEntity {
  const ScenarioModel({
    required super.id,
    required super.title,
    required super.narrative,
    required super.likelihood,
    required super.mainCause,
    required super.earlyIndicators,
    required super.preventionActions,
  });

  factory ScenarioModel.fromMap(Map<String, dynamic> map) {
    return ScenarioModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      narrative: map['narrative'] as String? ?? '',
      likelihood: map['likelihood'] as String? ?? '',
      mainCause: map['main_cause'] as String? ?? '',
      earlyIndicators: (map['early_indicators'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
      preventionActions: (map['prevention_actions'] as List<dynamic>? ?? [])
          .map(
            (item) => PreventionActionModel.fromMap(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'narrative': narrative,
      'likelihood': likelihood,
      'main_cause': mainCause,
      'early_indicators': earlyIndicators,
      'prevention_actions': preventionActions
          .map((action) => {'action': action.action, 'timing': action.timing})
          .toList(),
    };
  }
}
