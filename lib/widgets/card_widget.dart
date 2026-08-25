import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/entity/card_entity.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/resources.dart';

class CardWidget extends StatelessWidget {
  final CardEntity model;
  final bool isEdit;

  const CardWidget({super.key, required this.model, required this.isEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.greenColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            model.type,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (isEdit)
            InkWell(
              onTap: () {
                Get.toNamed(
                  AppRoutes.addCardRoute,
                  arguments: {
                    "id": model.deckId,
                    "isEdit": true,
                    "cardEntity": model,
                  },
                );
              },
              child: const Icon(
                Icons.edit,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }
}
