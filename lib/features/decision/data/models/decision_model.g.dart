// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decision_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DecisionModelAdapter extends TypeAdapter<DecisionModel> {
  @override
  final int typeId = 0;

  @override
  DecisionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    final createdAt = fields[3] as DateTime;
    return DecisionModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      status: fields[6] as String? ?? 'draft',
      inputText: fields[2] as String? ?? '',
      category: fields[7] as String? ?? 'karir',
      createdAt: createdAt,
      updatedAt: fields[8] as DateTime? ?? createdAt,
      notes: fields[9] as String?,
      expiresAt: fields[10] as DateTime?,
      isSynced: fields[4] as bool? ?? false,
      resultJson: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DecisionModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.inputText)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.isSynced)
      ..writeByte(5)
      ..write(obj.resultJson)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.notes)
      ..writeByte(10)
      ..write(obj.expiresAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DecisionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
