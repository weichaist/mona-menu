import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/menu_controller.dart';
import 'package:mona_console/screens/setting_screen/components/quick_view_dish_list_tile.dart';
import 'package:mona_console/screens/setting_screen/edit_screens/edit_dinner_menu_screen.dart';
import 'package:mona_console/screens/setting_screen/edit_screens/edit_lunch_menu_screen.dart';
import 'package:mona_console/size_config.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_confirmation_dialog.dart';

class EditMenuScreen extends StatelessWidget {
  const EditMenuScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final menuController = RestaurantMenuController.instance;
    menuController.initFetchSettings();
    menuController.initDishList();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'メニュー管理',
            style: TextStyle(color: kAppBarTextColor),
          ),
          bottom: const TabBar(
            labelColor: kRestaurantColor,
            indicatorColor: kRestaurantColor,
            unselectedLabelColor: kAppBarColor,
            tabs: <Widget>[
              Tab(text: 'ランチメニュー ☀️'),
              Tab(text: 'ディナーメニュー 🌃'),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[LunchMenuView(), DinnerMenuView()],
        ),
      ),
    );
  }
}

class LunchMenuView extends StatelessWidget {
  const LunchMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final menuController = RestaurantMenuController.instance;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: getScreenHeight(),
          width: getScreenWidth() / 3 * 2,
          margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [kDefaultShadow],
          ),
          child: Column(
            children: [
              ListTile(
                title: const Text('ランチメニューを編集'),
                leading: const Icon(
                  CupertinoIcons.pencil_circle,
                  color: kRestaurantColor,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: kRestaurantColor,
                ),
                onTap: () {
                  Get.to(() => const EditLunchMenuScreen());
                },
              ),
              const Divider(color: kRestaurantColor, height: 0),
              Expanded(
                child: Obx(() {
                  if (menuController.lunchMenuCategoryList.isNotEmpty) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final category =
                              menuController.lunchMenuCategoryList[index];
                          final filteredList = menuController.lunchDishList
                              .where(
                                (dish) => dish.categories!.contains(category),
                              )
                              .toList();
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  category,
                                  style: const TextStyle(fontSize: 21),
                                ),
                                leading: const Icon(
                                  Icons.format_list_bulleted_rounded,
                                  color: kRestaurantColor,
                                ),
                                onTap: () {},
                              ),
                              const Divider(height: 0, color: kAppBarColor),
                              for (final dish in filteredList)
                                QuickViewDishTile(
                                  menuItem: dish,
                                  onSoldOut: (val) async {
                                    final res = await buildConfirmationDialog();
                                    if (res != null) {
                                      if (res) {
                                        await menuController
                                            .updateSoldOutStatus(
                                              dish.docId!,
                                              val!,
                                            );
                                        await menuController.initDishList();
                                      }
                                    }
                                  },
                                ),
                              // const Divider(
                              //   height: 0,
                              //   color: kAppBarColor,
                              // ),
                            ],
                          );
                        });
                      },
                      itemCount: menuController.lunchMenuCategoryList.length,
                    );
                  } else {
                    return Center(
                      child: SvgPicture.asset(
                        'assets/images/menu.svg',
                        colorFilter: const ColorFilter.mode(
                          kRestaurantColor,
                          BlendMode.srcIn,
                        ),
                        height: 69,
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DinnerMenuView extends StatelessWidget {
  const DinnerMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final menuController = RestaurantMenuController.instance;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: getScreenHeight(),
          width: getScreenWidth() / 3 * 2,
          margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [kDefaultShadow],
          ),
          child: Column(
            children: [
              ListTile(
                title: const Text('ディナーメニューを編集'),
                leading: const Icon(
                  CupertinoIcons.pencil_circle,
                  color: kRestaurantColor,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: kRestaurantColor,
                ),
                onTap: () {
                  Get.to(() => const EditDinnerMenuScreen());
                },
              ),
              const Divider(color: kRestaurantColor, height: 0),
              Expanded(
                child: Obx(() {
                  if (menuController.dinnerMenuCategoryList.isNotEmpty) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final category =
                              menuController.dinnerMenuCategoryList[index];
                          final filteredList = menuController.dinnerDishList
                              .where(
                                (dish) => dish.categories!.contains(category),
                              )
                              .toList();
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  category,
                                  style: const TextStyle(fontSize: 21),
                                ),
                                leading: const Icon(
                                  Icons.format_list_bulleted_rounded,
                                  color: kRestaurantColor,
                                ),
                                onTap: () {},
                              ),
                              const Divider(height: 0),
                              for (final dish in filteredList)
                                QuickViewDishTile(
                                  menuItem: dish,
                                  onSoldOut: (val) async {
                                    final res = await buildConfirmationDialog();
                                    if (res != null) {
                                      if (res) {
                                        await menuController
                                            .updateSoldOutStatus(
                                              dish.docId!,
                                              val!,
                                            );
                                        await menuController.initDishList();
                                      }
                                    }
                                  },
                                ),
                            ],
                          );
                        });
                      },
                      itemCount: menuController.dinnerMenuCategoryList.length,
                    );
                  } else {
                    return Center(
                      child: SvgPicture.asset(
                        'assets/images/menu.svg',
                        colorFilter: const ColorFilter.mode(
                          kRestaurantColor,
                          BlendMode.srcIn,
                        ),
                        height: 69,
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
