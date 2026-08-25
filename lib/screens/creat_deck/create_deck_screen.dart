import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/create_deck_controller.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/screens/app_drawer.dart';

class CreateDeckScreen extends GetView<CreateDeckController> {
  const CreateDeckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: AppColor.scaffoldBackgroundColor,
            image: DecorationImage(
              image: AssetImage('lib/assests/images/background_5.jpg'),
              fit: BoxFit.fill, // يمكنك تعديل هذا الخيار حسب الحاجة
            ),
          ),
        ),
        Scaffold(
          drawer: const AppDrawer(),
          backgroundColor: Colors.transparent,
          key: controller.scaffoldKey,
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () =>
                          controller.scaffoldKey.currentState?.openDrawer(),
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
                          "Create Deck",
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
                const SizedBox(
                  height: 250,
                ),
                InkWell(
                  onTap: () {
                    _showMyDialog(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      color: AppColor.greyColor,
                    ),
                    width: 300,
                    child: const Center(
                        child: Text(
                      'Create deck',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          ),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showMyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          width: 300,
          child: Form(
            key: controller.formKey,
            child: AlertDialog(
              backgroundColor: AppColor.scaffoldBackgroundColor,
              title: const Text(
                'Create deck',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: controller.deckController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required.";
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                  ),
                  ),
                  const SizedBox(
                    height: 40,
                  )
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                 ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
                TextButton(
                  onPressed: controller.createDeck,
                  child: const Text(
                    'Ok',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
