import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/reminder.dart';

class ReminderModel extends Reminder {
  const ReminderModel({
    required super.id,
    required super.decisionId,
    required super.userId,
    required super.type,
    required super.scheduledAt,
    required super.isDismissed,
    super.dismissedAt,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json, String documentId) {
    return ReminderModel(
      id: documentId,
      decisionId: json['decisionId'] as String? ?? '',
      userId: (json['uid'] as String?) ?? (json['userId'] as String?) ?? '',
      type: json['type'] as String? ?? 'review',
      scheduledAt: _parseDateTime(json['scheduledAt']),
      isDismissed: json['isDismissed'] as bool? ?? false,
      dismissedAt: _parseOptionalDateTime(json['dismissedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'decisionId': decisionId,
      'uid': userId,
      'type': type,
      'scheduledAt': Timestamp.fromDate(scheduledAt),
      'isDismissed': isDismissed,
    };

    if (dismissedAt != null) {
      data['dismissedAt'] = Timestamp.fromDate(dismissedAt!);
    }

    return data;
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

  static DateTime? _parseOptionalDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
