import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

class OnboardController extends GetxController {
  static OnboardController instance = Get.find();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  PageController pageController = PageController(viewportFraction: 1);

  RxString profileImagePath = ''.obs;

  FormGroup onboardingForm = FormGroup({
    'email': FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    'displayName': FormControl<String>(
      validators: [
        Validators.required,
        Validators.minLength(6),
        Validators.maxLength(20),
      ],
    ),
    'firstName': FormControl<String>(validators: [Validators.required]),
    'lastName': FormControl<String>(validators: [Validators.required]),
    'bio': FormControl<String>(validators: [Validators.required]),
  });

  //upload profile-----------------------------------------------------------
  Future<Map<String, String>?> _uploadImage(String imageFilePath) async {
    File file = File(imageFilePath);
    String path;
    if (imageFilePath.startsWith('/data/user/')) {
      path =
          'app_users/${_auth.currentUser!.uid}/profile/${file.path.split('/cache/')[1]}';
    } else {
      path =
          'app_users/${_auth.currentUser!.uid}/profile/${file.path.split('/tmp/')[1]}';
    }
    try {
      await _storage.ref(path).putFile(file);
      String downloadURL = await _storage.ref(path).getDownloadURL();
      return {'ref': path, 'url': downloadURL};
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> updatedUserProfile() async {
    try {
      EasyLoading.show(status: tr('Saving'));
      // await FirebaseAuth.instance.currentUser!.updateEmail(onboardingForm.control('email').value);
      // await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      debugPrint(profileImagePath.value);
      Map<String, String>? imageRef = await _uploadImage(
        profileImagePath.value,
      );
      if (imageRef != null) {
        DocumentReference ref = _db
            .collection('app_users')
            .doc(_auth.currentUser!.uid);
        DocumentReference sRef = _db
            .collection('app_users')
            .doc(_auth.currentUser!.uid)
            .collection('secrets')
            .doc(_auth.currentUser!.uid);
        await ref.update({
          'displayName': onboardingForm.control('displayName').value,
          'firstName': onboardingForm.control('firstName').value,
          'lastName': onboardingForm.control('lastName').value,
          'bio': onboardingForm.control('bio').value,
          'profilePictureURL': imageRef,
          'onboarded': true,
        });
        await sRef.update({'email': onboardingForm.control('email').value});
      }
      EasyLoading.dismiss();
      await EasyLoading.showSuccess(tr('Welcome！'));
      Get.offAllNamed('/');
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.dismiss();
      EasyLoading.showError(tr('An error has occurred'));
    }
  }

  Future<bool> checkDuplicateUserName(String userName) async {
    try {
      return await _db
          .collection('app_users')
          .where('displayName', isEqualTo: userName)
          .get()
          .then((snap) => snap.size > 0);
    } catch (err) {
      debugPrint(err.toString());
      return false;
    }
  }
}
