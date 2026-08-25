// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answers_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnswersModelAdapter extends TypeAdapter<AnswersModel> {
  @override
  final int typeId = 3;

  @override
  AnswersModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnswersModel(
      answer: fields[2] as String?,
      cardId: fields[1] as int?,
      userId: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, AnswersModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.cardId)
      ..writeByte(2)
      ..write(obj.answer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnswersModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnswersModel _$AnswersModelFromJson(Map<String, dynamic> json) => AnswersModel(
      answer: json['answer'] as String?,
      cardId: (json['card_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AnswersModelToJson(AnswersModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'card_id': instance.cardId,
      'answer': instance.answer,
    };
