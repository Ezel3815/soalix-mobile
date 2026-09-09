import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/main_controller.dart';
import 'package:upgrade/resources.dart';
import 'app_drawer.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        key: controller.scaffoldKey,
        body: controller.pages[controller.page],
        drawerEnableOpenDragGesture: false,
        drawer: const AppDrawer(),
        bottomNavigationBar: CurvedNavigationBar(
          color: AppColor.surfaceColor,
          backgroundColor: AppColor.scaffoldBackgroundColor,
          buttonBackgroundColor: AppColor.greenColor,
          height: 56,
          items: [
            Icon(
              controller.page == 0 ? Icons.home_rounded : Icons.home_outlined,
              color: controller.page == 0
                  ? Colors.white
                  : AppColor.textSecondary,
              size: 28,
            ),
            Icon(
              controller.page == 1 ? Icons.style_rounded : Icons.style_outlined,
              color: controller.page == 1
                  ? Colors.white
                  : AppColor.textSecondary,
              size: 28,
            ),
            Icon(
              controller.page == 2
                  ? Icons.person_rounded
                  : Icons.person_outline_rounded,
              color: controller.page == 2
                  ? Colors.white
                  : AppColor.textSecondary,
              size: 28,
            ),
            const Icon(
              Icons.menu_rounded,
              color: AppColor.textSecondary,
              size: 28,
            ),
          ],
          index: controller.page,
          onTap: controller.onChangePage,
        ),
      ),
    );
  }
}
