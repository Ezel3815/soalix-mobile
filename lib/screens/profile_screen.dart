import 'package:upgrade/strings.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/controllers/main_controller.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/widgets/inter_code_dialog.dart';
import 'package:upgrade/widgets/mozaik_mark_icon.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final mainController = Get.find<MainController>();

    TextStyle itemStyle({Color? color}) => TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: color ?? AppColor.textPrimary,
        );

    Widget iconBadge(IconData icon, {Color? badgeColor}) {
      return Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: (badgeColor ?? AppColor.greenColor).withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: badgeColor ?? AppColor.darkGreenColor,
          size: 19,
        ),
      );
    }

    void goToTab(int index) {
      Get.back();
      Get.until((route) => Get.currentRoute == AppRoutes.mainRoute);
      mainController.onChangePage(index);
    }

    // On tablets, `width * .78` would make the drawer absurdly wide (and
    // stretch every ListTile with it) — cap it at a sensible phone-like
    // width instead.
    final drawerWidth = width >= 600 ? 320.0 : width * .78;

    return Container(
      width: drawerWidth,
      color: AppColor.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Row(
                  children: [
                    const MozaikMarkIcon(color: AppColor.greenColor, size: 36),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "MOZAIK",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: AppColor.darkGreenColor,
                          ),
                        ),
                        Text(
                          AppStrings.flashcardsTagline,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColor.textSecondary.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: iconBadge(PhosphorIcons.house(PhosphorIconsStyle.bold)),
                title: Text(AppStrings.drawerHome, style: itemStyle()),
                onTap: () => goToTab(0),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: iconBadge(Icons.style_rounded),
                title: Text(AppStrings.drawerFlashcards, style: itemStyle()),
                onTap: () => goToTab(1),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: iconBadge(Icons.bar_chart_rounded),
                title: Text(AppStrings.drawerProgress, style: itemStyle()),
                onTap: () => goToTab(2),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: iconBadge(
                    PhosphorIcons.userCircle(PhosphorIconsStyle.bold)),
                title: Text(AppStrings.drawerProfile, style: itemStyle()),
                onTap: () => goToTab(3),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: iconBadge(
                    PhosphorIcons.cloudArrowUp(PhosphorIconsStyle.bold)),
                title: Text(AppStrings.createDeck, style: itemStyle()),
                onTap: () {
                  Get.back();
                  Get.until((route) => Get.currentRoute == AppRoutes.mainRoute);
                  Get.toNamed(AppRoutes.createDeckRoute);
                },
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading:
                    iconBadge(PhosphorIcons.keyboard(PhosphorIconsStyle.bold)),
                title: Text(AppStrings.enterCode, style: itemStyle()),
                onTap: () {
                  Get.back();
                  Get.dialog(const InterCodeDialog());
                },
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading:
                    iconBadge(PhosphorIcons.bell(PhosphorIconsStyle.bold)),
                title: Text("الإشعارات", style: itemStyle()),
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.notificationSettingsRoute);
                },
              ),
              Divider(
                color: Colors.black.withOpacity(0.08),
                thickness: 1,
                height: 24,
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading:
                    iconBadge(PhosphorIcons.thumbsUp(PhosphorIconsStyle.bold)),
                title: Text(AppStrings.shareThisApp, style: itemStyle()),
                onTap: () {
                  Share.share(AppStrings.shareAppMessage);
                },
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () async {
                  if (!await launchUrl(Uri.parse("https://t.me/Ghalia510"))) {
                    log('Could not launch https://t.me/Ghalia510');
                  }
                },
                leading:
                    iconBadge(PhosphorIcons.question(PhosphorIconsStyle.bold)),
                title: Text(AppStrings.helpAndFeedback, style: itemStyle()),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () {
                  ApiController.logout();
                },
                leading: iconBadge(
                  PhosphorIcons.signOut(PhosphorIconsStyle.bold),
                  badgeColor: AppColor.errorColor,
                ),
                title: Text(AppStrings.logOut, style: itemStyle(color: AppColor.errorColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
