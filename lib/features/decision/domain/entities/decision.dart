import 'package:equatable/equatable.dart';

class Decision extends Equatable {
  final String id;
  final String userId;
  final String status;
  final String inputText;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notes;
  final DateTime? expiresAt;
  final bool isSynced;
  final String? resultJson;

  const Decision({
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
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    inputText,
    category,
    status,
    createdAt,
    updatedAt,
    notes,
    expiresAt,
    isSynced,
    resultJson,
  ];
}
