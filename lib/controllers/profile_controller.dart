import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/controllers/years_controller.dart';
import 'package:upgrade/entity/profile_entity.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/models/user_model.dart';

class ProfileController extends GetxController {
  final int? targetUserId;
  ProfileController({this.targetUserId});

  final Rx<ProfileEntity?> profile = Rx<ProfileEntity?>(null);
  final RxBool loading = false.obs;
  final RxBool uploadingPhoto = false.obs;
  int? myId;

  bool get isOwnProfile => targetUserId == null || targetUserId == myId;

  @override
  void onInit() {
    myId = getMyId();
    load();
    super.onInit();
  }

  int? getMyId() {
    final userJson = sharedPref.getString("user");
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson)).id;
  }

  Future<void> load() async {
    final id = targetUserId ?? myId;
    if (id == null) return;
    final isFirstLoad = profile.value == null;
    if (isFirstLoad) loading.value = true;
    profile.value = await ApiController.getProfile(id);
    loading.value = false;
  }

  /// True while a follow / unfollow request is in flight (prevents double taps).
  final RxBool followBusy = false.obs;

  ProfileEntity _withFollowing(ProfileEntity p, bool following) => ProfileEntity(
        id: p.id,
        name: p.name,
        email: p.email,
        username: p.username,
        avatarHair: p.avatarHair,
        avatarHairColor: p.avatarHairColor,
        avatarSkinColor: p.avatarSkinColor,
        avatarClothingColor: p.avatarClothingColor,
        avatarGlasses: p.avatarGlasses,
        currentStreak: p.currentStreak,
        followersCount: (p.followersCount + (following ? 1 : -1)).clamp(0, 1 << 30).toInt(),
        followingCount: p.followingCount,
        isFollowing: following,
        isFriend: following ? p.isFriend : false,
        createdAt: p.createdAt,
        xp: p.xp,
        level: p.level,
        xpIntoLevel: p.xpIntoLevel,
        xpForNextLevel: p.xpForNextLevel,
      );

  /// Optimistic: the button flips instantly, the request runs behind it, and
  /// it flips back if the server refuses (no more "frozen, then follows").
  Future<void> toggleFollow() async {
    final current = profile.value;
    if (current == null || followBusy.value) return;
    followBusy.value = true;
    final id = current.id;
    final wasFollowing = current.isFollowing;
    profile.value = _withFollowing(current, !wasFollowing);

    final ok = wasFollowing
        ? await ApiController.unfollowUser(id)
        : await ApiController.followUser(id);

    if (!ok) profile.value = current; // revert
    followBusy.value = false;

    // Refresh the real numbers (friend status, counts) in the background.
    final fresh = await ApiController.getProfile(id);
    if (fresh != null) profile.value = fresh;
  }

  Future<void> pickAndUploadAvatar() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile == null) return;
    uploadingPhoto.value = true;
    final imageName = await ApiController.uploadImage(pickedFile.path);
    if (imageName != null) {
      await ApiController.updateProfile(avatarHair: imageName);
      await load();
      // Home shows the same picture; refresh it without waiting for a reload.
      if (Get.isRegistered<YearsController>()) {
        Get.find<YearsController>().profile.value = profile.value;
      }
    }
    uploadingPhoto.value = false;
  }

  Future<void> updateUsername(String username) async {
    final success = await ApiController.updateProfile(username: username);
    if (success) await load();
  }
}
