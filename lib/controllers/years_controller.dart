import 'dart:convert';
import 'package:get/get.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/entity/activity_feed_item.dart';
import 'package:upgrade/entity/daily_mission.dart';
import 'package:upgrade/entity/deck_entity.dart';
import 'package:upgrade/entity/profile_entity.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/models/user_model.dart';
import 'package:upgrade/services/notification_service.dart';

class YearsController extends GetxController {
  final RxBool _loading = false.obs;

  // Must be reactive (RxList), not a plain List — Obx widgets elsewhere
  // (progress card, learning path list) read this directly, and GetX
  // throws "improper use of GetX" if there's no observable inside an
  // Obx scope. RxList behaves like a normal List everywhere else it's
  // read (Progress, Library, etc. all keep working unchanged).
  final RxList<DeckEntity> decks = <DeckEntity>[].obs;

  final Rx<ProfileEntity?> profile = Rx<ProfileEntity?>(null);
  final RxList<ActivityFeedItem> activityFeed = <ActivityFeedItem>[].obs;
  final RxList<DailyMission> missions = <DailyMission>[].obs;

  bool get loading => _loading.value;

  set loading(value) => _loading.value = value;

  /// A "subject" is a PACKAGE_DECK whose direct children are all leaf
  /// CARDS_DECK (chapters) — same convention used by Library/Progress.
  List<DeckEntity> _collectSubjects(List<DeckEntity> nodes) {
    final result = <DeckEntity>[];
    for (final node in nodes) {
      if (node.type != "PACKAGE_DECK") continue;
      final isSubjectLevel = node.children.isNotEmpty &&
          node.children.every((c) => c.type == "CARDS_DECK");
      if (isSubjectLevel) {
        result.add(node);
      } else {
        result.addAll(_collectSubjects(node.children));
      }
    }
    return result;
  }

  bool _isSubjectComplete(DeckEntity subject) {
    final cards = subject.children.expand((c) => c.cards).toList();
    if (cards.isEmpty) return false;
    return cards.every((c) => c.answer.isNotEmpty && c.answer != "NONE");
  }

  /// The subject Home should show front-and-center: the first one with
  /// unfinished chapters. Falls back to the first subject at all if
  /// every subject is complete (or none has any cards yet), and to
  /// null only when there are no subjects in the tree at all.
  DeckEntity? get currentSubject {
    final subjects = _collectSubjects(decks);
    if (subjects.isEmpty) return null;
    return subjects.firstWhere(
      (s) => !_isSubjectComplete(s),
      orElse: () => subjects.first,
    );
  }

  Future<void> getAllDeck() async {
    // Only show the full-screen spinner on the very first load.
    // On refreshes, keep showing the existing decks while new data loads.
    final isFirstLoad = decks.isEmpty;
    if (isFirstLoad) loading = true;

    final results = await Future.wait([
      ApiController.getDecks(),
      ApiController.getMyDecks(),
    ]);

    decks.assignAll([...results[0], ...results[1]]);
    loading = false;
  }

  int? _getMyId() {
    final userJson = sharedPref.getString("user");
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson)).id;
  }

  Future<void> getMyProfile() async {
    final id = _getMyId();
    if (id == null) return;
    profile.value = await ApiController.getProfile(id);
  }

  Future<void> getActivityFeed() async {
    activityFeed.assignAll(await ApiController.getActivityFeed());
  }

  Future<void> getDailyMissions() async {
    missions.assignAll(await ApiController.getDailyMissions());
  }

  @override
  void onInit() async {
    await Future.wait([
      getAllDeck(),
      getMyProfile(),
      getActivityFeed(),
      getDailyMissions(),
    ]);
    // Fire-and-forget: don't block Home from loading on this.
    NotificationService.instance.requestPermission().then(
        (_) => NotificationService.instance.scheduleNextReminders());
    super.onInit();
  }
}
