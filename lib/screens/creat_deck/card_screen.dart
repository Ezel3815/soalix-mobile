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
              backgroundColor: AppColor.greenColor,
              elevation: 3,
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
                size: 28,
                color: Colors.white,
              ),
            ),
      body: Container(
        width: double.infinity,
        height: screenHeight,
        decoration: const BoxDecoration(
          color: AppColor.scaffoldBackgroundColor,
          image: DecorationImage(
            image: AssetImage('lib/assests/images/background_5.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 26,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          height: 28,
                          width: 100,
                          fit: BoxFit.contain,
                          alignment: Alignment.centerLeft,
                          'lib/assests/images/logodeck.png',
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "Cards",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (controller.deck.editable)
                      InkWell(
                        onTap: () {
                          controller.editDeckController.text =
                              controller.deck.title;
                          Get.dialog(const EditDeckDialog());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColor.surfaceColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            size: 22,
                            color: AppColor.textPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => Expanded(
                  child: controller.loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.greenColor,
                          ),
                        )
                      : controller.cards.isEmpty
                          ? const Center(
                              child: Text(
                                "No cards yet",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.textSecondary,
                                ),
                              ),
                            )
                          : Obx(
                              () => ListView.separated(
                                padding: const EdgeInsets.only(bottom: 20),
                                itemBuilder: (context, index) => InkWell(
                                  borderRadius: BorderRadius.circular(16),
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
            ],
          ),
        ),
      ),
    );
  }
}
