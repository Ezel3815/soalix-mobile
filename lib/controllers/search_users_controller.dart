import 'package:get/get.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/entity/profile_entity.dart';

class SearchUsersController extends GetxController {
  final RxList<ProfileEntity> results = <ProfileEntity>[].obs;
  final RxBool loading = false.obs;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      results.clear();
      return;
    }
    loading.value = true;
    results.value = await ApiController.searchUsers(query.trim());
    loading.value = false;
  }
}
