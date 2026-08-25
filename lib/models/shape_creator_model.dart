import 'package:json_annotation/json_annotation.dart';

part 'shape_creator_model.g.dart';

@JsonSerializable()
class ShapeCreatorModel {
  String? image;
  ShapeCreatorImageDataModel? imageData;
  List<ShapeCreatorShapesModel>? shapes;

  ShapeCreatorModel({
    this.image,
    this.imageData,
    this.shapes,
  });

  factory ShapeCreatorModel.fromJson(Map<String, dynamic> json) =>
      _$ShapeCreatorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShapeCreatorModelToJson(this);
}

@JsonSerializable()
class ShapeCreatorImageDataModel {
  num? width;
  num? height;

  ShapeCreatorImageDataModel({
    this.width,
    this.height,
  });

  factory ShapeCreatorImageDataModel.fromJson(Map<String, dynamic> json) =>
      _$ShapeCreatorImageDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShapeCreatorImageDataModelToJson(this);
}

@JsonSerializable()
class ShapeCreatorPositionModel {
  num? x;
  num? y;

  ShapeCreatorPositionModel({
    this.x,
    this.y,
  });

  factory ShapeCreatorPositionModel.fromJson(Map<String, dynamic> json) =>
      _$ShapeCreatorPositionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShapeCreatorPositionModelToJson(this);
}

@JsonSerializable()
class ShapeCreatorShapesModel {
  String? type;
  String? text;
  ShapeCreatorPositionModel? position;
  num? width;
  num? height;

  ShapeCreatorShapesModel({
    this.type,
    this.text,
    this.position,
    this.width,
    this.height,
  });

  factory ShapeCreatorShapesModel.fromJson(Map<String, dynamic> json) =>
      _$ShapeCreatorShapesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShapeCreatorShapesModelToJson(this);
}
