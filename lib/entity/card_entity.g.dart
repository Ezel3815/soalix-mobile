// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardEntityAdapter extends TypeAdapter<CardEntity> {
  @override
  final int typeId = 2;

  @override
  CardEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardEntity(
      type: fields[8] as String,
      data: fields[3] as dynamic,
      answer: fields[10] as String,
      id: fields[2] as int,
      backImageUrl: fields[5] as String,
      createdAt: fields[9] as String,
      deckId: fields[1] as int,
      documentTitle: fields[7] as String,
      documentUrl: fields[6] as String,
      frontImageUrl: fields[4] as String,
      order: fields[0] as int,
      answers: (fields[11] as List?)?.cast<AnswersModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, CardEntity obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.order)
      ..writeByte(1)
      ..write(obj.deckId)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.data)
      ..writeByte(4)
      ..write(obj.frontImageUrl)
      ..writeByte(5)
      ..write(obj.backImageUrl)
      ..writeByte(6)
      ..write(obj.documentUrl)
      ..writeByte(7)
      ..write(obj.documentTitle)
      ..writeByte(8)
      ..write(obj.type)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.answer)
      ..writeByte(11)
      ..write(obj.answers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
