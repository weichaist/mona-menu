import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/cart_controller.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:mona_diner/screens/top_level_components/money/jpy_text.dart';
import 'package:mona_diner/size_config.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_get_snackbar.dart';
import 'package:toggle_switch/toggle_switch.dart';

class OrderConfirmationMenuItemList extends StatelessWidget {
  const OrderConfirmationMenuItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    return Container(
      width: getScreenWidth(),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 9.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              tr('Ordered Product'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Obx(
            () => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final dish = cartController.ordersInCart[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ListTile(
                      visualDensity: const VisualDensity(horizontal: -1.5),
                      title: Text(
                        dish.menuItemTitle!,
                        style: const TextStyle(
                          color: kBodyTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: Text('${dish.orderCount!.toString()}x'),
                      trailing: JPYText(
                        price: dish.orderCount! * dish.price!.toInt(),
                      ),
                      minLeadingWidth: 3.0,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0.0,
                      ),
                    ),
                    ToggleSwitch(
                      minWidth: 63,
                      minHeight: 33,
                      cornerRadius: 9.0,
                      activeBgColors: const [
                        [kPrimaryColor],
                        [kPrimaryLightColor],
                      ],
                      activeFgColor: CupertinoColors.white,
                      inactiveBgColor: kPrimaryLightColor,
                      inactiveFgColor: kPrimaryColor,
                      initialLabelIndex: 0,
                      totalSwitches: 2,
                      labels: const ['+', '-'],
                      radiusStyle: false,
                      changeOnTap: false,
                      onToggle: (plusMinus) {
                        if (plusMinus != null) {
                          //check if item is service charge
                          if (dish.menuItemCategories!.contains('サービスチャージ')) {
                            //check if more than one items in the order
                            if (cartController.ordersInCart.length > 1 ||
                                cartController.monaOrdersInCart.isNotEmpty) {
                              //only plus is possible for service charge
                              if (dish.orderCount! > 1) {
                                cartController.updateOrderCountInCart(
                                  dish.menuItemDocID,
                                  plusMinus,
                                );
                              } else {
                                if (plusMinus != 1) {
                                  cartController.updateOrderCountInCart(
                                    dish.menuItemDocID,
                                    plusMinus,
                                  );
                                } else {
                                  buildGetSnackbar(
                                    tr('Service charge is required.'),
                                    tr(
                                      'When ordering the number of multiple people together, please select the number in which one orderer is subtracted from the total number of people before ordering.',
                                    ),
                                  );
                                }
                              }
                            } else {
                              //in case of only service charge is in the cart, user can delete
                              cartController.updateOrderCountInCart(
                                dish.menuItemDocID,
                                plusMinus,
                              );
                            }
                          } else {
                            //if category is not service charge
                            cartController.updateOrderCountInCart(
                              dish.menuItemDocID,
                              plusMinus,
                            );
                          }
                          //back to order screen if empty
                          if (cartController.monaOrdersInCart.isEmpty &&
                              cartController.ordersInCart.isEmpty) {
                            Get.back();
                          }
                        }
                      },
                    ),
                    const Divider(thickness: 0.9, color: kPrimaryLightColor),
                  ],
                );
              },
              itemCount: cartController.ordersInCart.length,
            ),
          ),
          Obx(
            () => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var monaOrder = cartController.monaOrdersInCart[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        ProfileAvatarContainer(
                          imageUrl: monaOrder.affiliateUserProfileUrl!,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9.0),
                          child: Text(monaOrder.affiliateUserDisplayName!),
                        ),
                      ],
                    ),
                    ListTile(
                      visualDensity: const VisualDensity(horizontal: -1.5),
                      minLeadingWidth: 3.0,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0.0,
                      ),
                      title: Text(
                        monaOrder.menuItemTitle!,
                        style: const TextStyle(
                          color: kBodyTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: Text('${monaOrder.orderCount!.toString()}x'),
                      trailing: JPYText(
                        price: monaOrder.orderCount! * monaOrder.price!.toInt(),
                      ),
                    ),
                    ToggleSwitch(
                      minWidth: 63,
                      minHeight: 33,
                      cornerRadius: 9.0,
                      activeBgColors: const [
                        [kPrimaryColor],
                        [kPrimaryLightColor],
                      ],
                      activeFgColor: CupertinoColors.white,
                      inactiveBgColor: kPrimaryLightColor,
                      inactiveFgColor: kPrimaryColor,
                      initialLabelIndex: 0,
                      totalSwitches: 2,
                      labels: const ['+', '-'],
                      radiusStyle: false,
                      changeOnTap: false,
                      onToggle: (plusMinus) {
                        if (plusMinus != null) {
                          cartController.updateMonaOrderCountInCart(
                            monaOrder.affiliatePostId,
                            plusMinus,
                          );
                          if (cartController.monaOrdersInCart.isEmpty &&
                              cartController.ordersInCart.isEmpty) {
                            Get.back();
                          }
                        }
                      },
                    ),
                    const Divider(thickness: 0.9, color: kPrimaryLightColor),
                  ],
                );
              },
              itemCount: cartController.monaOrdersInCart.length,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderConfirmationFinalPriceCheck extends StatelessWidget {
  const OrderConfirmationFinalPriceCheck({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantController = RestaurantController.instance;
    final cartController = CartController.instance;
    return Container(
      width: getScreenWidth(),
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        top: 9.0,
        bottom: 36.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              tr('Price (Tax Included)'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
            dense: true,
            title: Text(
              tr('Consumption Tax'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: kBodyTextColor,
              ),
            ),
            trailing: Text('${restaurantController.tax * 100.toInt()}%'),
          ),
          Obx(
            () => ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
              title: Text(
                tr('Total'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kBodyTextColor,
                ),
              ),
              trailing: JPYText(
                price: cartController
                    .totalOrderPrice(restaurantController.tax.value)
                    .toInt(),
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
