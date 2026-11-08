import 'package:circular_countdown/circular_countdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:mona_diner/config.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/cart_controller.dart';
import 'package:mona_diner/models/card_model.dart';
import 'package:mona_diner/models/mona_user_model.dart';
import 'package:mona_diner/models/restaurant_account_model.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_text_button.dart';
import 'package:mona_diner/screens/top_level_components/money/jpy_text.dart';
import 'package:mona_diner/size_config.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_network_error_dialog.dart';

class PaymentController extends GetxController {
  static PaymentController instance = Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  //variables -------------------------------------------------------------------
  final canApplePay = false.obs;
  final existingCards = <UserCreditCard>[].obs;

  RxString chosenPaymentMethod = 'ApplePay'.obs;
  Rx<UserCreditCard>? selectedSavedCard;
  final stripeCustomerId = ''.obs;
  final mode = ''.obs;

  //functions --------------------------------------------------------------------
  Future<void> initStripe() async {
    try {
      await FirebaseFunctions.instance.httpsCallable('fetchStripePubKey').call({
        'mode': 'TEST',
      });
      final key = await fetchStripePubKey();
      if (key != null) {
        Stripe.publishableKey = key;
        Stripe.merchantIdentifier = AppConfig.appleMerchantId;
        await Stripe.instance.applySettings();
      }
      mode.value = await fetchStripeMode();
    } catch (e) {
      debugPrint(e.toString());
      if (!Get.isDialogOpen!) {
        buildNetworkErrorDialog();
      }
    }
  }

  Future<String> fetchStripeMode() async {
    try {
      return await _db
          .collection('env')
          .doc('stripe_mode')
          .get()
          .then((doc) => doc.data()!['mode'] ?? 'TEST');
    } catch (e) {
      debugPrint(e.toString());
      return 'TEST';
    }
  }

  Future<String?> fetchStripePubKey() async {
    try {
      String? mode = await _db
          .collection('env')
          .doc('stripe_mode')
          .get()
          .then((doc) => doc.data()!['mode']);
      if (mode != null) {
        String? res = await _db
            .collection('env')
            .doc('stripe_keys')
            .get()
            .then((doc) => doc.data()![mode]);
        return res;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
    return null;
  }

  Future<void> initPaymentController() async {
    try {
      final res = await fetchExistingCards();
      if (res != null) {
        existingCards.value = res;
      }
      final idRes = await fetchStripeCustomerId();
      if (idRes != null) {
        stripeCustomerId.value = idRes;
      } else {
        stripeCustomerId.value = '';
      }
    } catch (e) {
      debugPrint(e.toString());
      buildNetworkErrorDialog();
    }
  }

  Future<String?> fetchStripeCustomerId() async {
    try {
      return await _db
          .collection('app_users')
          .doc(_auth.currentUser!.uid)
          .collection('stripe_data')
          .doc('StripeCustomerId')
          .get()
          .then((doc) {
            if (doc.exists) {
              return doc.data()!['id'];
            } else {
              return null;
            }
          });
    } catch (e) {
      debugPrint('Stripe customer ID error: $e');
    }
    return null;
  }

  Future<List<UserCreditCard>?> fetchExistingCards() async {
    try {
      return await _db
          .collection('app_users')
          .doc(_auth.currentUser!.uid)
          .collection('payment_methods')
          .where('active', isEqualTo: true)
          .get()
          .then((snap) {
            if (snap.size > 0) {
              return snap.docs
                  .map((doc) => UserCreditCard.fromFirestore(doc.data()))
                  .toList();
            } else {
              return null;
            }
          });
    } catch (e) {
      debugPrint('fetch existing cards error $e');
    }
    return null;
  }

  Future<void> createStripeCustomerId() async {
    try {
      final mode = await fetchStripeMode();
      final httpCall = FirebaseFunctions.instance.httpsCallable(
        'createStripeCustomer',
      );
      final res = await httpCall.call({
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'mode': mode,
      });
      await _db
          .collection('app_users')
          .doc(_auth.currentUser!.uid)
          .collection('stripe_data')
          .doc('StripeCustomerId')
          .set({
            'id': res.data['id'],
            'createdAt': DateTime.now(),
          }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Create Stripe Customer error: $e');
    }
  }

  Future<void> saveNewCard(CardFieldInputDetails card) async {
    try {
      EasyLoading.show(status: tr('Saving'));
      if (stripeCustomerId.value.isEmpty) {
        await createStripeCustomerId();
      }
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );
      await _db
          .collection('app_users')
          .doc(_auth.currentUser!.uid)
          .collection('payment_methods')
          .doc(
            card.last4! +
                card.expiryYear!.toString() +
                card.expiryMonth!.toString(),
          )
          .set({
            'stripePaymentMethodId': paymentMethod.id,
            'last4': card.last4!,
            'expiryYear': card.expiryYear!,
            'expiryMonth': card.expiryMonth!,
            'cardBrand': card.brand,
            'addedAt': DateTime.now(),
            'active': true,
          }, SetOptions(merge: true));
      EasyLoading.dismiss();
      EasyLoading.showSuccess(tr('Save a new card!'));
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.dismiss();
      EasyLoading.showError(tr('An error has occurred'));
    }
  }

  Future<void> deleteCard(UserCreditCard card) async {
    try {
      DocumentReference ref = _db
          .collection('app_users')
          .doc(_auth.currentUser!.uid)
          .collection('payment_methods')
          .doc(
            card.last4! +
                card.expiryYear!.toString() +
                card.expiryMonth!.toString(),
          );
      await ref.update({'active': false});
      EasyLoading.showSuccess(tr('It has been deleted'));
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError(tr('An error has occurred'));
    }
  }

  //process payment --------------------------------------------------------------
  Future<MUser?> fetchAccountUserData() async {
    try {
      return await _db
          .collection('app_users')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((doc) => MUser.fromFirestore(doc.data()!));
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> processPayment(
    String amount,
    RestaurantAccount restaurant,
  ) async {
    if (selectedSavedCard != null) {
      await Get.defaultDialog(
        title: tr('Sending an order...'),
        content: Container(
          height: getScreenHeight() / 2.4,
          width: getScreenWidth() / 1.2,
          padding: const EdgeInsets.all(69),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: JPYText(price: int.parse(amount), fontSize: 18),
              ),
              TimeCircularCountdown(
                unit: CountdownUnit.second,
                countdownTotalColor: kPrimaryColor,
                countdownCurrentColor: kPrimaryColor,
                countdownRemainingColor: kPrimaryLightColor,
                countdownTotal: 3,
                strokeWidth: 12,
                gapFactor: 9,
                onUpdated: (unit, remainingTime) => debugPrint('confirming'),
                onFinished: () async {
                  Get.back();
                  await processCardPayment(amount, restaurant);
                },
              ),
            ],
          ),
        ),
        cancel: DefaultTextButton(
          label: tr('Cancel the order'),
          onPressed: () {
            Get.back();
          },
        ),
      );
    } else {
      EasyLoading.showError(tr('Please add a payment method'));
    }
  }

  Future<String> fetchUserEmail() async {
    return await _db
        .collection('app_users')
        .doc(_auth.currentUser!.uid)
        .collection('secrets')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((doc) => doc.data()!['email'] ?? '');
  }

  final _cartController = CartController.instance;

  Future<void> processApplePay(
    Map<String, dynamic> paymentResult,
    String amount,
    RestaurantAccount restaurant,
  ) async {
    try {
      EasyLoading.show(status: tr('Processing'));
      final email = await fetchUserEmail();
      final httpCall = FirebaseFunctions.instance.httpsCallable(
        'createStripePaymentIntent',
      );
      final res = await httpCall.call({
        'mode': mode.value,
        'amount': amount,
        'currency': 'jpy',
        'customerId': 'ApplePay',
        'description':
            '${restaurant.name!} ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now())}',
        'receipt_email': email,
      });
      final token = await Stripe.instance.createApplePayToken(paymentResult);
      final clientSecret = res.data['client_secret'];
      EasyLoading.dismiss();
      EasyLoading.showSuccess(tr('Payment completed'));
      await _cartController.sendCompletedOrder(
        restaurant: restaurant,
        stripeIntent: res.data['id'],
        clientSecret: clientSecret,
        tokenId: token.id,
        paymentMethod: 'Apple Pay',
        stripeMode: mode.value,
      );
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'Canceled':
          EasyLoading.dismiss();
          EasyLoading.showError(tr('Canceled'));
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(tr('Payment is an error (payment failure)'));
      debugPrint('Apple Pay Error: $e');
    }
  }

  Future<void> processCardPayment(
    String amount,
    RestaurantAccount restaurant,
  ) async {
    try {
      EasyLoading.show(status: tr('Processing'));
      final email = await fetchUserEmail();
      final intentCall = FirebaseFunctions.instance.httpsCallable(
        'createStripePaymentIntent',
      );
      final res = await intentCall.call({
        'mode': mode.value,
        'amount': amount,
        'currency': 'jpy',
        'customerId': stripeCustomerId.value,
        'description':
            '${restaurant.name!} ${DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now())}',
        'receipt_email': email,
      });
      final clientSecret = res.data['client_secret'];
      EasyLoading.dismiss();
      EasyLoading.showSuccess('決済完了');
      await _cartController.sendCompletedOrder(
        restaurant: restaurant,
        stripeIntent: res.data['id'],
        clientSecret: clientSecret,
        tokenId: selectedSavedCard!.value.stripePaymentMethodId!,
        paymentMethod:
            '${selectedSavedCard!.value.cardBrand} ****${selectedSavedCard!.value.last4}',
        stripeMode: mode.value,
      );
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(tr('Payment is an error (payment failure)'));
      debugPrint('カードError: $e');
    }
  }

  void resetPaymentController() {
    canApplePay.value = false;
    existingCards.clear();

    chosenPaymentMethod.value = 'ApplePay';
    selectedSavedCard = null;
    stripeCustomerId.value = '';
    mode.value = '';
  }
}
