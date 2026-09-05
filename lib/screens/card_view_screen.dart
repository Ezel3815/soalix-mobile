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
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
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
                                color: AppColor.textPrimary,
                              ),
                            ),
                            if (controller.data.image.isNotEmpty) ...[
                              const SizedBox(height: 14),
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
                                const SizedBox(height: 14),
                                Divider(
                                  height: 0,
                                  thickness: 1,
                                  color: Colors.black.withOpacity(0.08),
                                ),
                                const SizedBox(height: 14),
                                HtmlWidget(
                                  '''
  <div style="text-align:${controller.getBackAlign()};" dir="${controller.isArabic(controller.getBackText()) ? 'rtl' : 'ltr'}">
    ${controller.getBackText().replaceAll('\n', '<br>')}
  </div>
  ''',
                                  textStyle: TextStyle(
                                    fontSize: controller.getBackSize(),
                                    color: AppColor.textPrimary,
                                  ),
                                ),
                              ],
                              if (controller.getCommentText().isNotEmpty) ...[
                                const SizedBox(height: 14),
                                Divider(
                                  height: 0,
                                  thickness: 1,
                                  color: Colors.black.withOpacity(0.08),
                                ),
                                const SizedBox(height: 14),
                                HtmlWidget(
                                  '''
  <div style="text-align:${controller.getCommentAlign()};" dir="${controller.isArabic(controller.getCommentText()) ? 'rtl' : 'ltr'}">
    ${controller.getCommentText().replaceAll('\n', '<br>')}
  </div>
  ''',
                                  textStyle: TextStyle(
                                    fontSize: controller.getCommentSize(),
                                    color: AppColor.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 14),
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
                                color: AppColor.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 14),
                            if (controller
                                .cards[index].frontImageUrl.isNotEmpty)
                              AspectRatio(
                                aspectRatio: 4 / 3,
                                child: AppImage(
                                  image: controller.cards[index].frontImageUrl,
                                  radius: 16,
                                ),
                              ),
                            if (controller.showAnswer) ...[
                              const SizedBox(height: 14),
                              Divider(
                                height: 0,
                                thickness: 1,
                                color: Colors.black.withOpacity(0.08),
                              ),
                              const SizedBox(height: 14),
                              HtmlWidget(
                                '''
  <div style="text-align:${controller.getBackAlign()};" dir="${controller.isArabic(controller.getBackText()) ? 'rtl' : 'ltr'}">
    ${controller.getBackText().replaceAll('\n', '<br>')}
  </div>
  ''',
                                textStyle: TextStyle(
                                  fontSize: controller.getBackSize(),
                                  color: AppColor.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 14),
                              if (controller
                                  .cards[index].backImageUrl.isNotEmpty)
                                AspectRatio(
                                  aspectRatio: 4 / 3,
                                  child: AppImage(
                                    image: controller.cards[index].backImageUrl,
                                    radius: 16,
                                  ),
                                ),
                            ],
                          ],
                          if (controller
                              .cards[index].documentTitle.isNotEmpty) ...[
                            const SizedBox(height: 14),
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
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColor.surfaceColor,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text:
                                            "Attached file: \n",
                                        style: TextStyle(
                                          color: AppColor.textSecondary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: controller.cards[index].documentTitle,
                                        style: const TextStyle(
                                          color: AppColor.greenColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
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
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColor.greenColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.showAnswer ? "Hide Answer" : "Show Answer",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                if (controller.showAnswer) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: AppColor.scaffoldBackgroundColor,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (controller.cards[controller.pageViewIndex].type ==
                            "OCCLUSION") ...[
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: controller.changeToggleMask,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColor.greenColor,
                                  width: 1.2,
                                ),
                                color: AppColor.surfaceColor,
                              ),
                              child: const Text(
                                'Toggle Mask',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.greenColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: _GradeButton(
                                  label: "Again",
                                  color: const Color(0xFFE4574C),
                                  textColor: Colors.white,
                                  onTap: () => controller
                                      .onTapOnStatusButton("AGAIN"),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _GradeButton(
                                  label: "Hard",
                                  color: const Color(0xFFE8A33D),
                                  textColor: Colors.white,
                                  onTap: () =>
                                      controller.onTapOnStatusButton("HARD"),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _GradeButton(
                                  label: "Good",
                                  color: AppColor.greenColor,
                                  textColor: Colors.white,
                                  onTap: () =>
                                      controller.onTapOnStatusButton("GOOD"),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _GradeButton(
                                  label: "Easy",
                                  color: AppColor.lightGreenColor,
                                  textColor: AppColor.textPrimary,
                                  onTap: () =>
                                      controller.onTapOnStatusButton("EASY"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return InkWell(
                    onTap: controller.toggleAnswer,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppColor.greenColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
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
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
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

class _GradeButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _GradeButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
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
