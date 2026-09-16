import 'package:flutter/material.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/widgets/mozaik_mark_icon.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  static const _timeline = [
    ("اليوم", 1.0),
    ("بعد يوم", 0.75),
    ("بعد 4 أيام", 0.5),
    ("بعد أسبوعين", 0.3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Expanded(
                child: Image.asset(
                  "lib/assests/images/illustration_flashcard.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final (label, opacity) in _timeline) ...[
                    Column(
                      children: [
                        MozaikMarkIcon(
                          color: AppColor.greenColor.withOpacity(opacity),
                          size: 34,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textSecondary.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                    if (label != _timeline.last.$1)
                      Icon(Icons.arrow_back_ios_new_rounded,
                          size: 12, color: AppColor.textSecondary.withOpacity(0.4)),
                  ],
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                "بطاقاتك تتذكّرك معك.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColor.darkGreenColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "يُعيد MOZAIK عرض القطع المناسبة\nفي الوقت المناسب، عندما تكون أكثر\nاحتمالاً للنسيان.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColor.textSecondary.withOpacity(0.9),
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
