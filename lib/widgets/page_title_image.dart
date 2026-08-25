import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/add_card_controller.dart';
import 'package:upgrade/widgets/app_image.dart';

class PageTitleImage extends GetView<AddCardController> {
  final CardTypes type;
  final FrontBackType type2;

  const PageTitleImage(this.type, this.type2, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Text(
            controller.getTitle(type, type2),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          if (controller.commentImage.isEmpty&&type != CardTypes.occlusion ) ...[
            const Spacer(),
            if (controller.getImage(type2).isNotEmpty)
              SizedBox(
                width: 50,
                height: 50,
                child: Stack(
                  children: [
                    AppImage(
                      image: controller.getImage(type2),
                      fit: BoxFit.cover,
                      radius: 5,
                    ),
                    InkWell(
                      onTap: () => controller.onTapClearImage(type2),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              IconButton(
                onPressed: () {
                  controller.pickImage(type2);
                },
                icon: const Icon(
                  Icons.attachment,
                ),
              ),
            const SizedBox(
              width: 10,
            ),
          ],
        ],
      ),
    );
  }
}
