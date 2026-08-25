import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/preparatory_year_controller.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/screens/app_drawer.dart';
import 'package:upgrade/widgets/deck_widget.dart';

class PreparatoryYear extends StatelessWidget {
  const PreparatoryYear({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return GetBuilder<PreparatoryYearController>(
      tag: Get.arguments['id'].toString(),
      builder: (controller) {
        return Scaffold(
          key: controller.scaffoldKey,
          drawer: const AppDrawer(),
          body: Container(
            width: double.infinity,
            height: screenHeight,
            decoration: const BoxDecoration(
              color: AppColor.scaffoldBackgroundColor,
              image: DecorationImage(
                image: AssetImage('lib/assests/images/background_5.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          size: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        height: 30,
                        width: 100,
                        'lib/assests/images/logodeck.png',
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: controller.decks.isEmpty
                        ? const Center(
                            child: Text(
                              "No Data Found",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 20),
                            itemBuilder: (context, index) =>
                                DeckWidget(model: controller.decks[index]),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemCount: controller.decks.length,
                          ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
