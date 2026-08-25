import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/models/shape_creator_model.dart';
import 'package:upgrade/widgets/app_snack_bar.dart';

class ShapeCreatorController extends GetxController {
  late String imagePath;
  final RxList<ShapeCreatorWidgetModel> _shapes =
      <ShapeCreatorWidgetModel>[].obs;
  final RxBool _isTransparent = false.obs;
  final imageKey = GlobalKey();
  final List<ShapeCreatorPositionModel> pos = [];

  bool get isTransparent => _isTransparent.value;

  List<ShapeCreatorWidgetModel> get shapes => _shapes;

  set isTransparent(value) => _isTransparent.value = value;

  set shapes(List<ShapeCreatorWidgetModel> value) => _shapes.value = value;

  void toggleTransparency() {
    isTransparent = !isTransparent;
    double newOpacity = isTransparent ? 0.5 : 1.0;
    for (var element in shapes) {
      element.opacity = newOpacity;
    }
    _shapes.refresh();
  }

  void clearShapes() {
    shapes.clear();
    pos.clear();
  }

  void addRectangle() {
    pos.add(ShapeCreatorPositionModel(
      x: 50,
      y: 50,
    ));
    shapes.add(
      ShapeCreatorWidgetModel(
        type: "Rectangle",
        key: GlobalKey(),
        opacity: isTransparent ? 0.5 : 1.0,
      ),
    );
  }

  void addCircle() {
    pos.add(ShapeCreatorPositionModel(
      x: 50,
      y: 50,
    ));
    shapes.add(
      ShapeCreatorWidgetModel(
        type: "Circle",
        key: GlobalKey(),
        opacity: isTransparent ? 0.5 : 1.0,
      ),
    );
  }

  void addTextBox() {
    pos.add(ShapeCreatorPositionModel(
      x: 50,
      y: 50,
    ));
    shapes.add(
      ShapeCreatorWidgetModel(
        type: "TextBox",
        key: GlobalKey(),
        opacity: isTransparent ? 0.5 : 1.0,
        controller: TextEditingController(),
      ),
    );
  }

  Future<String?> uploadImage(String path) async {
    return await ApiController.uploadImage(path);
  }

  returnShapeCreatorData(BuildContext context) async {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final ShapeCreatorModel model = ShapeCreatorModel();
    showAppLoadingDialog();
    final image = await uploadImage(imagePath);
    Get.back();

    if (image != null) {
      model.image = image;

      RenderBox? box =
          imageKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        Size size = box.size;

        model.imageData = ShapeCreatorImageDataModel(
          width: size.width / width,
          height: size.height / height,
        );
      }
      model.shapes = [];
      for (var element in shapes) {
        final index = shapes.indexOf(element);
        RenderBox? box =
            element.key.currentContext?.findRenderObject() as RenderBox?;
        if (box != null) {
          Size size = box.size;
          final posi = pos[index];

          model.shapes?.add(
            ShapeCreatorShapesModel(
              type: element.type,
              text: element.controller?.text,
              width: size.width / width,
              height: size.height / height,
              position: ShapeCreatorPositionModel(
                x: posi.x! / width,
                y: posi.y! / height,
              ),
            ),
          );
        }
      }
      Get.back(result: model);
      showSnackBarWidget(
        message: "Image added successfully",
        color: Colors.green,
        snackPosition: SnackPosition.TOP,
      );
    } else {
      showSnackBarWidget(message: "Error when upload image");
    }
  }

  @override
  void onInit() {
    imagePath = Get.arguments;
    super.onInit();
  }
}

class ShapeCreatorWidgetModel {
  String type;
  GlobalKey key;
  double opacity;
  TextEditingController? controller;

  ShapeCreatorWidgetModel({
    required this.type,
    required this.key,
    required this.opacity,
    this.controller,
  });
}
