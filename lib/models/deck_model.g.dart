// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeckModel _$DeckModelFromJson(Map<String, dynamic> json) => DeckModel(
      createdAt: json['created_at'] as String?,
      id: (json['id'] as num?)?.toInt(),
      type: json['type'] as String?,
      title: json['title'] as String?,
      byAdmin: json['by_admin'] as bool?,
      cards: (json['cards'] as List<dynamic>?)
          ?.map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => DeckModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      editable: json['editable'] as bool?,
      parentId: (json['parent_id'] as num?)?.toInt(),
      public: json['public'] as bool?,
      sharable: json['sharable'] as bool?,
    )..locked = json['locked'] as bool?;

Map<String, dynamic> _$DeckModelToJson(DeckModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'parent_id': instance.parentId,
      'by_admin': instance.byAdmin,
      'type': instance.type,
      'created_at': instance.createdAt,
      'public': instance.public,
      'cards': instance.cards,
      'children': instance.children,
      'editable': instance.editable,
      'sharable': instance.sharable,
      'locked': instance.locked,
    };
