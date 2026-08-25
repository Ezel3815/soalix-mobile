import 'package:flutter/material.dart';
import 'package:upgrade/resources.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

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
              height: 155,
            ),
            Image.asset(
              "lib/assests/images/thirdpage.png",
            ),
            const Text(
              ' I am a doctor !',
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.black),
            ),
            const Text(
              ' بطاقات سهلة بسيطة',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Text(
              'وتحتوي كامل المنهاج بطريقة',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Text(
              'عصرية حديثة لتكون الطبيب ذو ',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Text(
              '.الذاكرة الحديدية ',
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
