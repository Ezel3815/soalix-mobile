import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/screens/library_screen.dart';
import 'package:upgrade/screens/profile_screen.dart';
import 'package:upgrade/screens/years_screen.dart';

class MainController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final RxInt _page = 0.obs;
  int get page => _page.value;
  set page(value) => _page.value = value;

  onChangePage(index) async {
    if (index == 3) {
      scaffoldKey.currentState?.openDrawer();
      return;
    }
    page = index;
  }

  final pages = const [
    YearsScreen(),
    LibraryScreen(),
    ProfileScreen(),
  ];
}
