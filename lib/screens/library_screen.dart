import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:upgrade/controllers/library_controller.dart';
import 'package:upgrade/entity/deck_entity.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/screens/app_drawer.dart';

/// A small set of accent colors used only to visually distinguish deck
/// cards in the library grid (not tied to any real "subject category"
/// data, since that doesn't exist in the backend yet). Cycled by index.
const List<Color> _deckAccentColors = [
  AppColor.greenColor,
  AppColor.infoColor,
  AppColor.warningColor,
  Color(0xFF7C6FA8), // muted plum, for visual variety only
  AppColor.freshGreenColor,
];

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LibraryController());
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColor.scaffoldBackgroundColor,
      drawer: const AppDrawer(),
      drawerEnableOpenDragGesture: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.greenColor,
        onPressed: () => Get.toNamed(AppRoutes.createDeckRoute),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 4),
            Padding(
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
                  const Text(
                    "Flashcards",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColor.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
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
                    Icon(
                      PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
                      size: 18,
                      color: AppColor.textSecondary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => controller.query.value = v,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                          hintText: "Search subjects",
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: AppColor.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 36,
              child: Obx(
                () => ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _FilterPill(
                      label: "All",
                      selected: controller.filter.value == LibraryFilter.all,
                      onTap: () => controller.filter.value = LibraryFilter.all,
                    ),
                    const SizedBox(width: 8),
                    _FilterPill(
                      label: "My Decks",
                      selected: controller.filter.value == LibraryFilter.mine,
                      onTap: () =>
                          controller.filter.value = LibraryFilter.mine,
                    ),
                    const SizedBox(width: 8),
                    _FilterPill(
                      label: "Public",
                      selected:
                          controller.filter.value == LibraryFilter.public,
                      onTap: () =>
                          controller.filter.value = LibraryFilter.public,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Obx(() {
                final subjects = controller.filteredSubjects;
                if (subjects.isEmpty) {
                  return const Center(
                    child: Text(
                      "No subjects found",
                      style: TextStyle(color: AppColor.textSecondary),
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.92,
                  ),
                  itemCount: subjects.length,
                  itemBuilder: (context, index) => _SubjectCard(
                    subject: subjects[index],
                    accentColor:
                        _deckAccentColors[index % _deckAccentColors.length],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColor.greenColor : AppColor.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: selected
              ? null
              : Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColor.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final DeckEntity subject;
  final Color accentColor;
  const _SubjectCard({required this.subject, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    // Subjects are folders (PACKAGE_DECK) — their cards live on their
    // chapter children, not on the subject node itself.
    final allCards = subject.children.expand((c) => c.cards).toList();
    final total = allCards.length;
    final answered =
        allCards.where((c) => c.answer.isNotEmpty && c.answer != "NONE").length;
    final progress = total == 0 ? 0.0 : answered / total;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Get.toNamed(
        AppRoutes.preparatoryYearRoute,
        arguments: {
          "id": subject.id,
          "decks": subject.children,
        },
        preventDuplicates: false,
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColor.surfaceColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.style_rounded,
                    size: 18,
                    color: accentColor,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColor.textSecondary,
                  size: 20,
                ),
              ],
            ),
            const Spacer(),
            Text(
              subject.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "$total cards",
              style: const TextStyle(
                fontSize: 11,
                color: AppColor.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: AppColor.scaffoldBackgroundColor,
                valueColor: AlwaysStoppedAnimation(accentColor),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${(progress * 100).round()}%",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
