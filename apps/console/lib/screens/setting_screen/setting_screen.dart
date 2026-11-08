import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mona_console/config.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/home_controller.dart';
import 'package:mona_console/controllers/setting_controller.dart';
import 'package:mona_console/screens/home_screen/components/profile_image_container.dart';
import 'package:mona_console/screens/setting_screen/components/custom_setting_tile.dart';
import 'package:mona_console/screens/setting_screen/components/custom_setting_tile_with_toggle_switch.dart';
import 'package:mona_console/screens/setting_screen/edit_screens/edit_basic_info_screen.dart';
import 'package:mona_console/screens/setting_screen/edit_screens/edit_business_hour_screen.dart';
import 'package:mona_console/screens/setting_screen/edit_screens/edit_menu_screen.dart';
import 'package:mona_console/screens/setting_screen/edit_screens/edit_restaurant_intro_screen.dart';
import 'package:mona_console/screens/setting_screen/edit_screens/edit_table_number_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final settingController = SettingController.instance;
    settingController.initSettingData();
    final homeController = HomeController.instance;
    final auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント設定', style: TextStyle(color: kBodyTextColor)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
                boxShadow: const [kDefaultShadow],
              ),
              child: Column(
                children: [
                  Obx(
                    () => ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 15,
                      ),
                      leading: ProfileImageContainer(
                        radius: 48,
                        imageUrl: homeController
                            .restaurantAccInfo
                            .value
                            .profileImageUrl!,
                      ),
                      title: Text(
                        homeController.restaurantAccInfo.value.name!,
                        style: const TextStyle(
                          color: kRestaurantColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: auth.currentUser != null
                          ? Text(auth.currentUser!.email!)
                          : Text(''),
                      trailing: GestureDetector(
                        onTap: () {
                          Get.to(() => const EditBasicInfoScreen());
                        },
                        child: const Icon(
                          CupertinoIcons.pencil_circle,
                          color: kRestaurantColor,
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 0),
                  CustomSettingTile(
                    leadingIcon: const Icon(
                      CupertinoIcons.info,
                      color: kRestaurantColor,
                    ),
                    title: '店舗紹介を追加',
                    onTap: () {
                      Get.to(() => const EditRestaurantIntroScreen());
                    },
                  ),
                  const Divider(height: 0),
                  CustomSettingTile(
                    leadingIcon: const Icon(
                      CupertinoIcons.clock,
                      color: kRestaurantColor,
                    ),
                    title: '営業時間を編集',
                    onTap: () {
                      Get.to(() => const EditBusinessHourScreen());
                    },
                  ),
                  const Divider(height: 0),
                  CustomSettingTile(
                    leadingIcon: SvgPicture.asset(
                      'assets/images/menu.svg',
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        kRestaurantColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    title: 'メニューを編集',
                    onTap: () {
                      Get.to(() => const EditMenuScreen());
                    },
                  ),
                  const Divider(height: 0),
                  CustomSettingTile(
                    leadingIcon: SvgPicture.asset(
                      'assets/icons/chair.svg',
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        kRestaurantColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    title: 'テーブル番号を編集',
                    onTap: () {
                      Get.to(() => const EditTableNumberScreen());
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
                boxShadow: const [kDefaultShadow],
              ),
              child: Column(
                children: [
                  CustomSettingTile(
                    leadingIcon: const Icon(
                      CupertinoIcons.question_circle,
                      color: kRestaurantColor,
                    ),
                    title: '問い合わせ',
                    onTap: () {
                      Get.defaultDialog(
                        title: 'Mona',
                        content: const Padding(
                          padding: EdgeInsets.all(36.0),
                          child: SelectableText(AppConfig.supportEmail),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            const OpenNowToggleSwitch(),
          ],
        ),
      ),
    );
  }
}

class OpenNowToggleSwitch extends StatelessWidget {
  const OpenNowToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final settingController = SettingController.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
      child: Column(
        children: [
          const Divider(thickness: 1.5),
          Obx(
            () => CustomSettingTileWithToggleSwitch(
              title: 'お店の空き状態',
              labels: const ['空席あり', '満席'],
              initLabelIndex: settingController.seatAvailableNow.value ? 0 : 1,
              onToggle: (index) async {
                bool indexToBool = index == 0 ? true : false;
                if (settingController.seatAvailableNow.value != indexToBool) {
                  settingController.seatAvailableNow.value = indexToBool;
                  await settingController.saveOpenNowSettings();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
