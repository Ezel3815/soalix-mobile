import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/main.dart';

/// App-wide language switch, Arabic <-> English. Persisted so it
/// survives restarts. This only flips the framework-level locale
/// (which drives RTL/LTR direction and date/number formatting) plus
/// whatever's already centralized in AppStrings — screens that still
/// hardcode Arabic text inline aren't affected by this yet and need
/// migrating into AppStrings over time to pick up translation.
class LocaleController extends GetxController {
  static const _key = "app_locale";

  final RxString languageCode = "ar".obs;

  bool get isEnglish => languageCode.value == "en";

  @override
  void onInit() {
    languageCode.value = sharedPref.getString(_key) ?? "ar";
    super.onInit();
  }

  Future<void> setLanguage(String code) async {
    languageCode.value = code;
    await sharedPref.setString(_key, code);
    Get.updateLocale(Locale(code));
  }

  Future<void> toggle() async {
    await setLanguage(isEnglish ? "ar" : "en");
  }
}
