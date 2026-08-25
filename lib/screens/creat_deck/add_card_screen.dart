import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:upgrade/controllers/add_card_controller.dart';
import 'package:upgrade/entity/card_entity.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/widgets/delete_dialog.dart';
import 'package:upgrade/widgets/page_form_filed.dart';
import 'package:upgrade/widgets/page_title_image.dart';
import 'package:upgrade/widgets/tools_status_bar.dart';

class AddCardScreen extends GetView<AddCardController> {
  const AddCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.scaffoldBackgroundColor,
        title: const Text(
          'Add Card',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: controller.addCard,
            icon: Image.asset(
              'lib/assests/images/Done.png',
              color: Colors.black,
              width: 20,
              height: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              final CardEntity card = CardEntity(
                type: controller.selectedTypes,
                data: jsonEncode(controller.getCardData()),
                answer: "answer",
                id: 0,
                backImageUrl: controller.backImage,
                createdAt: "createdAt",
                deckId: 0,
                documentTitle: "",
                documentUrl: "",
                frontImageUrl: controller.frontImage,
                order: 0,
                answers: [],
              );

              Get.toNamed(
                AppRoutes.cardViewRoute,
                arguments: {
                  "cards": [card],
                  "isView": true,
                  'initalIndex' : 0,
                },
              );
            },
            icon: const Icon(
              Icons.remove_red_eye,
              color: Colors.black,
            ),
          ),
          if (controller.isEdit)
            IconButton(
              onPressed: () {
                Get.dialog(
                  DeleteDialog(
                    title: "Are you sure to delete this card ?",
                    onTapDelete: controller.deleteCard,
                  ),
                );
              },
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
            ),
        ],
      ),
      body: Obx(
        () => Container(
          width: double.infinity,
          height: screenHeight,
          decoration: const BoxDecoration(
            color: AppColor.scaffoldBackgroundColor,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Type:',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                        height: 25,
                        child: DropdownButtonFormField<String>(
                          decoration:
                              const InputDecoration.collapsed(hintText: ''),
                          iconSize: 40,
                          iconEnabledColor: Colors.black,
                          value: controller.selectedTypes,
                          items: controller.types
                              .map<DropdownMenuItem<String>>(
                                (String level) => DropdownMenuItem<String>(
                                  value: level,
                                  child: Text(
                                    level,
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: controller.onChangeTypeValue,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                if (controller.selectedTypes == "BASIC")
                   const Column(
                    children: [
                      PageTitleImage(CardTypes.basic, FrontBackType.front),
                      PageFormFiled(FrontBackType.front),
                      ToolsStatusBar(CardTypes.basic, FrontBackType.front),
                      PageTitleImage(CardTypes.basic, FrontBackType.back),
                      PageFormFiled(FrontBackType.back),
                      ToolsStatusBar(CardTypes.basic, FrontBackType.back),
                    ],
                  )
                else if (controller.selectedTypes == "CLOZE")
                  const Column(
                    children: [
                      PageTitleImage(CardTypes.cloze, FrontBackType.front),
                      PageFormFiled(FrontBackType.front),
                      ToolsStatusBar(CardTypes.cloze, FrontBackType.front),
                      PageTitleImage(CardTypes.cloze, FrontBackType.back),
                      PageFormFiled(FrontBackType.back),
                      ToolsStatusBar(CardTypes.cloze, FrontBackType.back),
                    ],
                  )
                else if (controller.selectedTypes == "OCCLUSION")
                  Column(
                    children: [
                      const PageTitleImage(
                          CardTypes.occlusion, FrontBackType.front),
                      const PageFormFiled(FrontBackType.front),
                      const ToolsStatusBar(
                          CardTypes.occlusion, FrontBackType.front),
                      const PageTitleImage(
                          CardTypes.occlusion, FrontBackType.back),
                      const PageFormFiled(FrontBackType.back),
                      const ToolsStatusBar(
                          CardTypes.occlusion, FrontBackType.back),
                      const PageTitleImage(
                          CardTypes.occlusion, FrontBackType.comments),
                      const PageFormFiled(FrontBackType.comments),
                      const ToolsStatusBar(
                          CardTypes.occlusion, FrontBackType.comments),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: controller.goToShapeCreator,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              color: const Color(0xCFCFCFCF)),
                          width: 300,
                          child: const Center(
                              child: Text(
                            'Select Image',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          )),
                        ),
                      )
                    ],
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (controller.user.role == 'ADMIN') ...[
                  if (controller.file.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              controller.fileName,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: controller.clearFile,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  else
                    InkWell(
                      onTap: controller.pickFile,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            color: const Color(0xCFCFCFCF)),
                        width: 300,
                        child: const Center(
                            child: Text(
                          'Add PDF File',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        )),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
