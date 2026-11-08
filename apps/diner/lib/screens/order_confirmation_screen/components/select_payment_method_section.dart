import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/payment_controller.dart';
import 'package:mona_diner/screens/profile_screen/sub_screens/new_card_screen.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_icon_button.dart';
import 'package:mona_diner/size_config.dart';

class OrderConfirmationPaymentSelection extends StatefulWidget {
  const OrderConfirmationPaymentSelection({super.key});

  @override
  State<OrderConfirmationPaymentSelection> createState() =>
      _OrderConfirmationPaymentSelectionState();
}

class _OrderConfirmationPaymentSelectionState
    extends State<OrderConfirmationPaymentSelection> {
  @override
  void initState() {
    Stripe.instance.isPlatformPaySupportedListenable.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    Stripe.instance.isPlatformPaySupportedListenable.removeListener(update);
    super.dispose();
  }

  void update() {
    setState(() {});
  }

  final _paymentController = PaymentController.instance;

  Widget buildIOSPaymentSelection() {
    if (_paymentController.chosenPaymentMethod.value == 'ApplePay') {
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset('assets/images/apple-pay.png', height: 36)],
        ),
        title: const Text(
          'Apple Pay',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(tr('Select another payment method')),
        onTap: () async {
          // await FirebaseFunctions.instance.httpsCallable('emailReceiptWithIntentUpdate').call();
          await buildSelectPaymentBottomSheet();
        },
      );
    } else {
      return ListTile(
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(CupertinoIcons.creditcard, color: kPrimaryColor),
          ],
        ),
        title: Text(
          '${_paymentController.selectedSavedCard!.value.cardBrand} **** ${_paymentController.selectedSavedCard!.value.last4}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () async {
          await buildSelectPaymentBottomSheet();
        },
      );
    }
  }

  Widget buildAndroidPaymentSelection() {
    if (_paymentController.chosenPaymentMethod.value == 'ApplePay') {
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(CupertinoIcons.creditcard, color: kPrimaryColor),
          ],
        ),
        title: Text(
          tr('Payment Method'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(tr('Select a card')),
        onTap: () async {
          // await FirebaseFunctions.instance.httpsCallable('emailReceiptWithIntentUpdate').call();
          await buildSelectPaymentBottomSheet();
        },
      );
    } else {
      return ListTile(
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(CupertinoIcons.creditcard, color: kPrimaryColor),
          ],
        ),
        title: Text(
          '${_paymentController.selectedSavedCard!.value.cardBrand} **** ${_paymentController.selectedSavedCard!.value.last4}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () async {
          await buildSelectPaymentBottomSheet();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _paymentController.canApplePay.value =
        Stripe.instance.isPlatformPaySupportedListenable.value;
    // final _profileController = ProfileController.instance;
    // _profileController.initFetchingCurrentUserPostPurchasedHistory();
    return Container(
      width: getScreenWidth(),
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                tr('Payment'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (Platform.isIOS)
              buildIOSPaymentSelection()
            else
              buildAndroidPaymentSelection(),
          ],
        ),
      ),
    );
  }
}

Future<void> buildSelectPaymentBottomSheet() async {
  final paymentController = PaymentController.instance;
  paymentController.initPaymentController();
  await Get.bottomSheet(
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      tr('Method of payment'),
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  DefaultIconButton(
                    icon: CupertinoIcons.clear_circled,
                    onTap: () {
                      Get.back();
                    },
                  ),
                ],
              ),
              if (Platform.isIOS) const Divider(),
              if (Platform.isIOS)
                ListTile(
                  leading: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/apple-pay.png', height: 36),
                    ],
                  ),
                  title: const Text(
                    'Apple Pay',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Obx(
                    () => Icon(
                      CupertinoIcons.check_mark_circled_solid,
                      color:
                          paymentController.chosenPaymentMethod.value ==
                              'ApplePay'
                          ? CupertinoColors.activeGreen
                          : CupertinoColors.systemGrey3,
                    ),
                  ),
                  onTap: () {
                    paymentController.chosenPaymentMethod.value = 'ApplePay';
                    Get.back();
                  },
                ),
              const Divider(height: 0),
              Obx(
                () => ListView.builder(
                  itemBuilder: (context, index) {
                    final card = paymentController.existingCards[index];
                    final cardId =
                        card.last4! +
                        card.expiryYear!.toString() +
                        card.expiryMonth!.toString();
                    return ListTile(
                      leading: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(CupertinoIcons.creditcard, color: kPrimaryColor),
                        ],
                      ),
                      title: Text(
                        '${card.cardBrand} **** ${card.last4}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Obx(
                        () => Icon(
                          CupertinoIcons.check_mark_circled_solid,
                          color:
                              paymentController.chosenPaymentMethod.value ==
                                  cardId
                              ? CupertinoColors.activeGreen
                              : CupertinoColors.systemGrey3,
                        ),
                      ),
                      onTap: () {
                        paymentController.chosenPaymentMethod.value = cardId;
                        paymentController.selectedSavedCard = card.obs;
                        Get.back();
                      },
                    );
                  },
                  itemCount: paymentController.existingCards.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                ),
              ),
              const Divider(height: 0),
              ListTile(
                leading: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(CupertinoIcons.creditcard, color: kPrimaryColor),
                  ],
                ),
                title: Text(
                  tr('Add a new card'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(
                  CupertinoIcons.add_circled,
                  color: CupertinoColors.systemGrey3,
                ),
                onTap: () async {
                  Get.to(() => const AddNewCardScreen());
                },
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    ),
  );
}
