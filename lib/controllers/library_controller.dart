import 'package:get/get.dart';
import 'package:upgrade/controllers/years_controller.dart';
import 'package:upgrade/entity/deck_entity.dart';

enum LibraryFilter { all, mine, public }

class LibraryController extends GetxController {
  final yearsController = Get.find<YearsController>();

  final RxString query = "".obs;
  final Rx<LibraryFilter> filter = LibraryFilter.all.obs;

  /// null = "All Years". Otherwise the id of a top-level year deck —
  /// defaults to whichever year the user is currently progressing
  /// through, so a 3rd-year student isn't stuck scanning every other
  /// year's subjects just to find their own.
  final Rx<int?> selectedYearId = Rx<int?>(null);

  /// Top-level nodes of the deck tree — each one is a "year"
  /// (e.g. السنة التحضيرية، السنة الثانية...).
  List<DeckEntity> get availableYears =>
      yearsController.decks.where((d) => d.type == "PACKAGE_DECK").toList();

  @override
  void onInit() {
    _pickDefaultYear();
    super.onInit();
  }

  void _pickDefaultYear() {
    final current = yearsController.currentSubject;
    if (current == null) return;
    for (final year in availableYears) {
      if (_collectSubjects([year]).any((s) => s.id == current.id)) {
        selectedYearId.value = year.id;
        return;
      }
    }
  }

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
    final roots = selectedYearId.value == null
        ? yearsController.decks
        : yearsController.decks
            .where((d) => d.id == selectedYearId.value)
            .toList();
    var subjects = _collectSubjects(roots);

    switch (filter.value) {
      case LibraryFilter.mine:
        // Decks this user created/owns.
        subjects = subjects.where((d) => d.editable).toList();
        break;
      case LibraryFilter.public:
        // Decks marked public by their owner — was incorrectly using
        // "!editable" before, which meant "anything I didn't create"
        // rather than the deck's own public flag.
        subjects = subjects.where((d) => d.public).toList();
        break;
      case LibraryFilter.all:
        break;
    }

    if (query.value.trim().isNotEmpty) {
      final q = query.value.trim().toLowerCase();
      subjects =
          subjects.where((d) => d.title.toLowerCase().contains(q)).toList();
    }

    return subjects;
  }
}
