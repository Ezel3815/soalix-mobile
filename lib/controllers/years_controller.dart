import 'package:get/get.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/entity/deck_entity.dart';

class YearsController extends GetxController {
  final RxBool _loading = false.obs;

  List<DeckEntity> decks = [];

  bool get loading => _loading.value;

  set loading(value) => _loading.value = value;

  getAllDeck() async {
    loading = true;
    decks.clear();
    final responseDecks = await ApiController.getDecks();
    final responseMyDecks = await ApiController.getMyDecks();
    decks.addAll(responseDecks);
    decks.addAll(responseMyDecks);
    loading = false;
  }

  @override
  void onInit() async {
    await getAllDeck();
    super.onInit();
  }
}
