// ignore_for_file: overridden_fields
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/decision.dart';

part 'decision_model.g.dart';

@HiveType(typeId: 0)
class DecisionModel extends Decision {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String userId;

  @HiveField(2)
  @override
  final String inputText;

  @HiveField(3)
  @override
  final DateTime createdAt;

  @HiveField(4)
  @override
  final bool isSynced;

  @HiveField(5)
  @override
  final String? resultJson;

  @HiveField(6)
  @override
  final String status;

  @HiveField(7)
  @override
  final String category;

  @HiveField(8)
  @override
  final DateTime updatedAt;

  @HiveField(9)
  @override
  final String? notes;

  @HiveField(10)
  @override
  final DateTime? expiresAt;

  const DecisionModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.inputText,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.expiresAt,
    required this.isSynced,
    this.resultJson,
  }) : super(
         id: id,
         userId: userId,
         status: status,
         inputText: inputText,
         category: category,
         createdAt: createdAt,
         updatedAt: updatedAt,
         notes: notes,
         expiresAt: expiresAt,
         isSynced: isSynced,
         resultJson: resultJson,
       );

  factory DecisionModel.fromJson(Map<String, dynamic> json, String documentId) {
    final createdAt = _parseDateTime(json['createdAt']);
    return DecisionModel(
      id: documentId,
      userId: (json['uid'] as String?) ?? (json['userId'] as String?) ?? '',
      inputText:
          (json['inputText'] as String?) ?? (json['text'] as String?) ?? '',
      category: (json['category'] as String?) ?? 'karir',
      status: (json['status'] as String?) ?? 'draft',
      createdAt: createdAt,
      updatedAt: _parseDateTime(json['updatedAt'], fallback: createdAt),
      notes: json['notes'] as String?,
      expiresAt: _parseOptionalDateTime(json['expiresAt']),
      isSynced: true, // If it comes from Firebase, it's synced
      resultJson: json['resultJson'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'uid': userId,
      'inputText': inputText,
      'category': category,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };

    if (notes != null) {
      data['notes'] = notes;
    }

    if (expiresAt != null) {
      data['expiresAt'] = Timestamp.fromDate(expiresAt!);
    }

    if (resultJson != null) {
      data['resultJson'] = resultJson;
    }

    return data;
  }

  factory DecisionModel.fromEntity(Decision entity) {
    return DecisionModel(
      id: entity.id,
      userId: entity.userId,
      status: entity.status,
      inputText: entity.inputText,
      category: entity.category,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      notes: entity.notes,
      expiresAt: entity.expiresAt,
      isSynced: entity.isSynced,
      resultJson: entity.resultJson,
    );
  }

  static DateTime _parseDateTime(dynamic value, {DateTime? fallback}) {
    if (value == null) {
      return fallback ?? DateTime.now();
    }

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value) ?? (fallback ?? DateTime.now());
    }

    return fallback ?? DateTime.now();
  }

  static DateTime? _parseOptionalDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

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
