import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/search_users_controller.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/screens/profile_screen.dart';
import 'package:upgrade/widgets/app_image.dart';

class SearchUsersScreen extends StatelessWidget {
  const SearchUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchUsersController());
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.scaffoldBackgroundColor,
        elevation: 0,
        title: TextField(
          autofocus: true,
          onChanged: controller.search,
          decoration: const InputDecoration(
            hintText: "Search by name or username",
            border: InputBorder.none,
          ),
        ),
      ),
      body: Obx(
        () {
          if (controller.loading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.greenColor),
            );
          }
          if (controller.results.isEmpty) {
            return const Center(
              child: Text(
                "Search for people to follow",
                style: TextStyle(color: AppColor.textSecondary),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.results.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final user = controller.results[index];
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => Get.toNamed(
                  AppRoutes.viewProfileRoute,
                  arguments: user.id,
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColor.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipOval(
                        child: (user.avatarPhotoName != null &&
                                user.avatarPhotoName!.isNotEmpty)
                            ? AppImage(
                                image: user.avatarPhotoName!,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 44,
                                height: 44,
                                color: AppColor.lightGreenColor,
                                child: const Icon(Icons.person,
                                    color: AppColor.greenColor),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColor.textPrimary,
                            ),
                          ),
                          if (user.username != null)
                            Text(
                              "@${user.username}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColor.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
