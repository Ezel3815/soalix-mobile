import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/inter_code_controller.dart';
import 'package:upgrade/resources.dart';

class InterCodeDialog extends GetView<InterCodeController> {
  const InterCodeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => InterCodeController());
    return Dialog(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      surfaceTintColor: AppColor.scaffoldBackgroundColor,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: controller.formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Please enter the code to activate the decks",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: controller.codeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required.";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Enter Code",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Obx(
                    () => Expanded(
                      child: controller.loading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: controller.enterCode,
                              style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  AppColor.greenColor,
                                ),
                                elevation: WidgetStatePropertyAll(0),
                              ),
                              child: const Text(
                                "Active",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                        elevation: const WidgetStatePropertyAll(0),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
