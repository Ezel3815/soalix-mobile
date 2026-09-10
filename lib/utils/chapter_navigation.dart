import 'package:get/get.dart';
import 'package:upgrade/entity/deck_entity.dart';
import 'package:upgrade/main.dart';

/// Regular users tapping a chapter should land directly in study mode —
/// no intermediate "manage cards" list, no card-type labels (those only
/// ever showed on that management screen). Owners of an editable deck
/// still go through the existing management list (CardScreen) so they
/// can add/edit/delete cards, exactly as before.
void openChapter(DeckEntity chapter) {
  if (chapter.editable) {
    Get.toNamed(AppRoutes.cardRoute, arguments: chapter);
  } else {
    Get.toNamed(
      AppRoutes.cardViewRoute,
      arguments: {
        "cards": chapter.cards,
        "isView": false,
        "initalIndex": 0,
      },
    );
  }
}
