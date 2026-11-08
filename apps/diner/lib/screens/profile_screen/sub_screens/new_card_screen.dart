import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/payment_controller.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_text_button.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});
  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  CardFieldInputDetails? _card;
  @override
  Widget build(BuildContext context) {
    final paymentController = PaymentController.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('Add card'),
          style: const TextStyle(color: kPrimaryColor),
        ),
        actions: [
          DefaultTextButton(
            label: tr('Completion'),
            onPressed: () async {
              if (_card != null && _card!.complete) {
                FocusManager.instance.primaryFocus!.unfocus();
                await paymentController.saveNewCard(_card!);
                await paymentController.initPaymentController();
                Get.back();
              } else {
                await EasyLoading.showError(tr('Card information is invalid'));
              }
            },
            color: _card != null
                ? _card!.complete
                      ? kPrimaryColor
                      : kAppBarTextColor
                : kAppBarTextColor,
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CardField(
                cursorColor: kPrimaryColor,
                onCardChanged: (card) {
                  _card = card;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
