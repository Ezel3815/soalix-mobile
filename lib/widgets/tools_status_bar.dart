import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/add_card_controller.dart';
import 'package:upgrade/resources.dart';

class ToolsStatusBar extends GetView<AddCardController> {
  final CardTypes type;
  final FrontBackType type2;

  const ToolsStatusBar(this.type, this.type2, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.format_bold),
              onPressed: () {
                controller.toggleBold(type2);
              },
            ),
            IconButton(
              icon: const Icon(Icons.format_italic),
              onPressed: () {
                controller.toggleItalic(type2);
              },
            ),
            IconButton(
              icon: const Icon(Icons.format_underline),
              onPressed: () {
                controller.toggleUnderline(type2);
              },
            ),
            IconButton(
              icon: const Icon(Icons.format_strikethrough),
              onPressed: () {
                controller.toggleStrikethrough(type2);
              },
            ),
            IconButton(
              icon: const Icon(Icons.color_lens_sharp),
              onPressed: () {
                controller.pickColor(type2);
              },
            ),
            IconButton(
              icon: const Icon(Icons.font_download),
              onPressed: () {
                controller.toggleFontSize(type2);
              },
            ),
            if (type == CardTypes.cloze && type2 == FrontBackType.front)
              IconButton(
                icon: const Icon(Icons.tag),
                onPressed: () {
                  controller.addBraces();
                },
              ),
          ],
        ),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  controller.addAlignToText(type2, TextAlign.start);
                },
                icon: Icon(
                  Icons.align_horizontal_left,
                  color: (controller.selectedAlignFront == TextAlign.start &&
                              type2 == FrontBackType.front) ||
                          (controller.selectedAlignBack == TextAlign.start &&
                              type2 == FrontBackType.back) ||
                          (controller.selectedAlignComment == TextAlign.start &&
                              type2 == FrontBackType.comments)
                      ? AppColor.greenColor
                      : null,
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.addAlignToText(type2, TextAlign.center);
                },
                icon: Icon(
                  Icons.align_horizontal_center,
                  color: (controller.selectedAlignFront == TextAlign.center &&
                              type2 == FrontBackType.front) ||
                          (controller.selectedAlignBack == TextAlign.center &&
                              type2 == FrontBackType.back) ||
                          (controller.selectedAlignComment ==
                                  TextAlign.center &&
                              type2 == FrontBackType.comments)
                      ? AppColor.greenColor
                      : null,
                ),
              ),
              IconButton(
                  onPressed: () {
                    controller.addAlignToText(
                      type2,
                      TextAlign.end,
                    );
                  },
                  icon: Icon(
                    Icons.align_horizontal_right,
                    color: (controller.selectedAlignFront == TextAlign.end &&
                                type2 == FrontBackType.front) ||
                            (controller.selectedAlignBack == TextAlign.end &&
                                type2 == FrontBackType.back) ||
                            (controller.selectedAlignComment == TextAlign.end &&
                                type2 == FrontBackType.comments)
                        ? AppColor.greenColor
                        : null,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
