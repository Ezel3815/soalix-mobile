import 'package:flutter/material.dart';
import 'package:upgrade/resources.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      body: SizedBox.expand(
        child: Image.asset(
          "lib/assests/images/thirdpage.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
