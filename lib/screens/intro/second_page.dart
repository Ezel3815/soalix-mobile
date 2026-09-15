import 'package:flutter/material.dart';
import 'package:upgrade/resources.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      body: SizedBox.expand(
        child: Image.asset(
          "lib/assests/images/secondpage.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
