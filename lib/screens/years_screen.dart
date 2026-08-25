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
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () => scaffoldKey.currentState?.openDrawer(),
                      child: const Icon(
                        Icons.dehaze,
                        size: 35,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          height: 30,
                          width: 100,
                          'lib/assests/images/logodeck.png',
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(.4),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Obx(
                  () => Expanded(
                    child: controller.loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : RefreshIndicator(
                            onRefresh: () => controller.getAllDeck(),
                            child: ListView.separated(
                              itemBuilder: (context, index) =>
                                  DeckWidget(model: controller.decks[index]),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemCount: controller.decks.length,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 30),
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
