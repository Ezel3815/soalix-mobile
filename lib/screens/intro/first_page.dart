import 'package:flutter/material.dart';
import 'package:upgrade/resources.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      body: SizedBox.expand(
        child: Image.asset(
          "lib/assests/images/firstpage.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
