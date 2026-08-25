// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DocumentEntityAdapter extends TypeAdapter<DocumentEntity> {
  @override
  final int typeId = 0;

  @override
  DocumentEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DocumentEntity(
      title: fields[1] as String,
      name: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DocumentEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
