import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/years_controller.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/screens/app_drawer.dart';
import 'package:upgrade/widgets/deck_widget.dart';

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
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: screenHeight,
          decoration: const BoxDecoration(
            color: AppColor.scaffoldBackgroundColor,
            image: DecorationImage(
              image: AssetImage('lib/assests/images/background_5.jpg'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => scaffoldKey.currentState?.openDrawer(),
                        child: const Icon(
                          Icons.dehaze,
                          size: 28,
                          color: AppColor.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            height: 28,
                            width: 100,
                            fit: BoxFit.contain,
                            alignment: Alignment.centerLeft,
                            'lib/assests/images/logodeck.png',
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Home",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColor.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Obx(
                  () => Expanded(
                    child: controller.loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.greenColor,
                            ),
                          )
                        : RefreshIndicator(
                            color: AppColor.greenColor,
                            onRefresh: () => controller.getAllDeck(),
                            child: ListView.separated(
                              padding: const EdgeInsets.only(bottom: 12),
                              itemBuilder: (context, index) =>
                                  DeckWidget(model: controller.decks[index]),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12),
                              itemCount: controller.decks.length,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          drawerEnableOpenDragGesture: false,
          drawer: const AppDrawer(),
        ),
      ],
    );
  }
}
