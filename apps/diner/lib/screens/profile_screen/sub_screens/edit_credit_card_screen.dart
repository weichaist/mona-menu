import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/payment_controller.dart';
import 'package:mona_diner/screens/profile_screen/sub_screens/new_card_screen.dart';
import 'package:mona_diner/screens/top_level_components/snackbar_dialog_bottomsheet/build_confirmation_dialog.dart';

class EditCreditCardScreen extends StatelessWidget {
  const EditCreditCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentController = PaymentController.instance;
    paymentController.initPaymentController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('Method of payment'),
          style: const TextStyle(color: kAppBarTextColor),
        ),
      ),
      body: Column(
        children: [
          Obx(
            () => ListView.builder(
              itemBuilder: (context, index) {
                final card = paymentController.existingCards[index];
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
                  trailing: const Icon(
                    CupertinoIcons.delete,
                    color: CupertinoColors.destructiveRed,
                  ),
                  onTap: () async {
                    final res = await buildConfirmationDialog();
                    if (res ?? false) {
                      await paymentController.deleteCard(card);
                      await paymentController.initPaymentController();
                    }
                  },
                );
              },
              itemCount: paymentController.existingCards.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0),
            ),
          ),
          const Divider(),
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
              color: CupertinoColors.activeGreen,
            ),
            onTap: () async {
              Get.to(() => const AddNewCardScreen());
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
