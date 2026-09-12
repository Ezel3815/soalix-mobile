import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:upgrade/controllers/main_controller.dart';
import 'package:upgrade/controllers/years_controller.dart';
import 'package:upgrade/entity/deck_entity.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/screens/app_drawer.dart';
import 'package:upgrade/main.dart';

class YearsScreen extends StatefulWidget {
  const YearsScreen({super.key});
  @override
  State<YearsScreen> createState() => _YearsScreenState();
}

class _YearsScreenState extends State<YearsScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = Get.find<YearsController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.scaffoldBackgroundColor,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Obx(
            () => controller.loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.greenColor,
                    ),
                  )
                : RefreshIndicator(
                    color: AppColor.greenColor,
                    onRefresh: () => Future.wait([
                      controller.getAllDeck(),
                      controller.getMyProfile(),
                      controller.getDailyMissions(),
                    ]),
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 20),
                      children: [
                        const SizedBox(height: 4),
                        _Header(scaffoldKey: scaffoldKey),
                        const SizedBox(height: 20),
                        _GreetingBlock(),
                        const SizedBox(height: 18),
                        _TodaysMissions(),
                        const SizedBox(height: 18),
                        _ProgressCard(),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Learning Paths",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColor.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _LearningPathList(),
                      ],
                    ),
                  ),
          ),
        ),
        drawerEnableOpenDragGesture: false,
        drawer: const AppDrawer(),
      ),
    );
  }
}

/// Top bar: menu, logo, streak pill, avatar.
class _Header extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const _Header({required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<YearsController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
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
          Image.asset(
            height: 26,
            width: 90,
            fit: BoxFit.contain,
            alignment: Alignment.centerLeft,
            'lib/assests/images/logodeck.png',
          ),
          const Spacer(),
          Obx(() {
            final streak = controller.profile.value?.currentStreak ?? 0;
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColor.lightGreenColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    PhosphorIcons.flame(PhosphorIconsStyle.fill),
                    size: 15,
                    color: AppColor.warningColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "$streak",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColor.darkGreenColor,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(width: 10),
          InkWell(
            onTap: () => Get.find<MainController>().onChangePage(2),
            child: Obx(() {
              final name = controller.profile.value?.name ?? "";
              final initial = name.isNotEmpty ? name[0].toUpperCase() : "?";
              return CircleAvatar(
                radius: 18,
                backgroundColor: AppColor.greenColor,
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _GreetingBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<YearsController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        final name = controller.profile.value?.name ?? "";
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name.isNotEmpty ? "Welcome back, $name" : "Welcome back",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Let's continue your learning journey",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColor.textSecondary,
              ),
            ),
          ],
        );
      }),
    );
  }
}

/// Summary card showing how many learning paths are unlocked/complete.
class _ProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<YearsController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        final decks = controller.decks;
        final total = decks.length;
        final unlocked = decks.where((d) => !d.locked).length;
        final progress = total == 0 ? 0.0 : unlocked / total;
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColor.surfaceColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Current Path",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  Text(
                    "$unlocked/$total",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColor.greenColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: AppColor.scaffoldBackgroundColor,
                  valueColor: const AlwaysStoppedAnimation(AppColor.greenColor),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

/// Vertical timeline of decks styled as lesson nodes (current / completed / locked).
class _TodaysMissions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<YearsController>();
    return Obx(() {
      final missions = controller.missions;
      if (missions.isEmpty) return const SizedBox.shrink();

      final completedCount = missions.where((m) => m.completed).length;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's Missions",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  Text(
                    "$completedCount/${missions.length} completed",
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...missions.map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          m.completed
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          size: 20,
                          color: m.completed
                              ? AppColor.greenColor
                              : AppColor.textSecondary.withOpacity(0.4),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            m.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: m.completed
                                  ? AppColor.textSecondary
                                  : AppColor.textPrimary,
                              decoration: m.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        Text(
                          "${m.progress}/${m.target}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      );
    });
  }
}

class _LearningPathList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<YearsController>();
    return Obx(() {
      final decks = controller.decks;
      // The first unlocked deck that isn't fully reviewed is the "current" one.
      final currentIndex = decks.indexWhere((d) => !d.locked && !_isComplete(d));

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: List.generate(decks.length, (index) {
            final deck = decks[index];
            final isLast = index == decks.length - 1;
            final state = deck.locked
                ? _NodeState.locked
                : _isComplete(deck)
                    ? _NodeState.completed
                    : index == currentIndex
                        ? _NodeState.current
                        : _NodeState.completed;
            return _PathNode(
              deck: deck,
              index: index,
              state: state,
              showLine: !isLast,
            );
          }),
        ),
      );
    });
  }

  bool _isComplete(DeckEntity deck) {
    if (deck.cards.isEmpty) return false;
    return deck.cards.every((c) => c.answer.isNotEmpty);
  }
}

enum _NodeState { locked, current, completed }

class _PathNode extends StatelessWidget {
  final DeckEntity deck;
  final int index;
  final _NodeState state;
  final bool showLine;

  const _PathNode({
    required this.deck,
    required this.index,
    required this.state,
    required this.showLine,
  });

  @override
  Widget build(BuildContext context) {
    final reviewed = deck.cards.where((c) => c.answer.isNotEmpty).length;
    final total = deck.cards.length;

    return InkWell(
      onTap: () => _onTapDeck(deck),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  _NodeCircle(index: index, state: state),
                  if (showLine)
                    Expanded(
                      child: Container(
                        width: 3,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: state == _NodeState.completed
                            ? AppColor.greenColor.withOpacity(0.5)
                            : AppColor.greyColor.withOpacity(0.5),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColor.surfaceColor,
                    borderRadius: BorderRadius.circular(14),
                    border: state == _NodeState.current
                        ? Border.all(color: AppColor.greenColor, width: 1.4)
                        : null,
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              deck.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColor.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _statusLabel(total, reviewed),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _statusColor(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppColor.textSecondary,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(int total, int reviewed) {
    switch (state) {
      case _NodeState.locked:
        return "Locked";
      case _NodeState.completed:
        return "Completed";
      case _NodeState.current:
        return total == 0 ? "Not started" : "$reviewed/$total cards";
    }
  }

  Color _statusColor() {
    switch (state) {
      case _NodeState.locked:
        return AppColor.textSecondary;
      case _NodeState.completed:
        return AppColor.greenColor;
      case _NodeState.current:
        return AppColor.darkGreenColor;
    }
  }

  void _onTapDeck(DeckEntity model) {
    if (model.locked) {
      Get.snackbar(
        "Locked",
        "This deck is locked, contact support to unlock it",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (model.type == "PACKAGE_DECK") {
      Get.toNamed(
        AppRoutes.preparatoryYearRoute,
        arguments: {
          "id": model.id,
          "decks": model.children,
        },
        preventDuplicates: false,
      );
    } else {
      Get.toNamed(
        AppRoutes.cardRoute,
        arguments: model,
      );
    }
  }
}

class _NodeCircle extends StatelessWidget {
  final int index;
  final _NodeState state;
  const _NodeCircle({required this.index, required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case _NodeState.locked:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColor.greyColor.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_rounded,
            color: AppColor.textSecondary,
            size: 18,
          ),
        );
      case _NodeState.completed:
        return Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColor.greenColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 20,
          ),
        );
      case _NodeState.current:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColor.surfaceColor,
            shape: BoxShape.circle,
            border: Border.all(color: AppColor.greenColor, width: 2),
          ),
          child: Center(
            child: Text(
              "${index + 1}",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColor.greenColor,
              ),
            ),
          ),
        );
    }
  }
}
