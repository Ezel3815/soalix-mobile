import 'package:flutter/material.dart';
import 'package:upgrade/resources.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assests/images/background2.png'),
            fit: BoxFit.fill, // يمكنك تعديل هذا الخيار حسب الحاجة
          ),
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisSize: MainAxisSize.min,

          children: [
            const SizedBox(
              height: 25,
            ),
            Image.asset(
              "lib/assests/images/secondpage.png",
            ),
            const Text(
              'Creat and share.',
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.black),
            ),
            const Text(
              ' تريد إضافة ملاحظاتك الخاصة ؟',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Text(
              'أنشئ البطاقات الخاصة بك',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Text(
              '.وشاركها مع أصدقائك',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
