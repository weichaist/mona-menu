import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/home_controller.dart';
import 'package:mona_console/screens/home_screen/components/profile_image_container.dart';
import 'package:mona_console/screens/setting_screen/edit_screens/edit_menu_screen.dart';
import 'package:mona_console/top_level_components/buttons/default_icon_button.dart';

AppBar buildPrimaryAppBar() {
  HomeController homeController = HomeController.instance;
  homeController.initOnboarding();
  return AppBar(
    title: Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => const EditMenuScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kRestaurantColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('メニューを編集'),
            ),
          ),
          GestureDetector(
            onTap: () async {
              Get.toNamed('/settings');
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [kDefaultShadow],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              child: Obx(
                () => Row(
                  children: [
                    ProfileImageContainer(
                      imageUrl: homeController
                          .restaurantAccInfo
                          .value
                          .profileImageUrl!,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        homeController.restaurantAccInfo.value.name!,
                        style: const TextStyle(color: kRestaurantColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    leading: DefaultIconButton(
      icon: Icons.menu,
      onTap: () {
        homeController.openOrCloseDrawer();
      },
    ),
  );
}
