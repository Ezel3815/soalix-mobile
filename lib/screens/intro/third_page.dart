import 'package:flutter/material.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/screens/intro/onboarding_header.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Mountain graphic pinned to the bottom edge — safe to crop at
          // the sides on any screen width, no text inside it.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              "lib/assests/images/illustration_mountain.png",
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  const OnboardingHeader(),
                  const SizedBox(height: 28),
                  const Text(
                    "في يوم ما،\nستكتمل الصورة.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      color: AppColor.darkGreenColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "كل بطاقة هي قطعة.\nوكل مراجعة تربط قطعة بأخرى.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColor.textSecondary.withOpacity(0.9),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        "lib/assests/images/illustration_orbit.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 140),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
