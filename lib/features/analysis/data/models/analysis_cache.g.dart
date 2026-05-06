// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_cache.dart';

// ***************************************************************************
// TypeAdapterGenerator
// ***************************************************************************

class AnalysisCacheAdapter extends TypeAdapter<AnalysisCache> {
  @override
  final int typeId = 1;

  @override
  AnalysisCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalysisCache(
      decisionId: fields[0] as String,
      rawJson: fields[1] as String,
      cachedAt: fields[2] as DateTime,
      isSynced: fields[3] as bool? ?? false,
      version: fields[4] as int? ?? 1,
    );
  }

  @override
  void write(BinaryWriter writer, AnalysisCache obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.decisionId)
      ..writeByte(1)
      ..write(obj.rawJson)
      ..writeByte(2)
      ..write(obj.cachedAt)
      ..writeByte(3)
      ..write(obj.isSynced)
      ..writeByte(4)
      ..write(obj.version);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalysisCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
