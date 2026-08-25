import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upgrade/api.dart';
import 'package:upgrade/controllers/card_view_controller.dart';
import 'package:upgrade/entity/shape_creator_entity.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/widgets/app_image.dart';
import 'package:upgrade/widgets/download_dialog.dart';

import 'document_screen.dart';

class CardViewScreen extends GetView<CardViewController> {
  const CardViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: AppColor.scaffoldBackgroundColor,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          body: SafeArea(
            child: Obx(
              () => PageView.builder(
                itemBuilder: (context, index) {
                  print(controller.getFrontAlign());
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Obx(
                      () => Column(
                        children: [
                          if (controller.cards[index].type == "OCCLUSION") ...[
                            HtmlWidget(
                              '''
  <div style="text-align:${controller.getFrontAlign()};" dir="${controller.isArabic(controller.getFrontText()) ? 'rtl' : 'ltr'}">
    ${controller.getFrontText().replaceAll('\n', '<br>')}
  </div>
  ''',
                              textStyle: TextStyle(
                                fontSize: controller.getFrontSize(),
                                color: Colors.black,
                              ),
                            ),
                            if (controller.data.image.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              SizedBox(
                                width: controller.data.imageData.width * width,
                                height:
                                    controller.data.imageData.height * height,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: AppImage(
                                        image: controller.data.image,
                                      ),
                                    ),
                                    Stack(
                                      children: List.generate(
                                        controller.data.shapes.length,
                                        (index) {
                                          return Obx(() {
                                            final item =
                                                controller.data.shapes[index];
                                            return ShapesWidget(
                                              item: item,
                                              onTap: () => controller
                                                  .onTapOnShape(index),
                                            );
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (controller.showAnswer) ...[
                              if (controller.getBackText().isNotEmpty) ...[
                                const SizedBox(height: 10),
                                const Divider(
                                  height: 0,
                                  thickness: 3,
                                  color: Colors.black,
                                ),
                                const SizedBox(height: 10),
                                HtmlWidget(
                                  '''
  <div style="text-align:${controller.getBackAlign()};" dir="${controller.isArabic(controller.getBackText()) ? 'rtl' : 'ltr'}">
    ${controller.getBackText().replaceAll('\n', '<br>')}
  </div>
  ''',
                                  textStyle: TextStyle(
                                    fontSize: controller.getBackSize(),
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                              if (controller.getCommentText().isNotEmpty) ...[
                                const SizedBox(height: 10),
                                const Divider(
                                  height: 0,
                                  thickness: 3,
                                  color: Colors.black,
                                ),
                                const SizedBox(height: 10),
                                HtmlWidget(
                                  '''
  <div style="text-align:${controller.getCommentAlign()};" dir="${controller.isArabic(controller.getCommentText()) ? 'rtl' : 'ltr'}">
    ${controller.getCommentText().replaceAll('\n', '<br>')}
  </div>
  ''',
                                  textStyle: TextStyle(
                                    fontSize: controller.getCommentSize(),
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ],
                          ] else ...[
                            HtmlWidget(
                              '''
  <div style="text-align:${controller.getFrontAlign()};" dir="${controller.isArabic(controller.getFrontText()) ? 'rtl' : 'ltr'}">
    ${controller.getFrontText().replaceAll('\n', '<br>')}
  </div>
  ''',
                              textStyle: TextStyle(
                                fontSize: controller.getFrontSize(),
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (controller
                                .cards[index].frontImageUrl.isNotEmpty)
                              AspectRatio(
                                aspectRatio: 4 / 3,
                                child: AppImage(
                                  image: controller.cards[index].frontImageUrl,
                                  radius: 10,
                                ),
                              ),
                            if (controller.showAnswer) ...[
                              const SizedBox(height: 10),
                              const Divider(
                                height: 0,
                                thickness: 3,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 10),
                              HtmlWidget(
                                '''
  <div style="text-align:${controller.getBackAlign()};" dir="${controller.isArabic(controller.getBackText()) ? 'rtl' : 'ltr'}">
    ${controller.getBackText().replaceAll('\n', '<br>')}
  </div>
  ''',
                                textStyle: TextStyle(
                                  fontSize: controller.getBackSize(),
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (controller
                                  .cards[index].backImageUrl.isNotEmpty)
                                AspectRatio(
                                  aspectRatio: 4 / 3,
                                  child: AppImage(
                                    image: controller.cards[index].backImageUrl,
                                    radius: 10,
                                  ),
                                ),
                            ],
                          ],
                          if (controller
                              .cards[index].documentTitle.isNotEmpty) ...[
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () async {
                                if (await isFileValid(controller
                                    .cards[index].documentUrl)) {
                                  final dir =
                                  await getApplicationDocumentsDirectory();
                                  final fileName = controller
                                      .cards[index].documentUrl
                                      .split("/")
                                      .last;
                                  final filePath =
                                      "${dir.path}/$fileName";
                                  OpenFilex.open(filePath);
                                } else {
                                  Get.dialog(DownloadDialog(
                                      file: "${Api.imageUrl}/${controller
                                          .cards[index].documentUrl}"));
                                }
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text:
                                          "There is a file for this card named: \n",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                    TextSpan(
                                      text: controller.cards[index].documentTitle,
                                      style: const TextStyle(
                                        color: AppColor.greenColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                          const Divider(
                            height: 0,
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: controller.cards.length,
                onPageChanged: controller.onChangePageViewIndex,
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.pageController,
              ),
            ),
          ),
          bottomNavigationBar: Obx(
            () {
              if (controller.isView) {
                return InkWell(
                  onTap: controller.toggleAnswer,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColor.greenColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.showAnswer ? "Hide Answer" : "Show Answer",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                if (controller.showAnswer) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (controller.cards[controller.pageViewIndex].type ==
                          "OCCLUSION") ...[
                        InkWell(
                          onTap: controller.changeToggleMask,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              color: const Color(0xFFCFCFCF),
                            ),
                            child: const Text(
                              'Toggle Mask',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10)
                      ],
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.red),
                                  padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(vertical: 4)),
                                ),
                                onPressed: () =>
                                    controller.onTapOnStatusButton("AGAIN"),
                                child: const Text(
                                  "Again",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      AppColor.lightRedColor),
                                  padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(vertical: 4)),
                                ),
                                onPressed: () =>
                                    controller.onTapOnStatusButton("HARD"),
                                child: const Text(
                                  "Hard",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      AppColor.greenColor),
                                  padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(vertical: 4)),
                                ),
                                onPressed: () =>
                                    controller.onTapOnStatusButton("GOOD"),
                                child: const Text(
                                  "Good",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      AppColor.lightGreenColor),
                                  padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(vertical: 4)),
                                ),
                                onPressed: () =>
                                    controller.onTapOnStatusButton("EASY"),
                                child: const Text(
                                  "Easy",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return InkWell(
                    onTap: controller.toggleAnswer,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColor.greenColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.showAnswer
                                ? "Hide Answer"
                                : "Show Answer",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }
}

class ShapesWidget extends StatefulWidget {
  final ShapeCreatorShapesEntity item;
  final void Function()? onTap;

  const ShapesWidget({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  State<ShapesWidget> createState() => _ShapesWidgetState();
}

class _ShapesWidgetState extends State<ShapesWidget> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    final color = widget.item.type == "Rectangle"
        ? Colors.blue
        : widget.item.type == "Circle"
            ? Colors.red
            : Colors.greenAccent;

    return PositionedDirectional(
      start: widget.item.position.x * width,
      top: widget.item.position.y * height,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: widget.onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: widget.item.isShow ? 1 : 0,
          child: Container(
            width: widget.item.width * width,
            height: widget.item.height * height,
            decoration: BoxDecoration(
              color: color,
              shape: widget.item.type == "Circle"
                  ? BoxShape.circle
                  : BoxShape.rectangle,
              border: Border.all(
                color: color,
                width: 1.5,
              ),
            ),
            child: widget.item.type == "TextBox"
                ? TextFormField(
                    expands: false,
                    readOnly: true,
                    enabled: false,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    controller: TextEditingController(text: widget.item.text),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: color,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
