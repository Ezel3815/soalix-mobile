import 'dart:convert';
import 'package:get/get.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/entity/deck_entity.dart';
import 'package:upgrade/entity/profile_entity.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/models/user_model.dart';

class YearsController extends GetxController {
  final RxBool _loading = false.obs;

  List<DeckEntity> decks = [];

  final Rx<ProfileEntity?> profile = Rx<ProfileEntity?>(null);

  bool get loading => _loading.value;

  set loading(value) => _loading.value = value;

  getAllDeck() async {
    // Only show the full-screen spinner on the very first load.
    // On refreshes, keep showing the existing decks while new data loads.
    final isFirstLoad = decks.isEmpty;
    if (isFirstLoad) loading = true;

    final results = await Future.wait([
      ApiController.getDecks(),
      ApiController.getMyDecks(),
    ]);

    decks = [...results[0], ...results[1]];
    loading = false;
  }

  int? _getMyId() {
    final userJson = sharedPref.getString("user");
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson)).id;
  }

  getMyProfile() async {
    final id = _getMyId();
    if (id == null) return;
    profile.value = await ApiController.getProfile(id);
  }

  @override
  void onInit() async {
    await Future.wait([
      getAllDeck(),
      getMyProfile(),
    ]);
    super.onInit();
  }
}
