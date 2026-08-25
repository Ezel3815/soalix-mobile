import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/shape_creator_controller.dart';
import 'package:upgrade/models/shape_creator_model.dart';
import 'package:upgrade/resources.dart';

class ShapeCreator extends GetView<ShapeCreatorController> {
  const ShapeCreator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.scaffoldBackgroundColor,
        actions: [
          IconButton(
            onPressed: () => controller.returnShapeCreatorData(context),
            icon: const Icon(Icons.check),
            tooltip: "Save",
          ),
          const SizedBox(width: 20)
        ],
      ),
      floatingActionButton: MediaQuery.viewInsetsOf(context).bottom != 0
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed: controller.addRectangle,
                  tooltip: 'Add Rectangle',
                  heroTag: 'Add Rectangle',
                  child: const Icon(Icons.rectangle),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: controller.addCircle,
                  tooltip: 'Add Circle',
                  heroTag: 'Add Circle',
                  child: const Icon(Icons.circle),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: controller.addTextBox,
                  tooltip: 'Add Text Box',
                  heroTag: 'Add Text Box',
                  child: const Icon(Icons.text_fields),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: controller.toggleTransparency,
                  tooltip: 'Toggle Transparency',
                  heroTag: 'Toggle Transparency',
                  child: const Icon(Icons.visibility),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: controller.clearShapes,
                  heroTag: 'Clear Shapes',
                  tooltip: 'Clear Shapes',
                  child: const Icon(Icons.clear),
                ),
              ],
            ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Container(
              color: AppColor.scaffoldBackgroundColor,
            ),
          ),
          AspectRatio(
            aspectRatio: 1080 / 1920,
            key: controller.imageKey,
            child: Image.file(
              File(controller.imagePath),
              fit: BoxFit.contain,
            ),
          ),
          AspectRatio(
            aspectRatio: 1080 / 1920,
            child: Obx(
              () => Stack(
                children: List.generate(
                  controller.shapes.length,
                  (index) {
                    return Obx(
                      () {
                        final item = controller.shapes[index];
                        if (item.type == "Rectangle") {
                          return DraggableResizableShape(
                            key: item.key,
                            shape: Container(
                              width: 100,
                              height: 100,
                              color: Colors.blue,
                            ),
                            opacity: item.opacity,
                            getPositioned: (double top, double left) {
                              controller.pos[index] = ShapeCreatorPositionModel(
                                x: left,
                                y: top,
                              );
                            },
                          );
                        }
                        if (item.type == "Circle") {
                          return DraggableResizableShape(
                            key: item.key,
                            shape: Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            opacity: item.opacity,
                            getPositioned: (double top, double left) {
                              controller.pos[index] = ShapeCreatorPositionModel(
                                x: left,
                                y: top,
                              );
                            },
                          );
                        }
                        return DraggableResizableShape(
                          key: item.key,
                          shape: Container(
                            width: 100,
                            height: 100,
                            color: Colors.greenAccent,
                            child: TextFormField(
                              expands: false,
                              onTapOutside: (event) =>
                                  FocusScope.of(context).unfocus(),
                              controller: item.controller,
                              decoration: const InputDecoration(
                                hintText: 'Text',
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.greenAccent,
                              ),
                            ),
                          ),
                          opacity: item.opacity,
                          getPositioned: (double top, double left) {
                            controller.pos[index] = ShapeCreatorPositionModel(
                              x: left,
                              y: top,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DraggableResizableShape extends StatefulWidget {
  final Widget shape;
  final double opacity;
  final void Function(double top, double left) getPositioned;

  const DraggableResizableShape({
    super.key,
    required this.shape,
    required this.opacity,
    required this.getPositioned,
  });

  @override
  DraggableResizableShapeState createState() => DraggableResizableShapeState();
}

class DraggableResizableShapeState extends State<DraggableResizableShape> {
  double left = 50;
  double top = 50;
  double width = 100;
  double height = 100;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Opacity(
        opacity: widget.opacity,
        child: Stack(
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  left += details.delta.dx;
                  top += details.delta.dy;
                  widget.getPositioned(top, left);
                });
              },
              child: SizedBox(
                width: width,
                height: height,
                child: widget.shape,
              ),
            ),
            // دوائر التعديل (تغيير الحجم) على الزوايا
            _buildResizeHandle(0, 0),
            // الزاوية العلوية اليسرى
            _buildResizeHandle(width - 15, 0),
            // الزاوية العلوية اليمنى
            _buildResizeHandle(0, height - 15),
            // الزاوية السفلية اليسرى
            _buildResizeHandle(width - 15, height - 15),
            // الزاوية السفلية اليمنى
          ],
        ),
      ),
    );
  }

  Widget _buildResizeHandle(double left, double top) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            final newWidth = width + details.delta.dx;
            final newHeight = height + details.delta.dy;
            // تغيير حجم الشكل حسب الحركة
            if (newWidth >= 40) {
              width += details.delta.dx;
            }
            if (newHeight >= 40) {
              height += details.delta.dy;
            }
          });
        },
        child: Container(
          width: 15,
          height: 15,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
