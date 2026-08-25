import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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

    return Container(
      width: width * .7,
      color:  AppColor.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "lib/assests/images/drawer_logo.png",
                width: 150,
                height: 100,
                fit: BoxFit.contain,
              ),
              ListTile(
                leading: SvgPicture.asset(
                  "lib/assests/svgs/home.svg",
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  width: 30,
                ),
                title: const Text(
                  "Explore",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
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
                leading: SvgPicture.asset(
                  "lib/assests/svgs/document.svg",
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  width: 30,
                ),
                title: const Text(
                  "Document",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
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
                leading: SvgPicture.asset(
                  "lib/assests/svgs/cloud.svg",
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  width: 30,
                ),
                title: const Text(
                  "Create",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
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
                leading: SvgPicture.asset(
                  "lib/assests/svgs/camera.svg",
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  width: 30,
                ),
                title: const Text(
                  "Enter Code",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Get.back();
                  Get.dialog(const InterCodeDialog());
                },
              ),
              // ListTile(
              //   leading: SvgPicture.asset(
              //     "lib/assests/svgs/folder.svg",
              //     colorFilter:
              //         const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              //     width: 30,
              //   ),
              //   title: const Text(
              //     "Buy Code",
              //     style: TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.black,
              //     ),
              //   ),
              // ),
              const Divider(),
              ListTile(
                leading: SvgPicture.asset(
                  "lib/assests/svgs/like.svg",
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  width: 30,
                ),
                title: const Text(
                  "Share This App",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Share.share("Checkout this app in https://googleplay.com");
                },
              ),
              ListTile(
                onTap: () async{
                  if (!await launchUrl(Uri.parse("https://t.me/Ghalia510"))) {

                  log('Could not launch https://t.me/Ghalia510');
                  }
                },
                leading: SvgPicture.asset(
                  "lib/assests/svgs/help.svg",
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  width: 30,
                ),
                title: const Text(
                  "Help & Feedback",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              // ListTile(
              //   leading: Transform.rotate(
              //     angle: 6,
              //     child: SvgPicture.asset(
              //       "lib/assests/svgs/announcement.svg",
              //       colorFilter:
              //           const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              //       width: 30,
              //     ),
              //   ),
              //   title: const Text(
              //     "Announcement",
              //     style: TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.black,
              //     ),
              //   ),
              // ),
              // ListTile(
              //   leading: SvgPicture.asset(
              //     "lib/assests/svgs/gift.svg",
              //     colorFilter:
              //         const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              //     width: 30,
              //   ),
              //   title: const Text(
              //     "Claim Your Reward",
              //     style: TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.black,
              //     ),
              //   ),
              // ),
              ListTile(
                onTap: () {
                  ApiController.logout();
                },
                leading: SvgPicture.asset(
                  "lib/assests/svgs/logout.svg",
                  colorFilter:
                      const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                  width: 30,
                ),
                title: const Text(
                  "Log Out",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
