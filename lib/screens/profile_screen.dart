import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:upgrade/api.dart';
import 'package:upgrade/controllers/profile_controller.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/screens/app_drawer.dart';
import 'package:upgrade/widgets/app_image.dart';

class ProfileScreen extends StatefulWidget {
  final int? userId;
  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late final controller = Get.put(
    ProfileController(targetUserId: widget.userId),
    tag: widget.userId?.toString() ?? "me",
  );

  String _formatJoined(DateTime? date) {
    if (date == null) return "";
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return "Joined ${months[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColor.scaffoldBackgroundColor,
      drawer: const AppDrawer(),
      drawerEnableOpenDragGesture: false,
      body: Obx(
        () {
          if (controller.loading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.greenColor),
            );
          }
          final profile = controller.profile.value;
          if (profile == null) {
            return const Center(
              child: Text(
                "Couldn't load profile",
                style: TextStyle(color: AppColor.textSecondary),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 260,
                      decoration: const BoxDecoration(
                        color: AppColor.lightGreenColor,
                      ),
                      child: SafeArea(
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: InkWell(
                                  onTap: () =>
                                      Get.toNamed(AppRoutes.searchUsersRoute),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      PhosphorIcons.magnifyingGlass(
                                          PhosphorIconsStyle.bold),
                                      size: 22,
                                      color: AppColor.darkGreenColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: InkWell(
                                  onTap: () =>
                                      scaffoldKey.currentState?.openDrawer(),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      PhosphorIcons.gearSix(
                                          PhosphorIconsStyle.bold),
                                      size: 22,
                                      color: AppColor.darkGreenColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 152,
                                height: 152,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: AppColor.greenColor,
                                    width: 3,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: ClipOval(
                                    child: (profile.avatarPhotoName != null &&
                                            profile.avatarPhotoName!
                                                .isNotEmpty)
                                        ? AppImage(
                                            image: profile.avatarPhotoName!,
                                            width: 144,
                                            height: 144,
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            PhosphorIcons.userCircle(
                                                PhosphorIconsStyle.light),
                                            size: 96,
                                            color: AppColor.greenColor,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -18,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: InkWell(
                          onTap: controller.uploadingPhoto.value
                              ? null
                              : controller.pickAndUploadAvatar,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColor.darkGreenColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                controller.uploadingPhoto.value
                                    ? const SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Icon(
                                        PhosphorIcons.camera(
                                            PhosphorIconsStyle.bold),
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                const SizedBox(width: 6),
                                const Text(
                                  "Change Photo",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColor.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.username != null
                            ? "@${profile.username} · ${_formatJoined(profile.createdAt)}"
                            : "Set a username · ${_formatJoined(profile.createdAt)}",
                        style: TextStyle(
                          fontSize: 13,
                          color: profile.username != null
                              ? AppColor.textSecondary
                              : AppColor.greenColor,
                          fontWeight: profile.username != null
                              ? FontWeight.w400
                              : FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColor.surfaceColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatItem(
                              imageAsset: "lib/assests/images/stats/streak.png",
                              value: "${profile.currentStreak}",
                              label: "Streak",
                            ),
                            Container(
                                width: 1,
                                height: 32,
                                color: Colors.black.withOpacity(0.06)),
                            _StatItem(
                              value: "${profile.followingCount}",
                              label: "Following",
                            ),
                            Container(
                                width: 1,
                                height: 32,
                                color: Colors.black.withOpacity(0.06)),
                            _StatItem(
                              value: "${profile.followersCount}",
                              label: "Followers",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: controller.isOwnProfile
                                  ? OutlinedButton(
                                      onPressed: () {
                                        // Edit profile — future step
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: AppColor.greenColor),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: const Text(
                                        "EDIT PROFILE",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.greenColor,
                                        ),
                                      ),
                                    )
                                  : ElevatedButton(
                                      onPressed: controller.toggleFollow,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: profile.isFollowing
                                            ? Colors.white
                                            : AppColor.greenColor,
                                        elevation: 0,
                                        side: const BorderSide(
                                            color: AppColor.greenColor),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (profile.isFriend) ...[
                                            Icon(
                                              PhosphorIcons.usersThree(
                                                  PhosphorIconsStyle.fill),
                                              size: 15,
                                              color: profile.isFollowing
                                                  ? AppColor.greenColor
                                                  : Colors.white,
                                            ),
                                            const SizedBox(width: 6),
                                          ],
                                          Text(
                                            profile.isFriend
                                                ? "FRIENDS"
                                                : profile.isFollowing
                                                    ? "FOLLOWING"
                                                    : "FOLLOW",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: profile.isFollowing
                                                  ? AppColor.greenColor
                                                  : Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColor.greenColor.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              PhosphorIcons.shareNetwork(
                                  PhosphorIconsStyle.bold),
                              size: 18,
                              color: AppColor.greenColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final String? imageAsset;
  const _StatItem({
    required this.value,
    required this.label,
    this.icon,
    this.iconColor,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageAsset != null) ...[
              Image.asset(imageAsset!, width: 16, height: 16),
              const SizedBox(width: 4),
            ] else if (icon != null) ...[
              Icon(icon, size: 16, color: iconColor ?? AppColor.textPrimary),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColor.textSecondary,
          ),
        ),
      ],
    );
  }
}
