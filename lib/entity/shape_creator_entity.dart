class ShapeCreatorEntity {
  String image;
  ShapeCreatorImageDataEntity imageData;
  List<ShapeCreatorShapesEntity> shapes;

  ShapeCreatorEntity({
    required this.image,
    required this.imageData,
    required this.shapes,
  });
}

class ShapeCreatorImageDataEntity {
  num width;
  num height;

  ShapeCreatorImageDataEntity({
    required this.width,
    required this.height,
  });
}

class ShapeCreatorPositionEntity {
  num x;
  num y;

  ShapeCreatorPositionEntity({
    required this.x,
    required this.y,
  });
}

class ShapeCreatorShapesEntity {
  String type;
  String text;
  ShapeCreatorPositionEntity position;
  num width;
  num height;
  bool isShow;

  ShapeCreatorShapesEntity({
    required this.type,
    required this.text,
    required this.position,
    required this.width,
    required this.height,
    this.isShow = true,
  });
}
