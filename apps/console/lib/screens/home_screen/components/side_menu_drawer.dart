import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/home_controller.dart';
import 'package:mona_console/screens/home_screen/components/logo_with_text.dart';
import 'package:mona_console/screens/order_history_screen/order_history_screen.dart';

class SideMenuDrawer extends StatelessWidget {
  const SideMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = HomeController.instance;
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            margin: EdgeInsets.symmetric(vertical: 0),
            child: LogoText(),
          ),
          DrawerItem(
            label: 'ホーム',
            leadingIcon: CupertinoIcons.home,
            isActive: homeController.selectedIndex == 0,
            onTap: () {
              Get.back();
              // homeController.setMenuIndex(0);
              // Get.offAll(()=> const HomeScreen());
            },
          ),
          DrawerItem(
            label: 'オーダー履歴',
            leadingIcon: CupertinoIcons.list_bullet_indent,
            isActive: homeController.selectedIndex == 1,
            onTap: () {
              Get.to(() => const OrderHistoryScreen());
            },
          ),
          DrawerItem(
            label: '顧客管理',
            leadingIcon: CupertinoIcons.person_2,
            isActive: homeController.selectedIndex == 2,
            onTap: () {
              Get.toNamed('/customers');
            },
          ),
          DrawerItem(
            label: '投稿一覧',
            leadingIcon: CupertinoIcons.square_favorites_alt,
            isActive: homeController.selectedIndex == 3,
            onTap: () {
              Get.toNamed('/posts');
            },
          ),
          DrawerItem(
            label: '設定',
            leadingIcon: CupertinoIcons.gear_alt,
            isActive: homeController.selectedIndex == 4,
            onTap: () {
              Get.toNamed('/settings');
            },
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final IconData leadingIcon;
  const DrawerItem({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      onTap: onTap,
      selected: isActive,
      selectedTileColor: kRestaurantLightColor.withValues(alpha: 0.42),
      focusColor: kRestaurantLightColor.withValues(alpha: 0.9),
      leading: Icon(leadingIcon, color: kRestaurantColor),
      title: Text(
        label,
        style: const TextStyle(
          color: kRestaurantColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
