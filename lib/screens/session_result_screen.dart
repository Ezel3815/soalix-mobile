import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/entity/card_entity.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/resources.dart';

/// Shown after finishing every card in a study session. Reads its data
/// straight from the arguments CardViewController passes when the last
/// card is answered — no new backend endpoint, purely a summary of
/// what already happened client-side during the session.
class SessionResultScreen extends StatelessWidget {
  const SessionResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map;
    final int correct = args['correct'] ?? 0;
    final int wrong = args['wrong'] ?? 0;
    final int minutes = args['minutes'] ?? 0;
    final List<CardEntity> mistakes =
        List<CardEntity>.from(args['mistakes'] ?? []);
    final bool isView = args['isView'] ?? false;
    final total = correct + wrong;
    final accuracy = total == 0 ? 0 : ((correct / total) * 100).round();

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColor.lightGreenColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColor.darkGreenColor,
                  size: 46,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Well done!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "You completed this session",
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: accuracy / 100,
                      strokeWidth: 9,
                      backgroundColor: AppColor.lightGreenColor,
                      valueColor: const AlwaysStoppedAnimation(
                          AppColor.greenColor),
                    ),
                  ),
                  Text(
                    "$accuracy%",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColor.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "Accuracy",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatChip(
                    icon: Icons.star_rounded,
                    color: AppColor.warningColor,
                    value: "$correct",
                    label: "Correct",
                  ),
                  _StatChip(
                    icon: Icons.close_rounded,
                    color: AppColor.errorColor,
                    value: "$wrong",
                    label: "Missed",
                  ),
                  _StatChip(
                    icon: Icons.schedule_rounded,
                    color: AppColor.infoColor,
                    value: "$minutes",
                    label: "Minutes",
                  ),
                ],
              ),
              const Spacer(),
              if (mistakes.isNotEmpty) ...[
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.offNamed(
                        AppRoutes.cardViewRoute,
                        arguments: {
                          'cards': mistakes,
                          'isView': isView,
                          'initalIndex': 0,
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColor.greenColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Review ${mistakes.length} missed card${mistakes.length == 1 ? '' : 's'}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColor.greenColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Get.until(
                    (route) => Get.currentRoute == AppRoutes.cardRoute,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.greenColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  const _StatChip({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColor.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColor.textSecondary,
          ),
        ),
      ],
    );
  }
}
