import 'package:get/get.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/entity/feed_entity.dart';

class FeedController extends GetxController {
  final RxList<FeedPost> posts = <FeedPost>[].obs;
  final RxBool loading = false.obs;
  final RxBool failed = false.obs;

  Future<void> load() async {
    if (posts.isEmpty) loading.value = true;
    final data = await ApiController.getFeed();
    if (data == null) {
      failed.value = posts.isEmpty;
    } else {
      failed.value = false;
      posts.assignAll(data);
    }
    loading.value = false;
  }

  /// Optimistic "celebrate" toggle, reverted if the server refuses.
  Future<void> toggleCelebrate(FeedPost p) async {
    if (p.mine) return;
    final wasCelebrated = p.celebrated;
    final wasCount = p.celebrations;
    p.celebrated = !wasCelebrated;
    p.celebrations = wasCount + (p.celebrated ? 1 : -1);
    posts.refresh();

    final r = await ApiController.celebratePost(p.id);
    if (r == null) {
      p.celebrated = wasCelebrated;
      p.celebrations = wasCount;
    } else {
      p.celebrated = r['celebrated'] == true;
      final c = r['count'];
      if (c is num) p.celebrations = c.toInt();
    }
    posts.refresh();
  }
}
