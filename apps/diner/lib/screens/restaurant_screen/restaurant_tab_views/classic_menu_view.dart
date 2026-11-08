import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/cart_controller.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/screens/restaurant_screen/components/classic_menu_list_view_card.dart';
import 'package:mona_diner/screens/restaurant_screen/components/menu_category_list_view.dart';
import 'package:mona_diner/screens/restaurant_screen/sub_screens/menu_item_detail_screen.dart';
import 'package:mona_diner/size_config.dart';

class ClassicMenuView extends StatelessWidget {
  const ClassicMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantController = RestaurantController.instance;
    return RefreshIndicator(
      onRefresh: () async {
        await restaurantController.initRestaurantController();
        await Future.delayed(const Duration(seconds: 1));
      },
      color: kPrimaryColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 54,
              width: getScreenWidth(),
              margin: const EdgeInsets.symmetric(horizontal: 9),
              decoration: BoxDecoration(
                color: kPrimaryLightColor.withValues(alpha: 0.84),
                borderRadius: BorderRadius.circular(12),
              ),
              child: MenuCategoryListView(
                onTap: (index) {
                  restaurantController.categoryPositionIndex.value = index;
                },
              ),
            ),
            const ClassicMenuList(),
            const SizedBox(height: 84),
          ],
        ),
      ),
    );
  }
}

class ClassicMenuList extends StatelessWidget {
  const ClassicMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantController = RestaurantController.instance;
    final cartController = CartController.instance;
    return Obx(() {
      if (restaurantController.categoryPositionIndex.value == 0) {
        if (restaurantController.menuCategories.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Obx(() {
                final category = restaurantController.menuCategories[index];
                final filteredList = restaurantController.dishList
                    .where((dish) => dish.categories!.contains(category))
                    .toList();
                return Column(
                  children: [
                    ListTile(
                      dense: true,
                      title: Text(
                        category,
                        style: const TextStyle(fontSize: 18),
                      ),
                      leading: const Icon(
                        Icons.format_list_bulleted_rounded,
                        color: kPrimaryColor,
                      ),
                    ),
                    for (var dish in filteredList)
                      Column(
                        children: [
                          RestaurantMenuListViewCard(
                            menuItem: dish,
                            addedToCart: cartController.menuItemExistsInCart(
                              dish.docId,
                            ),
                            onTap: () {
                              Get.to(
                                () => MenuItemDetailScreen(menuItem: dish),
                              );
                            },
                          ),
                          const SizedBox(height: 9),
                        ],
                      ),
                  ],
                );
              });
            },
            itemCount: restaurantController.menuCategories.length,
          );
        } else {
          return const SizedBox();
        }
      } else {
        final category0 = restaurantController
            .menuCategories[restaurantController.categoryPositionIndex.value];
        final filteredList0 = restaurantController.dishList
            .where((dish) => dish.categories!.contains(category0))
            .toList();
        return Column(
          children: [
            ListTile(
              dense: true,
              title: Text(category0, style: const TextStyle(fontSize: 18)),
              leading: const Icon(
                Icons.format_list_bulleted_rounded,
                color: kPrimaryColor,
              ),
            ),
            for (var dish in filteredList0)
              Column(
                children: [
                  RestaurantMenuListViewCard(
                    menuItem: dish,
                    addedToCart: false,
                    onTap: () {
                      Get.to(() => MenuItemDetailScreen(menuItem: dish));
                    },
                  ),
                  const SizedBox(height: 9),
                ],
              ),
          ],
        );
      }
    });
  }
}
