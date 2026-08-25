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
          color: Colors.black,
          backgroundColor: AppColor.greenColor,
          buttonBackgroundColor: AppColor.greenColor,
          height: 50,
          items: const [
            Icon(
              Icons.home,
              color: Colors.white,
              size: 35,
            ),
            Icon(Icons.add, color: Colors.white, size: 35),
            Icon(Icons.my_library_books, color: Colors.white, size: 35),
            Icon(Icons.dehaze_sharp, color: Colors.white, size: 35),
          ],
          index: controller.page,
          onTap: controller.onChangePage,
        ),
      ),
    );
  }
}
