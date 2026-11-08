import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/cart_controller.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/models/restaurant_menu_item_model.dart';
import 'package:mona_diner/screens/restaurant_screen/components/cart_management_tile.dart';
import 'package:mona_diner/screens/restaurant_screen/components/floating_order_confirmation_tile_button.dart';
import 'package:mona_diner/screens/restaurant_screen/components/mona_menu_short_post_list.dart';
import 'package:mona_diner/screens/top_level_components/money/jpy_text.dart';
import 'package:mona_diner/size_config.dart';

class MenuItemDetailScreen extends StatelessWidget {
  final RestaurantMenuItem menuItem;
  const MenuItemDetailScreen({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    RestaurantController restaurantController = RestaurantController.instance;
    CartController cartController = CartController.instance;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              restaurantController.restaurantData.value.name!,
              style: const TextStyle(color: kAppBarTextColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 9.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [JPYText(price: menuItem.price!, fontSize: 17.7)],
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              width: getScreenWidth(),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(menuItem.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3.0,
                                ),
                                child: Text(
                                  menuItem.title!,
                                  style: const TextStyle(
                                    fontSize: 17.7,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                menuItem.description!,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.5),
                  CartManagementTile(menuItem: menuItem),
                  const Divider(thickness: 0.5),
                  MonaMenuItemPostShortList(
                    restaurantUid:
                        restaurantController.restaurantData.value.uid!,
                    menuItem: menuItem,
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(() {
          if (cartController.monaOrdersInCart.isNotEmpty ||
              cartController.ordersInCart.isNotEmpty) {
            return const SafeArea(child: FloatingOrderConfirmationTileButton());
          } else {
            return const SizedBox(height: 0);
          }
        }),
      ],
    );
  }
}
