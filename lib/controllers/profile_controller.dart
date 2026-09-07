import 'dart:convert';
import 'package:get/get.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/entity/profile_entity.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/models/user_model.dart';

class ProfileController extends GetxController {
  final Rx<ProfileEntity?> profile = Rx<ProfileEntity?>(null);
  final RxBool loading = false.obs;
  int? myId;

  @override
  void onInit() {
    loadMyProfile();
    super.onInit();
  }

  int? getMyId() {
    final userJson = sharedPref.getString("user");
    if (userJson == null) return null;
    final user = UserModel.fromJson(jsonDecode(userJson));
    return user.id;
  }

  Future<void> loadMyProfile() async {
    myId = getMyId();
    if (myId == null) return;
    loading.value = true;
    profile.value = await ApiController.getProfile(myId!);
    loading.value = false;
  }

  Future<void> toggleFollow(int targetUserId) async {
    if (profile.value == null) return;
    if (profile.value!.isFollowing) {
      await ApiController.unfollowUser(targetUserId);
    } else {
      await ApiController.followUser(targetUserId);
    }
    profile.value = await ApiController.getProfile(targetUserId);
  }
}
