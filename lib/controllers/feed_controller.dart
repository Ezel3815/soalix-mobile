import 'package:get/get.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/entity/feed_entity.dart';
import 'package:upgrade/main.dart';

class FeedController extends GetxController {
  final RxList<FeedPost> posts = <FeedPost>[].obs;
  final RxBool loading = false.obs;
  final RxBool failed = false.obs;

  // ── Unread indicator (small red dot on the feed tab) ──────────────
  // Tracks the highest post id from people you follow that you've
  // actually opened the feed to see. Your own posts don't count — you
  // already know about those, you just made them.
  static const _kLastSeenId = "feed_last_seen_activity_id";
  final RxBool hasUnread = false.obs;

  int get _highestFriendId {
    final friendIds = posts.where((p) => !p.mine).map((p) => p.id);
    return friendIds.isEmpty ? 0 : friendIds.reduce((a, b) => a > b ? a : b);
  }

  void _refreshUnreadFlag() {
    final lastSeen = sharedPref.getInt(_kLastSeenId) ?? 0;
    hasUnread.value = _highestFriendId > lastSeen;
  }

  /// Call when the feed screen is actually opened and visible — clears
  /// the dot for everything currently loaded.
  Future<void> markSeen() async {
    if (!hasUnread.value) return;
    await sharedPref.setInt(_kLastSeenId, _highestFriendId);
    hasUnread.value = false;
  }

  Future<void> load() async {
    if (posts.isEmpty) loading.value = true;
    final data = await ApiController.getFeed();
    if (data == null) {
      failed.value = posts.isEmpty;
    } else {
      failed.value = false;
      posts.assignAll(data);
      _refreshUnreadFlag();
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
