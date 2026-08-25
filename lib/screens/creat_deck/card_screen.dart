import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/card_controller.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/screens/app_drawer.dart';
import 'package:upgrade/widgets/card_widget.dart';
import 'package:upgrade/widgets/edit_deck_dialog.dart';

class CardScreen extends GetView<CardController> {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;


    return Scaffold(
      drawer: const AppDrawer(),
      key: controller.scaffoldKey,
      drawerEnableOpenDragGesture: false,
      floatingActionButton: !controller.deck.editable
          ? null
          : FloatingActionButton(
              backgroundColor: AppColor.lightGreenColor,
              onPressed: () {
                Get.toNamed(
                  AppRoutes.addCardRoute,
                  arguments: {
                    "id": controller.deck.id,
                    "isEdit": false,
                  },
                );
              },
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.black,
              ),
            ),
      body: Container(
        width: double.infinity,
        height: screenHeight,
        decoration: const BoxDecoration(
          color: AppColor.scaffoldBackgroundColor,
          image: DecorationImage(
            image: AssetImage('lib/assests/images/background_5.jpg'),
            fit: BoxFit.fill, // يمكنك تعديل هذا الخيار حسب الحاجة
          ),
        ),
        child: SafeArea(
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
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 35,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        height: 30,
                        width: 100,
                        'lib/assests/images/logodeck.png',
                      ),
                      Text(
                        "Add Cards",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(.4),
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  if (controller.deck.editable)
                    IconButton(
                      onPressed: () {
                        controller.editDeckController.text =
                            controller.deck.title;
                        Get.dialog(const EditDeckDialog());
                      },
                      icon: const Icon(
                        Icons.edit,
                      ),
                    ),
                  // IconButton(
                  //   onPressed: () {
                  //     Get.dialog(
                  //        DeleteDialog(
                  //         title: "Are you sure you want to delete this deck ?",
                  //          onTapDelete: controller.deleteDeck,
                  //       ),
                  //     );
                  //   },
                  //   icon: const Icon(
                  //     Icons.delete_forever,
                  //     color: Colors.red,
                  //   ),
                  // ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Obx(
                () => Expanded(
                  child: controller.loading
                      ? const Center(child: CircularProgressIndicator())
                      : controller.cards.isEmpty
                          ? const Center(
                              child: Text(
                                "No Data Found",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : Obx(
                              () => ListView.separated(
                                padding: const EdgeInsets.only(bottom: 20),
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    Get.toNamed(
                                      AppRoutes.cardViewRoute,
                                      arguments: {
                                        "cards": controller.cards,
                                        "isView": false,
                                        'initalIndex': index,
                                      },
                                    );
                                  },
                                  child: CardWidget(
                                    model: controller.cards[index],
                                    isEdit: controller.deck.editable,
                                  ),
                                ),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10),
                                itemCount: controller.cards.length,
                              ),
                            ),
                ),
              ),
              // const Row(
              //   children: [
              //     SizedBox(
              //       width: 10,
              //     ),
              //     Text(
              //         textAlign: TextAlign.left,
              //         'studied 0 cards in 0 seconds today (0s/card)',
              //         style: TextStyle(
              //             fontSize: 16,
              //             color: Colors.black)),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
