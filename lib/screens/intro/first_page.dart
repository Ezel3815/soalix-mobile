import 'package:flutter/material.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/screens/intro/onboarding_header.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const OnboardingHeader(),
              const SizedBox(height: 28),
              const Text(
                "تعلّم قطعة،\nوابنِ الصورة.",
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
                "حوّل المعلومات المتفرقة إلى\nمعرفة راسخة.",
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
                    "lib/assests/images/illustration_welcome.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
