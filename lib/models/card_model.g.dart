// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardModel _$CardModelFromJson(Map<String, dynamic> json) => CardModel(
      type: json['type'] as String?,
      data: json['data'],
      answer: json['answer'] as String?,
      id: (json['id'] as num?)?.toInt(),
      backImageUrl: json['back_image_name'] as String?,
      createdAt: json['created_at'] as String?,
      deckId: (json['deck_id'] as num?)?.toInt(),
      documentTitle: json['document_title'] as String?,
      documentUrl: json['document_name'] as String?,
      frontImageUrl: json['front_image_name'] as String?,
      order: (json['order'] as num?)?.toInt(),
      answers: (json['answers'] as List<dynamic>?)
          ?.map((e) => AnswersModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CardModelToJson(CardModel instance) => <String, dynamic>{
      'order': instance.order,
      'deck_id': instance.deckId,
      'id': instance.id,
      'data': instance.data,
      'front_image_name': instance.frontImageUrl,
      'back_image_name': instance.backImageUrl,
      'document_name': instance.documentUrl,
      'document_title': instance.documentTitle,
      'type': instance.type,
      'created_at': instance.createdAt,
      'answer': instance.answer,
      'answers': instance.answers,
    };
