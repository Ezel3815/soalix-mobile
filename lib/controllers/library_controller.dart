import 'package:get/get.dart';
import 'package:upgrade/controllers/years_controller.dart';
import 'package:upgrade/entity/deck_entity.dart';

enum LibraryFilter { all, mine, public }

class LibraryController extends GetxController {
  final yearsController = Get.find<YearsController>();

  final RxString query = "".obs;
  final Rx<LibraryFilter> filter = LibraryFilter.all.obs;

  /// A "subject" is a PACKAGE_DECK whose direct children are all leaf
  /// CARDS_DECK (chapters) — one level above the chapters, e.g.
  /// "English Vocabulary" containing several lesson chapters. This is
  /// the same convention used for Progress's subject breakdown.
  List<DeckEntity> _collectSubjects(List<DeckEntity> decks) {
    final result = <DeckEntity>[];
    for (final deck in decks) {
      if (deck.type != "PACKAGE_DECK") continue;
      final isSubjectLevel = deck.children.isNotEmpty &&
          deck.children.every((c) => c.type == "CARDS_DECK");
      if (isSubjectLevel) {
        result.add(deck);
      } else {
        result.addAll(_collectSubjects(deck.children));
      }
    }
    return result;
  }

  List<DeckEntity> get filteredSubjects {
    var subjects = _collectSubjects(yearsController.decks);

    switch (filter.value) {
      case LibraryFilter.mine:
        subjects = subjects.where((d) => d.editable).toList();
        break;
      case LibraryFilter.public:
        subjects = subjects.where((d) => !d.editable).toList();
        break;
      case LibraryFilter.all:
        break;
    }

    if (query.value.trim().isNotEmpty) {
      final q = query.value.trim().toLowerCase();
      subjects = subjects.where((d) => d.title.toLowerCase().contains(q)).toList();
    }

    return subjects;
  }
}
