// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shape_creator_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShapeCreatorModel _$ShapeCreatorModelFromJson(Map<String, dynamic> json) =>
    ShapeCreatorModel(
      image: json['image'] as String?,
      imageData: json['imageData'] == null
          ? null
          : ShapeCreatorImageDataModel.fromJson(
              json['imageData'] as Map<String, dynamic>),
      shapes: (json['shapes'] as List<dynamic>?)
          ?.map((e) =>
              ShapeCreatorShapesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShapeCreatorModelToJson(ShapeCreatorModel instance) =>
    <String, dynamic>{
      'image': instance.image,
      'imageData': instance.imageData,
      'shapes': instance.shapes,
    };

ShapeCreatorImageDataModel _$ShapeCreatorImageDataModelFromJson(
        Map<String, dynamic> json) =>
    ShapeCreatorImageDataModel(
      width: json['width'] as num?,
      height: json['height'] as num?,
    );

Map<String, dynamic> _$ShapeCreatorImageDataModelToJson(
        ShapeCreatorImageDataModel instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
    };

ShapeCreatorPositionModel _$ShapeCreatorPositionModelFromJson(
        Map<String, dynamic> json) =>
    ShapeCreatorPositionModel(
      x: json['x'] as num?,
      y: json['y'] as num?,
    );

Map<String, dynamic> _$ShapeCreatorPositionModelToJson(
        ShapeCreatorPositionModel instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
    };

ShapeCreatorShapesModel _$ShapeCreatorShapesModelFromJson(
        Map<String, dynamic> json) =>
    ShapeCreatorShapesModel(
      type: json['type'] as String?,
      text: json['text'] as String?,
      position: json['position'] == null
          ? null
          : ShapeCreatorPositionModel.fromJson(
              json['position'] as Map<String, dynamic>),
      width: json['width'] as num?,
      height: json['height'] as num?,
    );

Map<String, dynamic> _$ShapeCreatorShapesModelToJson(
        ShapeCreatorShapesModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'text': instance.text,
      'position': instance.position,
      'width': instance.width,
      'height': instance.height,
    };
