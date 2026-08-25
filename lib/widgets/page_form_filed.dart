import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/add_card_controller.dart';

class PageFormFiled extends StatefulWidget {
  final FrontBackType type;

  const PageFormFiled(this.type, {super.key});

  @override
  State<PageFormFiled> createState() => _PageFormFiledState();
}

class _PageFormFiledState extends State<PageFormFiled> {
  final controller = Get.find<AddCardController>();
  bool isArabic = false;

  @override
  void initState() {
    widget.type == FrontBackType.front
        ? controller.controllerFront.addListener(
            () {
              isArabic = controller.isArabic(controller.controllerFront.text);
              setState(() {});
            },
          )
        : widget.type == FrontBackType.back
            ? controller.controllerBack.addListener(
                () {
                  isArabic =
                      controller.isArabic(controller.controllerBack.text);
                  setState(() {});
                },
              )
            : controller.controllerComments.addListener(
                () {
                  isArabic =
                      controller.isArabic(controller.controllerComments.text);
                  setState(() {});
                },
              );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextField(
        style: TextStyle(
          fontSize: widget.type == FrontBackType.front
              ? controller.selectedFontSizeFront
              : widget.type == FrontBackType.back
                  ? controller.selectedFontSizeBack
                  : controller.selectedFontSizeComment,
          fontWeight: FontWeight.w400,
        ),
        controller: widget.type == FrontBackType.front
            ? controller.controllerFront
            : widget.type == FrontBackType.back
                ? controller.controllerBack
                : controller.controllerComments,
        minLines: 1,
        maxLines: 4,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
