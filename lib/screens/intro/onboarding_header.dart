import 'package:flutter/material.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/widgets/mozaik_mark_icon.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MozaikMarkIcon(color: AppColor.greenColor, size: 44),
        const SizedBox(height: 8),
        const Text(
          "MOZAIK",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
            color: AppColor.darkGreenColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "قطعة تلو الأخرى، تتكامل الصورة.",
          style: TextStyle(
            fontSize: 12,
            color: AppColor.textSecondary.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}
