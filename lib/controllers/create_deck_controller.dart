import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/controllers/years_controller.dart';
import 'package:upgrade/entity/deck_entity.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/widgets/app_snack_bar.dart';

class CreateDeckController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final deckController = TextEditingController();
  final yearsController = Get.find<YearsController>();

  DeckEntity? deck;

  createDeck() async {
    if (formKey.currentState!.validate()) {
      showAppLoadingDialog();
      deck = await ApiController.createDeck(deckController.text);
      Get.back();
      if (deck != null) {
        Get.back();
        Get.toNamed(AppRoutes.cardRoute, arguments: deck);
        yearsController.getAllDeck();
      }
    }
  }
}
