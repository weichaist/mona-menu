import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_get_snackbar.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  RxString userEmail = ''.obs;
  RxString userPW = ''.obs;

  RxString userPhoneNumber = ''.obs;
  RxString smsCode = ''.obs;

  String phoneAuthVerificationId = '';
  int? authResendToken;

  Future<void> sendPhoneVerificationCode() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: userPhoneNumber.value,
      verificationCompleted: (PhoneAuthCredential credential) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
      verificationFailed: (FirebaseAuthException e) {
        buildGetSnackbar(tr('An error has occurred'), e.message.toString());
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        EasyLoading.showSuccess(tr('I sent the code'));
        phoneAuthVerificationId = verificationId;
        authResendToken = resendToken;
        // Create a PhoneAuthCredential with the code
      },
    );
  }

  Future<void> phoneSignIn() async {
    if (smsCode.isNotEmpty && phoneAuthVerificationId.isNotEmpty) {
      try {
        EasyLoading.show(status: tr('During login'));
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: phoneAuthVerificationId,
          smsCode: smsCode.value,
        );
        final UserCredential userCredential;
        try {
          userCredential = await _auth.signInWithCredential(
            phoneAuthCredential,
          );
        } catch (err) {
          buildGetSnackbar(err.toString(), '${tr('An error has occurred')}..');
          rethrow;
        }
        if (userCredential.user != null) {
          await _setUserProfile(
            userCredential.user!.uid,
            userPhoneNumber.value,
          );
          Get.offAllNamed('/');
          EasyLoading.dismiss();
        }
      } catch (e) {
        debugPrint('phone sign in error: $e');
        EasyLoading.dismiss();
        EasyLoading.showError(tr('An error has occurred'));
        Get.offAllNamed('/auth');
      }
    } else {
      buildGetSnackbar(
        tr(
          'Please check the phone number and the code sent to your mobile phone again.',
        ),
        '${tr('An error has occurred')}..',
      );
    }
  }

  Future _setUserProfile(String uid, String phoneNumber) async {
    DocumentReference sRef = _db
        .collection('app_users')
        .doc(uid)
        .collection('secrets')
        .doc(uid);
    DocumentReference ref = _db.collection('app_users').doc(uid);
    try {
      final existingUser = await ref.get().then((doc) => doc.exists);
      if (existingUser) {
        await ref.update({'signedInAt': DateTime.now()});
      } else {
        await ref.set({
          'uid': uid,
          'createdAt': DateTime.now(),
          'onboarded': false,
        }, SetOptions(merge: true));
        await sRef.set({
          'phoneNumber': phoneNumber,
          'uid': uid,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError(tr('An error has occurred'));
    }
  }
}
