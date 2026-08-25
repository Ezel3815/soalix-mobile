import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/entity/deck_entity.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/widgets/app_snack_bar.dart';

class DeckWidget extends StatelessWidget {
  final DeckEntity model;

  const DeckWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (model.locked) {
          showSnackBarWidget(
              message: "This deck is locked call support to unlock deck");
          return;
        }
        if (model.type == "PACKAGE_DECK") {
          Get.toNamed(
            AppRoutes.preparatoryYearRoute,
            arguments: {
              "id": model.id,
              "decks": model.children,
            },
            preventDuplicates: false,
          );
        } else {
          /// CARDS_DECK
          Get.toNamed(
            AppRoutes.cardRoute,
            arguments: model,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        decoration: BoxDecoration(
          color: AppColor.greenColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              model.title,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${getEasyGoodCard()}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text: " ${getAgainCard()}",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text: " ${getHardCard()}",
                    style: const TextStyle(
                      color: AppColor.lightRedColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            if (model.locked) ...[
              const SizedBox(width: 10),
              const Icon(
                Icons.lock,
                color: Colors.black,
              ),
            ],
          ],
        ),
      ),
    );
  }

  int getEasyGoodCard() {
    return model.cards
        .where(
            (element) => element.answer == "EASY" || element.answer == "GOOD")
        .toList()
        .length;
  }

  int getAgainCard() {
    return model.cards
        .where((element) => element.answer == "AGAIN")
        .toList()
        .length;
  }

  int getHardCard() {
    return model.cards
        .where((element) => element.answer == "HARD")
        .toList()
        .length;
  }
}
