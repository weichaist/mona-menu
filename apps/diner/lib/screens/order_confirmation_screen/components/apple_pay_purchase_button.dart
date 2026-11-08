import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/cart_controller.dart';
import 'package:mona_diner/controllers/payment_controller.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_get_snackbar.dart';
import 'package:pay/pay.dart';

class ApplePayPurchaseButton extends StatefulWidget {
  const ApplePayPurchaseButton({super.key});

  @override
  State<ApplePayPurchaseButton> createState() => _ApplePayPurchaseButtonState();
}

class _ApplePayPurchaseButtonState extends State<ApplePayPurchaseButton> {
  final _cartController = CartController.instance;
  final _restaurantController = RestaurantController.instance;
  final _paymentController = PaymentController.instance;
  List<PaymentItem> paymentItems = [];

  final Future<Pay> _payClient = PaymentConfiguration.fromAsset(
    'default_payment_profile_apple_pay.json',
  ).then((config) => Pay({PayProvider.apple_pay: config}));
  late final Future<bool> _userCanPay = _payClient.then(
    (payClient) => payClient.userCanPay(PayProvider.apple_pay),
  );

  void onApplePayPressed() async {
    if (_cartController.checkOrderInfoCompleted()) {
      try {
        final amount = _cartController
            .totalOrderPrice(_restaurantController.tax.value)
            .toInt()
            .toString();
        final payClient = await _payClient;
        final result = await payClient
            .showPaymentSelector(PayProvider.apple_pay, [
              PaymentItem(
                label: 'Mona Menu',
                amount: amount,
                status: PaymentItemStatus.final_price,
              ),
            ]);
        await _paymentController.processApplePay(
          result,
          amount,
          _restaurantController.restaurantData.value,
        );
      } catch (e) {
        debugPrint(e.toString());
        EasyLoading.showError(tr('Canceled'));
      }
    } else {
      buildGetSnackbar(tr('Please choose a table'), '${tr('Table')} 👀');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _userCanPay,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 36),
              child: SizedBox(
                height: 48,
                child: RawApplePayButton(
                  style: ApplePayButtonStyle.black,
                  type: ApplePayButtonType.inStore,
                  onPressed: onApplePayPressed,
                ),
              ),
            );
          } else {
            return const SizedBox(
              width: double.infinity,
              height: 48,
              child: Center(
                child: Text(
                  'Apple Pay is not supported',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
        } else {
          return const Center(child: CupertinoActivityIndicator());
        }
      },
    );
  }
}
