import 'package:flutter/material.dart';
import 'package:upgrade/resources.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

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
              height: 125,
            ),
            Image.asset(
              "lib/assests/images/firstpage.png",
            ),
            const Text(
              'Basic,cloze,occlusion',
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.black),
            ),
            const Text(
              ' !قل وداعاً للنسيان وأهلاً بالتنظيم',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Text(
              'تعتمد سوليكس على تقنية ',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Text(
              'التكرار المتباعد المثبتة عالمياً في',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Text(
              ',تحسين جودة الذاكرة واستذكار',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Text(
              '  برنامجنا سوف يقوم بإنشاء برامج',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Text(
              'مراجعةً خصيصاً لك دون تضييع',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Text(
              '.ثانيةً من وقتك لصنعه',
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
