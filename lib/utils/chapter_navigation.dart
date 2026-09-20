import 'package:get/get.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/entity/deck_entity.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/widgets/app_snack_bar.dart';

/// Regular users tapping a chapter land directly in study mode. The deck
/// tree only carries slim card info (for progress), so the full cards are
/// fetched here. Owners of an editable deck go through the management list.
Future<void> openChapter(DeckEntity chapter) async {
  if (chapter.editable) {
    Get.toNamed(AppRoutes.cardRoute, arguments: chapter);
    return;
  }
  final cards = await ApiController.getCards(chapter.id);
  if (cards.isEmpty) {
    showSnackBarWidget(message: "لا توجد بطاقات في هذا الدرس");
    return;
  }
  Get.toNamed(
    AppRoutes.cardViewRoute,
    arguments: {
      "cards": cards,
      "isView": false,
      "initalIndex": 0,
    },
  );
}
