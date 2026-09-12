import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/progress_controller.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/screens/app_drawer.dart';
import 'package:upgrade/utils/subject_icon.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProgressController());
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColor.scaffoldBackgroundColor,
      drawer: const AppDrawer(),
      drawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => scaffoldKey.currentState?.openDrawer(),
                  child: const Icon(
                    Icons.dehaze,
                    size: 26,
                    color: AppColor.textPrimary,
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  "Progress",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColor.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: _TabPill(
                      label: "Achievements",
                      selected:
                          controller.tab.value == ProgressTab.achievements,
                      onTap: () =>
                          controller.tab.value = ProgressTab.achievements,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _TabPill(
                      label: "Statistics",
                      selected: controller.tab.value == ProgressTab.statistics,
                      onTap: () =>
                          controller.tab.value = ProgressTab.statistics,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.tab.value == ProgressTab.achievements) {
                return _AchievementsComingSoon();
              }
              return _StatisticsBody(controller: controller);
            }),
          ],
        ),
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColor.greenColor : AppColor.surfaceColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColor.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _AchievementsComingSoon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 46,
            color: AppColor.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          const Text(
            "Achievements coming soon",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticsBody extends StatelessWidget {
  final ProgressController controller;
  const _StatisticsBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final subjects = controller.subjectBreakdown;
      return Column(
        children: [
          // Total learning summary
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColor.surfaceColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryStat(
                    imageAsset: "lib/assests/images/stats/streak.png",
                    value: "${controller.streak}",
                    label: "Day streak",
                  ),
                ),
                Container(
                    width: 1,
                    height: 40,
                    color: Colors.black.withOpacity(0.06)),
                Expanded(
                  child: _SummaryStat(
                    icon: Icons.menu_book_rounded,
                    color: AppColor.greenColor,
                    value: "${controller.totalCardsReviewed}",
                    label: "Cards reviewed",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Mastery rate
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColor.surfaceColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mastery Rate",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColor.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 96,
                      height: 96,
                      child: CircularProgressIndicator(
                        value: controller.masteryPercent / 100,
                        strokeWidth: 8,
                        backgroundColor: AppColor.lightGreenColor,
                        valueColor: const AlwaysStoppedAnimation(
                            AppColor.greenColor),
                      ),
                    ),
                    Text(
                      "${controller.masteryPercent}%",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColor.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Performance by Subject",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (subjects.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "No subject data yet",
                style: TextStyle(color: AppColor.textSecondary),
              ),
            )
          else
            ...subjects.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColor.surfaceColor,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColor.lightGreenColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            subjectIconAsset(s.title),
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: LinearProgressIndicator(
                                  value: s.mastery,
                                  minHeight: 5,
                                  backgroundColor:
                                      AppColor.scaffoldBackgroundColor,
                                  valueColor: const AlwaysStoppedAnimation(
                                      AppColor.greenColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "${(s.mastery * 100).round()}%",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColor.greenColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
        ],
      );
    });
  }
}

class _SummaryStat extends StatelessWidget {
  final IconData? icon;
  final Color? color;
  final String? imageAsset;
  final String value;
  final String label;
  const _SummaryStat({
    this.icon,
    this.color,
    this.imageAsset,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imageAsset != null)
          Image.asset(imageAsset!, width: 26, height: 26)
        else
          Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
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
