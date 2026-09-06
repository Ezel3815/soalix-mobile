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
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: color ?? AppColor.textPrimary,
        );

    Widget iconBadge(IconData icon, {Color badgeColor = Colors.black}) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: badgeColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      );
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
              const SizedBox(height: 8),
              Image.asset(
                "lib/assests/images/drawer_logo.png",
                width: 150,
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: iconBadge(
                  PhosphorIcons.house(PhosphorIconsStyle.bold),
                ),
                title: Text("Explore", style: itemStyle()),
                onTap: () {
                  Get.back();
                  Get.until(
                    (route) {
                      return Get.currentRoute == AppRoutes.mainRoute;
                    },
                  );
                  mainController.onChangePage(0);
                },
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: iconBadge(
                  PhosphorIcons.fileText(PhosphorIconsStyle.bold),
                ),
                title: Text("Document", style: itemStyle()),
                onTap: () {
                  Get.back();
                  Get.until(
                    (route) {
                      return Get.currentRoute == AppRoutes.mainRoute;
                    },
                  );
                  mainController.onChangePage(2);
                },
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: iconBadge(
                  PhosphorIcons.cloudArrowUp(PhosphorIconsStyle.bold),
                ),
                title: Text("Create", style: itemStyle()),
                onTap: () {
                  Get.back();
                  Get.until(
                    (route) {
                      return Get.currentRoute == AppRoutes.mainRoute;
                    },
                  );
                  mainController.onChangePage(1);
                },
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: iconBadge(
                  PhosphorIcons.camera(PhosphorIconsStyle.bold),
                ),
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
                leading: iconBadge(
                  PhosphorIcons.thumbsUp(PhosphorIconsStyle.bold),
                ),
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
                leading: iconBadge(
                  PhosphorIcons.question(PhosphorIconsStyle.bold),
                ),
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
                  badgeColor: Colors.red,
                ),
                title: Text("Log Out", style: itemStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
