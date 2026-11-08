import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/cart_controller.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/models/restaurant_menu_item_model.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_get_snackbar.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CartManagementTile extends StatelessWidget {
  const CartManagementTile({super.key, required this.menuItem});
  final RestaurantMenuItem menuItem;
  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final restaurantController = RestaurantController.instance;
    return Obx(
      () => cartController.menuItemExistsInCart(menuItem.docId)
          ? SettingTileWithToggleSwitch(
              title:
                  '${tr('Quantity')}: ${cartController.orderCountInCart(menuItem.docId)}',
              labels: const ['+', '-'],
              initLabelIndex: 0,
              onToggle: (index) async {
                if (index != null) {
                  final soldOut = menuItem.soldOut;
                  // final soldOut =
                  //     await _cartController.fetchMenuItemSoldOutStatus(
                  //         menuItem.docId!,
                  //         _restaurantController.restaurantData.value.uid!);
                  if (!soldOut) {
                    cartController.updateOrderCountInCart(
                      menuItem.docId,
                      index,
                    );
                  } else {
                    buildGetSnackbar(
                      tr('he food is sold out.'),
                      tr('Sold out'),
                    );
                    cartController.removeSoldOutMenuItems(menuItem.docId!);
                  }
                }
              },
            )
          : SettingTileWithToggleSwitch(
              title: '${tr('Quantity')}: 0',
              labels: [tr('Add Order')],
              initLabelIndex: 0,
              fontSize: 15,
              onToggle: (index) async {
                bool canOrder =
                    restaurantController.confirmMenuItemInCurrentMenuGroup(
                      menuItem.menuGroup!,
                    ) &&
                    cartController.checkRestaurantOpenStatus(
                      restaurantController.restaurantData.value,
                    );
                if (canOrder) {
                  final soldOut = menuItem.soldOut;
                  // final soldOut =
                  //     await _cartController.fetchMenuItemSoldOutStatus(
                  //         menuItem.docId!,
                  //         _restaurantController.restaurantData.value.uid!);
                  if (!soldOut) {
                    cartController.addRestaurantMenuOrderToCart(menuItem);
                  } else {
                    buildGetSnackbar(
                      tr('I can\'t use it right now.'),
                      tr('Sold out'),
                    );
                  }
                } else {
                  buildGetSnackbar(tr('I can\'t use it right now.'), '🙅🏻‍♂');
                }
              },
            ),
    );
  }
}

class SettingTileWithToggleSwitch extends StatelessWidget {
  final String title;
  final int initLabelIndex;
  final List<String> labels;
  final List<IconData>? icons;
  final Function(int?) onToggle;
  final double fontSize;
  const SettingTileWithToggleSwitch({
    super.key,
    required this.title,
    required this.initLabelIndex,
    required this.labels,
    required this.onToggle,
    this.icons,
    this.fontSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ToggleSwitch(
            minWidth: 75.0 * 2 / labels.length,
            cornerRadius: 9.0,
            activeBgColors: const [
              [kPrimaryColor],
              [kPrimaryLightColor],
            ],
            activeFgColor: CupertinoColors.white,
            inactiveBgColor: kPrimaryLightColor,
            inactiveFgColor: kPrimaryColor,
            initialLabelIndex: initLabelIndex,
            totalSwitches: labels.length,
            labels: labels,
            icons: icons,
            radiusStyle: false,
            changeOnTap: false,
            onToggle: onToggle,
            fontSize: fontSize,
          ),
        ],
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: kBodyTextColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
