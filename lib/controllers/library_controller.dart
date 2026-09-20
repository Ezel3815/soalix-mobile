import 'package:get/get.dart';
import 'package:upgrade/controllers/years_controller.dart';
import 'package:upgrade/entity/deck_entity.dart';

enum LibraryFilter { all, mine, created }

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
      // A subject is any package holding chapters (card decks) directly —
      // even if it also holds sub-packages (previously such mixed
      // subjects, and their chapters, were dropped).
      final hasChapters = deck.children.any((c) => c.type == "CARDS_DECK");
      // Locked subjects come back from the server with no children;
      // still list them (marked locked) instead of hiding them.
      final isLockedSubject = deck.locked && deck.children.isEmpty;
      if (hasChapters || isLockedSubject) result.add(deck);
      result.addAll(_collectSubjects(
          deck.children.where((c) => c.type == "PACKAGE_DECK").toList()));
    }
    return result;
  }

  List<DeckEntity> get _createdDecks => yearsController.decks
      .where((d) => !d.byAdmin && d.editable && d.type == "CARDS_DECK")
      .toList();

  List<DeckEntity> get filteredSubjects {
    final roots = selectedYearId.value == null
        ? yearsController.decks
        : yearsController.decks
            .where((d) => d.id == selectedYearId.value)
            .toList();
    var subjects = _collectSubjects(roots);

    switch (filter.value) {
      case LibraryFilter.mine:
        // Subjects that are unlocked for this user.
        subjects = subjects.where((d) => !d.locked).toList();
        break;
      case LibraryFilter.created:
        // Decks this user created themselves.
        subjects = _createdDecks;
        break;
      case LibraryFilter.all:
        if (selectedYearId.value == null) {
          subjects = [...subjects, ..._createdDecks];
        }
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
