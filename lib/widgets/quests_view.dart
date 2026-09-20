import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:upgrade/controllers/progress_controller.dart';
import 'package:upgrade/entity/quests_entity.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/widgets/app_image.dart';

const List<String> _months = [
  'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
  'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
];

const Color _trackLight = Color(0xFFE6EBD8);
const Color _cardBorder = Color(0xFFDDE4CC);

String _timeLabel(int hours) =>
    hours >= 48 ? '${(hours / 24).ceil()} أيام' : '$hours ساعة';

String _dailyTitle(DailyQuest q) {
  switch (q.id) {
    case 'daily_reviews':
      return 'راجع ${q.target} بطاقات';
    case 'daily_mastery':
      return 'أتقن ${q.target} بطاقات (سهل أو جيد)';
    case 'daily_chapter':
      return 'أنهِ فصلاً كاملاً';
    default:
      return q.id;
  }
}

Future<void> _claim(ProgressController c, String id) async {
  final xp = await c.claimChest(id);
  if (xp != null) {
    Get.snackbar(
      'فتحت الصندوق! 🎉',
      '+$xp نقطة خبرة',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColor.greenColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(14),
      borderRadius: 16,
    );
  }
}

/// Duolingo-style "Quests" page: monthly quest, friends quest, daily quests.
class QuestsBody extends StatelessWidget {
  final ProgressController controller;
  const QuestsBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final q = controller.quests.value;
      if (q == null) {
        if (controller.questsLoading.value) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Center(
              child: CircularProgressIndicator(color: AppColor.greenColor),
            ),
          );
        }
        return _QuestsError(onRetry: controller.loadQuests);
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MonthlyCard(q: q, controller: controller),
          const SizedBox(height: 26),
          _SectionHeader(title: 'تحدي الأصدقاء', hours: q.friendsHoursLeft),
          const SizedBox(height: 12),
          _FriendsCard(q: q, controller: controller),
          const SizedBox(height: 26),
          _SectionHeader(title: 'المهام اليومية', hours: q.dailyHoursLeft),
          const SizedBox(height: 12),
          _DailyCard(q: q, controller: controller),
        ],
      );
    });
  }
}

class _QuestsError extends StatelessWidget {
  final VoidCallback onRetry;
  const _QuestsError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_rounded,
              size: 44, color: AppColor.disabledColor),
          const SizedBox(height: 12),
          const Text(
            'تعذّر تحميل المهام',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary),
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: onRetry,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColor.greenColor,
              side: const BorderSide(color: AppColor.greenColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int hours;
  const _SectionHeader({required this.title, required this.hours});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColor.textPrimary,
            ),
          ),
        ),
        const Icon(Icons.schedule_rounded,
            size: 18, color: AppColor.warningColor),
        const SizedBox(width: 4),
        Text(
          _timeLabel(hours),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColor.warningColor,
          ),
        ),
      ],
    );
  }
}

// ───────────────────────── Monthly quest ─────────────────────────

class _MonthlyCard extends StatelessWidget {
  final QuestsData q;
  final ProgressController controller;
  const _MonthlyCard({required this.q, required this.controller});

  @override
  Widget build(BuildContext context) {
    final monthName = _months[(q.month - 1).clamp(0, 11).toInt()];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColor.greenColor, Color(0xFF2F7A57)],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        monthName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColor.greenColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'تحدي الشهر',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded,
                            size: 16, color: Colors.white.withOpacity(0.75)),
                        const SizedBox(width: 5),
                        Text(
                          'باقي ${q.daysLeft} ${q.daysLeft == 1 ? 'يوم' : 'أيام'}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(Icons.emoji_events_rounded,
                    size: 50, color: Color(0xFFFFD25A)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
            decoration: BoxDecoration(
              color: AppColor.darkGreenColor,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'اجمع ${q.monthTarget} نقطة',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      '${q.monthPoints} / ${q.monthTarget}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColor.freshGreenColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _MonthlyBar(q: q, controller: controller),
                const SizedBox(height: 10),
                Text(
                  'كل بطاقة تراجعها هذا الشهر = نقطة',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyBar extends StatelessWidget {
  final QuestsData q;
  final ProgressController controller;
  const _MonthlyBar({required this.q, required this.controller});

  @override
  Widget build(BuildContext context) {
    const node = 36.0;
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final frac = (q.monthPoints / q.monthTarget).clamp(0.0, 1.0).toDouble();
      return SizedBox(
        height: node,
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            Container(
              height: 20,
              decoration: BoxDecoration(
                color: AppColor.forestGreenColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            if (frac > 0)
              FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: frac,
                child: const SizedBox(
                  height: 20,
                  child: _BarFill(color: AppColor.freshGreenColor),
                ),
              ),
            for (final chest in q.monthChests)
              PositionedDirectional(
                start: (chest.at / q.monthTarget).clamp(0.0, 1.0).toDouble() *
                    (w - node),
                top: 0,
                child: _MilestoneNode(
                  chest: chest,
                  size: node,
                  controller: controller,
                ),
              ),
          ],
        ),
      );
    });
  }
}

class _MilestoneNode extends StatelessWidget {
  final QuestChest chest;
  final double size;
  final ProgressController controller;
  const _MilestoneNode(
      {required this.chest, required this.size, required this.controller});

  @override
  Widget build(BuildContext context) {
    Widget inner;
    Color bg;
    if (chest.claimed) {
      bg = AppColor.greenColor;
      inner = const Icon(Icons.check_rounded, size: 20, color: Colors.white);
    } else if (chest.reached) {
      bg = const Color(0xFFFFD25A);
      inner = _Chest(tier: 'gold', size: 22);
    } else {
      bg = AppColor.forestGreenColor;
      inner = Icon(Icons.lock_rounded,
          size: 16, color: Colors.white.withOpacity(0.5));
    }
    return GestureDetector(
      onTap: chest.claimable ? () => _claim(controller, chest.id) : null,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.darkGreenColor, width: 3),
          boxShadow: chest.claimable
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFD25A).withOpacity(0.7),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: inner,
      ),
    );
  }
}

// ───────────────────────── Friends quest ─────────────────────────

class _FriendsCard extends StatelessWidget {
  final QuestsData q;
  final ProgressController controller;
  const _FriendsCard({required this.q, required this.controller});

  @override
  Widget build(BuildContext context) {
    final hasPartner = q.partner != null;
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أجيبا معاً على ${q.friendsTarget} بطاقة هذا الأسبوع',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColor.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _TwoToneBar(q: q)),
                    const SizedBox(width: 10),
                    _ChestButton(
                      controller: controller,
                      id: q.friendsChest.id,
                      tier: 'purple',
                      claimable: q.friendsChest.claimable,
                      claimed: q.friendsChest.claimed,
                      size: 44,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${(q.myCount + q.partnerCount).clamp(0, q.friendsTarget).toInt()} / ${q.friendsTarget}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColor.disabledColor,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 2, thickness: 2, color: _cardBorder),
          if (hasPartner) _partnerSection(context) else _emptySection(),
        ],
      ),
    );
  }

  Widget _partnerSection(BuildContext context) {
    final me = q.me;
    final partner = q.partner!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _PersonColumn(
                    person: me,
                    label: 'أنت',
                    count: q.myCount,
                    color: AppColor.greenColor,
                  ),
                ),
                const VerticalDivider(
                    width: 2, thickness: 2, color: _cardBorder),
                Expanded(
                  child: _PersonColumn(
                    person: partner,
                    label: partner.name,
                    count: q.partnerCount,
                    color: AppColor.warningColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () => Share.share(
                  'يلا نكمل تحدي MOZAIK هذا الأسبوع! 👋 راجع بطاقاتك وساعدني نفتح الصندوق.'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColor.textPrimary,
                side: const BorderSide(color: _cardBorder, width: 2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text(
                '👋  تذكير الصديق',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptySection() {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const Text(
            'ابدأ تحدياً مع صديق',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColor.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'تابع صديقاً ويتابعك ليصبح شريكك في التحدي الأسبوعي',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, color: AppColor.textSecondary),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.searchUsersRoute),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.greenColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text(
                'ابحث عن صديق',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TwoToneBar extends StatelessWidget {
  final QuestsData q;
  const _TwoToneBar({required this.q});

  @override
  Widget build(BuildContext context) {
    final t = q.friendsTarget;
    final mine = (q.myCount / t).clamp(0.0, 1.0).toDouble();
    final theirs = (q.partnerCount / t).clamp(0.0, 1.0 - mine).toDouble();
    final rest = (1.0 - mine - theirs).clamp(0.0, 1.0).toDouble();
    final a = (mine * 1000).round();
    final b = (theirs * 1000).round();
    final r = (rest * 1000).round();
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 24,
        color: _trackLight,
        child: Row(
          children: [
            if (a > 0)
              Expanded(
                flex: a,
                child: const _BarFill(color: AppColor.greenColor, radius: 0),
              ),
            if (b > 0)
              Expanded(
                flex: b,
                child:
                    const _BarFill(color: AppColor.warningColor, radius: 0),
              ),
            if (r > 0) Expanded(flex: r, child: const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}

class _PersonColumn extends StatelessWidget {
  final QuestPerson? person;
  final String label;
  final int count;
  final Color color;
  const _PersonColumn({
    required this.person,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _QuestAvatar(person: person, size: 62),
        const SizedBox(height: 8),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColor.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$count بطاقة',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _QuestAvatar extends StatelessWidget {
  final QuestPerson? person;
  final double size;
  const _QuestAvatar({required this.person, required this.size});

  @override
  Widget build(BuildContext context) {
    final photo = person?.photo;
    final name = person?.name ?? '';
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2.5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.lightGreenColor,
      ),
      child: ClipOval(
        child: (photo != null && photo.isNotEmpty)
            ? AppImage(
                image: photo,
                width: size,
                height: size,
                fit: BoxFit.cover,
              )
            : Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: size * 0.4,
                    fontWeight: FontWeight.w800,
                    color: AppColor.darkGreenColor,
                  ),
                ),
              ),
      ),
    );
  }
}

// ───────────────────────── Daily quests ─────────────────────────

class _DailyCard extends StatelessWidget {
  final QuestsData q;
  final ProgressController controller;
  const _DailyCard({required this.q, required this.controller});

  @override
  Widget build(BuildContext context) {
    final items = q.daily;
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const Divider(height: 2, thickness: 2, color: _cardBorder),
            _DailyRow(quest: items[i], controller: controller),
          ],
        ],
      ),
    );
  }
}

class _DailyRow extends StatelessWidget {
  final DailyQuest quest;
  final ProgressController controller;
  const _DailyRow({required this.quest, required this.controller});

  @override
  Widget build(BuildContext context) {
    final frac = (quest.progress / quest.target).clamp(0.0, 1.0).toDouble();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _dailyTitle(quest),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColor.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 24,
                    color: _trackLight,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (frac > 0)
                          FractionallySizedBox(
                            alignment: AlignmentDirectional.centerStart,
                            widthFactor: frac,
                            child: const SizedBox(
                              height: 24,
                              child: _BarFill(
                                  color: AppColor.greenColor, radius: 0),
                            ),
                          ),
                        Text(
                          '${quest.progress} / ${quest.target}',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: frac >= 0.5
                                ? Colors.white
                                : AppColor.disabledColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          _ChestButton(
            controller: controller,
            id: quest.id,
            tier: quest.tier,
            claimable: quest.claimable,
            claimed: quest.claimed,
            size: 48,
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Shared pieces ─────────────────────────

BoxDecoration _cardDecoration() => BoxDecoration(
      color: AppColor.surfaceColor,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: _cardBorder, width: 2),
    );

/// Progress fill with a soft glossy highlight (the "thick bar" look).
class _BarFill extends StatelessWidget {
  final Color color;
  final double radius;
  const _BarFill({required this.color, this.radius = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.28),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _ChestButton extends StatelessWidget {
  final ProgressController controller;
  final String id;
  final String tier;
  final bool claimable;
  final bool claimed;
  final double size;
  const _ChestButton({
    required this.controller,
    required this.id,
    required this.tier,
    required this.claimable,
    required this.claimed,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final busy = controller.claimingId.value == id;
      return GestureDetector(
        onTap: claimable && !busy ? () => _claim(controller, id) : null,
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: claimable
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD25A).withOpacity(0.55),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      )
                    : null,
                child: Opacity(
                  opacity: (claimable || claimed) ? 1 : 0.45,
                  child: _Chest(tier: tier, size: size * 0.86),
                ),
              ),
              if (claimed)
                PositionedDirectional(
                  end: 0,
                  bottom: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColor.greenColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.check_rounded,
                        size: 11, color: Colors.white),
                  ),
                ),
              if (busy)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.4, color: AppColor.greenColor),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class _Chest extends StatelessWidget {
  final String tier;
  final double size;
  const _Chest({required this.tier, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 0.82),
      painter: _ChestPainter(tier),
    );
  }
}

class _ChestPainter extends CustomPainter {
  final String tier;
  _ChestPainter(this.tier);

  @override
  void paint(Canvas canvas, Size s) {
    late Color body, lid, accent;
    switch (tier) {
      case 'gold':
        body = const Color(0xFFE0A21B);
        lid = const Color(0xFFF6C744);
        accent = const Color(0xFF8B5E0B);
        break;
      case 'silver':
        body = const Color(0xFF8E9BA5);
        lid = const Color(0xFFC5CED6);
        accent = const Color(0xFF56626B);
        break;
      case 'purple':
        body = const Color(0xFF7C6FA8);
        lid = const Color(0xFFA89BD1);
        accent = const Color(0xFF4A3F73);
        break;
      default: // bronze
        body = const Color(0xFFB8703B);
        lid = const Color(0xFFD8925A);
        accent = const Color(0xFF7A4520);
    }
    final w = s.width, h = s.height;

    final bodyRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, h * 0.42, w, h * 0.58), const Radius.circular(6));
    canvas.drawRRect(bodyRect, Paint()..color = body);

    final lidRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, w, h * 0.5),
      topLeft: Radius.circular(w * 0.32),
      topRight: Radius.circular(w * 0.32),
      bottomLeft: const Radius.circular(3),
      bottomRight: const Radius.circular(3),
    );
    canvas.drawRRect(lidRect, Paint()..color = lid);

    // vertical straps
    final strap = Paint()..color = accent.withOpacity(0.55);
    canvas.drawRect(Rect.fromLTWH(w * 0.16, 0, w * 0.1, h), strap);
    canvas.drawRect(Rect.fromLTWH(w * 0.74, 0, w * 0.1, h), strap);

    // lock plate
    final plate = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.4, h * 0.36, w * 0.2, h * 0.24),
      const Radius.circular(3),
    );
    canvas.drawRRect(plate, Paint()..color = accent);
    canvas.drawCircle(Offset(w * 0.5, h * 0.46), w * 0.028,
        Paint()..color = Colors.white.withOpacity(0.85));
  }

  @override
  bool shouldRepaint(covariant _ChestPainter old) => old.tier != tier;
}
