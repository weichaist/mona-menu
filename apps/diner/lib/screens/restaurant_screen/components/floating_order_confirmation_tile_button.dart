import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/cart_controller.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/screens/order_confirmation_screen/order_confirmation_screen.dart';
import 'package:mona_diner/screens/top_level_components/money/jpy_text.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_get_snackbar.dart';

class FloatingOrderConfirmationTileButton extends StatelessWidget {
  const FloatingOrderConfirmationTileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final restaurantController = RestaurantController.instance;
    return Obx(
      () => GestureDetector(
        onTap: () {
          if (cartController.checkRestaurantOpenStatus(
            restaurantController.restaurantData.value,
          )) {
            if (restaurantController.todayOrders.isEmpty) {
              if (restaurantController.menuCategories.contains('サービスチャージ')) {
                final serviceCharge = restaurantController.dishList.firstWhere(
                  (val) => val.categories!.contains('サービスチャージ'),
                );
                cartController.addRestaurantMenuOrderToCart(serviceCharge);
              }
            }
            Get.to(() => const OrderConfirmationScreen());
          } else {
            buildGetSnackbar(
              tr('Outside business hours'),
              tr('I can\'t use it right now.'),
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 9.0),
          decoration: BoxDecoration(
            color: kPrimaryColor.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(9.0),
          ),
          child: ListTile(
            minVerticalPadding: 9.0,
            visualDensity: const VisualDensity(vertical: 2.4),
            leading: CircleAvatar(
              backgroundColor: CupertinoColors.white,
              radius: 21,
              child: Text(
                cartController.totalOrderCount().toString(),
                style: const TextStyle(color: kPrimaryColor),
              ),
            ),
            title: Text(
              tr('Go to check your order'),
              style: const TextStyle(color: CupertinoColors.white),
            ),
            trailing: JPYText(
              price: cartController
                  .totalOrderPrice(restaurantController.tax.value)
                  .toInt(),
              fontColor: CupertinoColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
