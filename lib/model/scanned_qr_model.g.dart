// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scanned_qr_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScannedQrModelAdapter extends TypeAdapter<ScannedQrModel> {
  @override
  final int typeId = 2;

  @override
  ScannedQrModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScannedQrModel(
      id: fields[0] as String?,
      title: fields[1] as String,
      date: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ScannedQrModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScannedQrModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
