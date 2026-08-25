import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/controllers/years_controller.dart';

class InterCodeController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final yearsController = Get.find<YearsController>();

  final RxBool _loading = false.obs;

  bool get loading => _loading.value;

  set loading(value) => _loading.value = value;

  enterCode() async {
    if (formKey.currentState!.validate()) {
      loading = true;
      if(await ApiController.enterCode(codeController.text)) {
        if(Get.isDialogOpen == true) {
          Get.back();
          yearsController.getAllDeck();
        }
      }
      loading = false;
    }
  }
}
