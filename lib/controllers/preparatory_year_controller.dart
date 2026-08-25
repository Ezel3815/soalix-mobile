import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/entity/deck_entity.dart';

class PreparatoryYearController extends GetxController {
  late List<DeckEntity> decks;
  late int id;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void onInit() {
    id = Get.arguments['id'];
    decks = Get.arguments['decks'];
    super.onInit();
  }
}
