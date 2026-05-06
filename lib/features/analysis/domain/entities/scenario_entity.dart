import 'package:equatable/equatable.dart';

class PreventionActionEntity extends Equatable {
  final String action;
  final String timing;

  const PreventionActionEntity({
    required this.action,
    required this.timing,
  });

  @override
  List<Object> get props => [action, timing];
}

class ScenarioEntity extends Equatable {
  final String id;
  final String title;
  final String narrative;
  final String likelihood;
  final String mainCause;
  final List<String> earlyIndicators;
  final List<PreventionActionEntity> preventionActions;

  const ScenarioEntity({
    required this.id,
    required this.title,
    required this.narrative,
    required this.likelihood,
    required this.mainCause,
    required this.earlyIndicators,
    required this.preventionActions,
  });

  @override
  List<Object> get props => [
    id,
    title,
    narrative,
    likelihood,
    mainCause,
    earlyIndicators,
    preventionActions,
  ];
}
