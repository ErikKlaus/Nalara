import 'package:equatable/equatable.dart';

class Reminder extends Equatable {
  final String id;
  final String decisionId;
  final String userId;
  final String type;
  final DateTime scheduledAt;
  final bool isDismissed;
  final DateTime? dismissedAt;

  const Reminder({
    required this.id,
    required this.decisionId,
    required this.userId,
    required this.type,
    required this.scheduledAt,
    required this.isDismissed,
    this.dismissedAt,
  });

  @override
  List<Object?> get props => [
    id,
    decisionId,
    userId,
    type,
    scheduledAt,
    isDismissed,
    dismissedAt,
  ];
}
