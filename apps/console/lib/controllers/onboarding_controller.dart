import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mona_console/APIs/google_places_services.dart';
import 'package:mona_console/controllers/home_controller.dart';
import 'package:mona_console/screens/home_screen/home_screen.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_get_snackbar.dart';
import 'package:reactive_forms/reactive_forms.dart';

class OnboardingController extends GetxController {
  static OnboardingController instance = Get.find();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  final _currentPage = 0.obs;

  int get currentPage => _currentPage.value;

  void setCurrentPage(int page) {
    _currentPage.value = page;
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  //basic info page
  final _searchResult = const PlaceSearchResult(placeId: '').obs;
  PlaceSearchResult get searchResult => _searchResult.value;
  Rx<PlaceDetails?>? detailResult;
  RxBool basicInfoPageCompleted = false.obs;

  FormGroup onboardingForm = FormGroup({
    'name': FormControl<String>(validators: [Validators.required]),
    'address': FormControl<String>(validators: [Validators.required]),
    'lat': FormControl<double>(validators: [Validators.required]),
    'lng': FormControl<double>(validators: [Validators.required]),
    'phoneNumber': FormControl<String>(validators: [Validators.required]),
    'genre': FormControl<String>(validators: [Validators.required]),
  });

  void importSearchResult() {
    if (detailResult != null) {
      onboardingForm.value = {
        'name': searchResult.name,
        'address': searchResult.formattedAddress,
        'phoneNumber': detailResult!.value!.formattedPhoneNumber,
        'lat': detailResult!.value!.lat,
        'lng': detailResult!.value!.lng,
      };
      Get.back();
    } else {
      buildGetSnackbar('Empty - インポートが失敗しました', 'もう一度お試しください');
    }
  }

  Future<void> setSearchResult(PlaceSearchResult searchResult) async {
    _searchResult.value = searchResult;
    detailResult = Rx<PlaceDetails?>(
      await PlacesAutoCompleteService().getPlaceDetails(searchResult.placeId),
    );
  }

  //upload onboarding data
  final _homeController = HomeController.instance;
  Future<void> completeOnboardingProcess() async {
    try {
      EasyLoading.show(status: '保存してます..');
      await uploadRestaurantBasicData();
      await uploadPictures();
      await _homeController.initOnboarding();
      EasyLoading.dismiss();
      Get.offAll(() => const HomeScreen(), transition: Transition.downToUp);
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
  }

  Future<void> uploadRestaurantBasicData() async {
    try {
      DocumentReference ref = _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid);
      ref.set({
        'name': onboardingForm.control('name').value,
        'email': _auth.currentUser!.email,
        'address': onboardingForm.control('address').value,
        '_geoloc': {
          'lat': onboardingForm.control('lat').value,
          'lng': onboardingForm.control('lng').value,
        },
        'genre': onboardingForm.control('genre').value,
        'phoneNumber': onboardingForm.control('phoneNumber').value,
        'seatAvailableNow': true,
        'onboardingCompleted': true,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
      buildGetSnackbar('エラーが発生しました、もう一度お試しください', 'Error');
      return;
    }
  }

  //profile picture page
  final profilePicturePath = ''.obs;
  final bgPicturePath = ''.obs;
  Future<Map<String, String>?> uploadImage(String filePath) async {
    File file = File(filePath);
    String path =
        'restaurant_accounts/${_auth.currentUser!.uid}/${file.path.split('/tmp/')[1]}';
    try {
      await _storage.ref(path).putFile(file);
      String downloadURL = await _storage.ref(path).getDownloadURL();
      return {'ref': path, 'url': downloadURL};
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      buildGetSnackbar('保存に失敗しました', 'Error - Failed to save');
      return null;
    }
  }

  Future<void> uploadPictures() async {
    try {
      Map<String, String>? imageRef = await uploadImage(
        profilePicturePath.value,
      );
      Map<String, String>? bgImageRef = await uploadImage(bgPicturePath.value);
      if (imageRef != null && bgImageRef != null) {
        DocumentReference ref = _db
            .collection('restaurant_accounts')
            .doc(_auth.currentUser!.uid);
        await ref.set({
          'profileImageRef': imageRef,
          'bgImageRef': bgImageRef,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint(e.toString());
      buildGetSnackbar('エラーが発生しました、もう一度お試しください', 'Error');
    }
  }
}
