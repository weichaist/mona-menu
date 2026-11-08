import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/cart_controller.dart';
import 'package:mona_diner/controllers/payment_controller.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/screens/order_confirmation_screen/components/apple_pay_purchase_button.dart';
import 'package:mona_diner/screens/order_confirmation_screen/components/confirm_menu_item_list.dart';
import 'package:mona_diner/screens/order_confirmation_screen/components/order_confirmation_purchase_button.dart';
import 'package:mona_diner/screens/order_confirmation_screen/components/select_payment_method_section.dart';
import 'package:mona_diner/screens/order_confirmation_screen/components/table_selection_tile.dart';
import 'package:mona_diner/screens/restaurant_screen/components/single_marker_google_map.dart';
import 'package:mona_diner/size_config.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_get_snackbar.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Body extends StatelessWidget {
  const Body({super.key});
  @override
  Widget build(BuildContext context) {
    final restaurantController = RestaurantController.instance;
    final cartController = CartController.instance;
    final paymentController = PaymentController.instance;
    return ListView(
      children: [
        SingleMarkerGMap(
          markerPosition: LatLng(
            restaurantController.restaurantData.value.lat!,
            restaurantController.restaurantData.value.lng!,
          ),
        ),
        Obx(
          () => Container(
            width: getScreenWidth(),
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 9.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Center(
                    child: ToggleSwitch(
                      minWidth: double.infinity,
                      cornerRadius: 9.0,
                      activeBgColors: const [
                        [kPrimaryColor],
                        [kPrimaryColor],
                      ],
                      activeFgColor: CupertinoColors.white,
                      inactiveBgColor: kPrimaryLightColor,
                      inactiveFgColor: kPrimaryColor,
                      initialLabelIndex:
                          restaurantController.restaurantData.value.eatIn
                          ? 0
                          : 1,
                      totalSwitches: 2,
                      labels: ['🍽 ${tr('Eat-in')}', '🚶🏻 ${tr('Takeout')}'],
                      fontSize: 12,
                      radiusStyle: false,
                      changeOnTap: false,
                      onToggle: (index) {
                        if (index != null) {
                          // _orderInCartController.orderType.value =
                          // OrderType.values[index];
                          int currentIndex =
                              restaurantController.restaurantData.value.eatIn
                              ? 0
                              : 1;
                          if (index != currentIndex) {
                            restaurantController.restaurantData.value.eatIn
                                ? buildGetSnackbar(
                                    tr('Currently not supported'),
                                    '🚶🏻 ${tr('Takeout')} 🙅🏻‍♂️',
                                  )
                                : buildGetSnackbar(
                                    tr('Currently not supported'),
                                    '🍽 ${tr('Eat-in')} 🙅🏻‍♂️',
                                  );
                          }
                        }
                      },
                    ),
                  ),
                ),
                if (cartController.orderType.value == OrderType.eatIn)
                  const SelectTableTile(),
              ],
            ),
          ),
        ),
        const Divider(thickness: 1.5),
        const OrderConfirmationMenuItemList(),
        const OrderConfirmationPaymentSelection(),
        const Divider(thickness: 1.5),
        const OrderConfirmationFinalPriceCheck(),
        Padding(
          padding: const EdgeInsets.only(bottom: 9.0),
          child: Obx(() {
            if (paymentController.chosenPaymentMethod.value == 'ApplePay' &&
                Platform.isIOS) {
              return const ApplePayPurchaseButton();
            } else {
              return OrderConfirmationPurchaseButton(
                onTap: () async {
                  if (cartController.checkOrderInfoCompleted()) {
                    await paymentController.processPayment(
                      cartController
                          .totalOrderPrice(restaurantController.tax.value)
                          .toInt()
                          .toString(),
                      restaurantController.restaurantData.value,
                    );
                  } else {
                    buildGetSnackbar(
                      tr('Please choose a table'),
                      '${tr('Table')} 👀',
                    );
                  }
                },
              );
            }
          }),
        ),
      ],
    );
  }
}
