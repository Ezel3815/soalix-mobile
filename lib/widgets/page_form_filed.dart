import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/add_card_controller.dart';
import 'package:upgrade/resources.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.surfaceColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Obx(
          () => TextField(
            style: TextStyle(
              fontSize: widget.type == FrontBackType.front
                  ? controller.selectedFontSizeFront
                  : widget.type == FrontBackType.back
                      ? controller.selectedFontSizeBack
                      : controller.selectedFontSizeComment,
              fontWeight: FontWeight.w400,
              color: AppColor.textPrimary,
            ),
            controller: widget.type == FrontBackType.front
                ? controller.controllerFront
                : widget.type == FrontBackType.back
                    ? controller.controllerBack
                    : controller.controllerComments,
            minLines: 1,
            maxLines: 4,
            cursorColor: AppColor.greenColor,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ),
    );
  }
}
