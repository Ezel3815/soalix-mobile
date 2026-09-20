import 'dart:async';

import 'package:get/get.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/entity/profile_entity.dart';

/// Search for people by name or username.
///
/// Two things keep the list correct while typing:
///  * a short pause (debounce) so a request is not sent for every letter,
///  * an answer is only used if it belongs to the LATEST thing typed — a
///    slow answer for "a" can no longer replace the answer for "ahmed".
class SearchUsersController extends GetxController {
  final RxList<ProfileEntity> results = <ProfileEntity>[].obs;
  final RxBool loading = false.obs;

  /// What the search box currently contains (trimmed).
  final RxString query = ''.obs;

  Timer? _debounce;
  int _latestRequest = 0;

  void search(String text) {
    _debounce?.cancel();
    final q = text.trim();
    query.value = q;
    final id = ++_latestRequest;

    if (q.isEmpty) {
      results.clear();
      loading.value = false;
      return;
    }

    loading.value = true;
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final data = await ApiController.searchUsers(q);
      if (id != _latestRequest) return; // a newer search replaced this one
      results.assignAll(data);
      loading.value = false;
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
