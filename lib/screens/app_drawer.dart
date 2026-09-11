
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

    return Container(
      width: width * .78,
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
                child: Image.asset(
                  "lib/assests/images/drawer_logo.png",
                  width: 150,
                  height: 102,
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: iconBadge(PhosphorIcons.house(PhosphorIconsStyle.bold)),
                title: Text("Home", style: itemStyle()),
                onTap: () => goToTab(0),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: iconBadge(Icons.style_rounded),
                title: Text("Flashcards", style: itemStyle()),
                onTap: () => goToTab(1),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: iconBadge(Icons.bar_chart_rounded),
                title: Text("Progress", style: itemStyle()),
                onTap: () => goToTab(2),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: iconBadge(
                    PhosphorIcons.userCircle(PhosphorIconsStyle.bold)),
                title: Text("Profile", style: itemStyle()),
                onTap: () => goToTab(3),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: iconBadge(
                    PhosphorIcons.cloudArrowUp(PhosphorIconsStyle.bold)),
                title: Text("Create Deck", style: itemStyle()),
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
                    iconBadge(PhosphorIcons.camera(PhosphorIconsStyle.bold)),
                title: Text("Enter Code", style: itemStyle()),
                onTap: () {
                  Get.back();
                  Get.dialog(const InterCodeDialog());
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
                title: Text("Share This App", style: itemStyle()),
                onTap: () {
                  Share.share("Checkout this app in https://googleplay.com");
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
                title: Text("Help & Feedback", style: itemStyle()),
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
                title: Text("Log Out", style: itemStyle(color: AppColor.errorColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
