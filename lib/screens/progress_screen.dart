import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/progress_controller.dart';
import 'package:upgrade/entity/leaderboard_entry.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/screens/app_drawer.dart';
import 'package:upgrade/widgets/app_image.dart';

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
                  const SizedBox(width: 8),
                  Expanded(
                    child: _TabPill(
                      label: "Leaderboard",
                      selected: controller.tab.value == ProgressTab.leaderboard,
                      onTap: () =>
                          controller.tab.value = ProgressTab.leaderboard,
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
              if (controller.tab.value == ProgressTab.leaderboard) {
                return _LeaderboardBody(controller: controller);
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

class _LeaderboardBody extends StatelessWidget {
  final ProgressController controller;
  const _LeaderboardBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.leaderboardLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 60),
          child: Center(
            child: CircularProgressIndicator(color: AppColor.greenColor),
          ),
        );
      }
      final entries = controller.leaderboard;
      if (entries.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Text(
              "Follow some friends to see how you compare",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textSecondary),
            ),
          ),
        );
      }
      return Column(
        children: List.generate(entries.length, (index) {
          final entry = entries[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: entry.isMe
                  ? AppColor.lightGreenColor.withOpacity(0.5)
                  : AppColor.surfaceColor,
              borderRadius: BorderRadius.circular(14),
              border: entry.isMe
                  ? Border.all(color: AppColor.greenColor, width: 1.2)
                  : null,
              boxShadow: entry.isMe
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ClipOval(
                  child: (entry.avatarPhotoName != null &&
                          entry.avatarPhotoName!.isNotEmpty)
                      ? AppImage(
                          image: entry.avatarPhotoName!,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 36,
                          height: 36,
                          color: AppColor.lightGreenColor,
                          child: Center(
                            child: Text(
                              entry.name.isNotEmpty
                                  ? entry.name[0].toUpperCase()
                                  : "?",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColor.darkGreenColor,
                              ),
                            ),
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.isMe ? "${entry.name} (You)" : entry.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColor.textPrimary,
                        ),
                      ),
                      Text(
                        "Level ${entry.level}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColor.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${entry.xp} XP",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColor.greenColor,
                  ),
                ),
              ],
            ),
          );
        }),
      );
    });
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
                    icon: Icons.local_fire_department_rounded,
                    color: AppColor.warningColor,
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
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AppColor.lightGreenColor,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Icon(
                            Icons.style_rounded,
                            size: 16,
                            color: AppColor.darkGreenColor,
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
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  const _SummaryStat({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
