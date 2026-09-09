import 'package:get/get.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/entity/deck_entity.dart';

class YearsController extends GetxController {
  final RxBool _loading = false.obs;

  List<DeckEntity> decks = [];

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

  @override
  void onInit() async {
    await getAllDeck();
    super.onInit();
  }
}
