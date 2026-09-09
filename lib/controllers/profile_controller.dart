import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/api_controller.dart';
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

  Future<void> toggleFollow() async {
    if (profile.value == null) return;
    final id = profile.value!.id;
    if (profile.value!.isFollowing) {
      await ApiController.unfollowUser(id);
    } else {
      await ApiController.followUser(id);
    }
    profile.value = await ApiController.getProfile(id);
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
    }
    uploadingPhoto.value = false;
  }

  Future<void> updateUsername(String username) async {
    final success = await ApiController.updateProfile(username: username);
    if (success) await load();
  }
}
