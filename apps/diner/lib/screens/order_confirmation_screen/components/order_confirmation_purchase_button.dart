import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/cart_controller.dart';
import 'package:mona_diner/size_config.dart';

class OrderConfirmationPurchaseButton extends StatelessWidget {
  final VoidCallback onTap;
  const OrderConfirmationPurchaseButton({super.key, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final orderInCartController = CartController.instance;
    return Obx(
      () => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: getScreenWidth(),
          height: 57,
          decoration: BoxDecoration(
            color: orderInCartController.checkOrderInfoCompleted()
                ? kPrimaryColor.withValues(alpha: 0.9)
                : kBgColor.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(9.0),
          ),
          child: Center(
            child: Text(
              tr('Purchase'),
              style: TextStyle(
                color: orderInCartController.checkOrderInfoCompleted()
                    ? CupertinoColors.white
                    : kBodyTextColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
