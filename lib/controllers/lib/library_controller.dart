import 'package:get/get.dart';
import 'package:upgrade/controllers/years_controller.dart';
import 'package:upgrade/entity/deck_entity.dart';

enum LibraryFilter { all, mine, public }

class LibraryController extends GetxController {
  final yearsController = Get.find<YearsController>();

  final RxString query = "".obs;
  final Rx<LibraryFilter> filter = LibraryFilter.all.obs;

  /// Recursively walks the nested Year/Semester/Subject deck tree and
  /// collects every leaf CARDS_DECK — the actual flashcard sets a user
  /// can browse and study, regardless of how deep they're nested.
  List<DeckEntity> _flattenCardDecks(List<DeckEntity> decks) {
    final result = <DeckEntity>[];
    for (final deck in decks) {
      if (deck.type == "CARDS_DECK") {
        result.add(deck);
      } else {
        result.addAll(_flattenCardDecks(deck.children));
      }
    }
    return result;
  }

  List<DeckEntity> get filteredDecks {
    var decks = _flattenCardDecks(yearsController.decks);

    switch (filter.value) {
      case LibraryFilter.mine:
        decks = decks.where((d) => d.editable).toList();
        break;
      case LibraryFilter.public:
        decks = decks.where((d) => !d.editable).toList();
        break;
      case LibraryFilter.all:
        break;
    }

    if (query.value.trim().isNotEmpty) {
      final q = query.value.trim().toLowerCase();
      decks = decks.where((d) => d.title.toLowerCase().contains(q)).toList();
    }

    return decks;
  }
}
