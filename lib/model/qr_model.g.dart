// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QRModelAdapter extends TypeAdapter<QRModel> {
  @override
  final int typeId = 1;

  @override
  QRModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QRModel(
      id: fields[0] as String?,
      title: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QRModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QRModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
