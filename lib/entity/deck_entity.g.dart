// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeckEntityAdapter extends TypeAdapter<DeckEntity> {
  @override
  final int typeId = 1;

  @override
  DeckEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeckEntity(
      createdAt: fields[5] as String,
      id: fields[0] as int,
      type: fields[4] as String,
      title: fields[1] as String,
      byAdmin: fields[3] as bool,
      cards: (fields[7] as List).cast<CardEntity>(),
      children: (fields[8] as List).cast<DeckEntity>(),
      editable: fields[9] as bool,
      parentId: fields[2] as int,
      public: fields[6] as bool,
      sharable: fields[10] as bool,
      locked: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DeckEntity obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.parentId)
      ..writeByte(3)
      ..write(obj.byAdmin)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.public)
      ..writeByte(7)
      ..write(obj.cards)
      ..writeByte(8)
      ..write(obj.children)
      ..writeByte(9)
      ..write(obj.editable)
      ..writeByte(10)
      ..write(obj.sharable)
      ..writeByte(11)
      ..write(obj.locked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
