import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/screens/intro/second_page.dart';
import 'package:upgrade/screens/intro/third_page.dart';

import 'first_page.dart';

class OnBording extends StatefulWidget {
  const OnBording({super.key});

  @override
  OutBoordinagState createState() => OutBoordinagState();
}

class OutBoordinagState extends State<OnBording> {
  final controller = PageController();
  bool islastpage = false;

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            islastpage = index == 2;
          });
        },
        controller: controller,
        children: const [
          FirstPage(),
          SecondPage(),
          ThirdPage(),
        ],
      ),
      bottomSheet: islastpage
          ? Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColor.greenColor,
                  ),
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.loginRoute);
                    sharedPref.setBool("onBoarding", true);
                    // Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(builder: (context) => const Register()));
                  },
                  child: const Text(
                    'Get Started ',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
          ),
                  )),
            )
          : Container(
              color: const Color(0xE8F2F4E7),
              padding: const EdgeInsets.symmetric(horizontal: 40),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Get.offAllNamed(AppRoutes.loginRoute);
                        sharedPref.setBool("onBoarding", true);
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //     builder: (context) => const Register()));
                      },
                      child: const Text('Skip',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
             ))),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: const WormEffect(
                        spacing: 16,
                        dotColor: Colors.black87,
                        activeDotColor: AppColor.greenColor,
                      ),
                      onDotClicked: (index) {
                        controller.animateToPage(index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        controller.nextPage(
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOut);
                      },
                      child: const Text('Next',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                ))),
                ],
              ),
            ),
    );
  }
}
