import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mona_console/controllers/home_controller.dart';
import 'package:mona_console/models/acc_basic_info_model.dart';
import 'package:mona_console/models/business_hour_model.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_get_snackbar.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SettingController extends GetxController {
  static SettingController instance = Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;

  //variables --------------------------------------------------------------------

  TextEditingController introController = TextEditingController();
  final profilePictureUrl = ''.obs;
  final bgPictureUrl = ''.obs;

  final seatAvailableNow = true.obs;

  final tableNumbers = <String>[].obs;

  final restaurantAccInfo = AccBasicInfo(name: '', profileImageUrl: '').obs;

  List<Rx<BusinessHour>> businessHourList = List.generate(
    7,
    (index) => BusinessHour(weekday: index + 1).obs,
  );

  FormGroup basicInfoForm = FormGroup({
    'name': FormControl<String>(validators: [Validators.required]),
    'address': FormControl<String>(validators: [Validators.required]),
    'lat': FormControl<double>(validators: [Validators.required]),
    'lng': FormControl<double>(validators: [Validators.required]),
    'phoneNumber': FormControl<String>(validators: [Validators.required]),
    'genre': FormControl<String>(validators: [Validators.required]),
  });

  //init settings------------------------------------------------------------------

  Future<void> initSettingData() async {
    await initBusinessHour();
    await initAccBasicInfo();
    await initSeatAvailableStatusAndTableNumbers();
  }

  Future<void> initBusinessHour() async {
    final businessHoursRes = await fetchBusinessHours();
    if (businessHoursRes != null) {
      businessHourList = businessHoursRes;
    }
  }

  Future<void> initAccBasicInfo() async {
    final basicDataRes = await fetchRestaurantBasicInfoData();
    if (basicDataRes != null) {
      restaurantAccInfo.value = basicDataRes;
      basicInfoForm.value = {
        'name': basicDataRes.name,
        'address': basicDataRes.address,
        'phoneNumber': basicDataRes.phoneNumber,
        'genre': basicDataRes.genre,
        'lat': basicDataRes.lat,
        'lng': basicDataRes.lng,
      };
      profilePictureUrl.value = basicDataRes.profileImageUrl!;
      bgPictureUrl.value = basicDataRes.bgImageUrl!;
      if (restaurantAccInfo.value.about != null) {
        introController.text = restaurantAccInfo.value.about!;
      }
    }
  }

  Future<List<Rx<BusinessHour>>?> fetchBusinessHours() async {
    try {
      return await _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((doc) {
            if (doc.data()!['businessHours'] != null) {
              return List.from(
                doc.data()!['businessHours'],
              ).map((e) => BusinessHour.fromFirestore(e).obs).toList();
            } else {
              return null;
            }
          });
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<AccBasicInfo?> fetchRestaurantBasicInfoData() async {
    try {
      return await _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((doc) {
            if (doc.exists) {
              return AccBasicInfo.fromFirestore(doc.data()!);
            } else {
              return null;
            }
          });
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  //handle restaurant introduction--------------------------------------------------

  bool readyToUpload() {
    if (introController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> uploadIntro() async {
    try {
      EasyLoading.show(status: '保存中..');
      await _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .update({'about': introController.text});
      EasyLoading.dismiss();
      EasyLoading.showSuccess('保存しました！');
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('エラーが発生しました.');
      debugPrint(e.toString());
    }
  }

  //handle business hour settings---------------------------------------------------

  void setIsBusinessDay(int index, bool val) {
    businessHourList[index].value.isBusinessDay = val;
    businessHourList[index].refresh();
  }

  void setLunchOpen(int index, bool val) {
    businessHourList[index].value.lunchOpen = val;
    businessHourList[index].refresh();
  }

  void setDinnerOpen(int index, bool val) {
    businessHourList[index].value.dinnerOpen = val;
    businessHourList[index].refresh();
  }

  void resetBusinessHour(int index) {
    businessHourList[index].value.reset();
    businessHourList[index].refresh();
  }

  void setLunchOpenTime(int index, TimeOfDay timeOfDay) {
    businessHourList[index].value.lunchStartHour = timeOfDay.hour;
    businessHourList[index].value.lunchStartMinute = timeOfDay.minute;
    businessHourList[index].refresh();
  }

  void setLunchFinishTime(int index, TimeOfDay timeOfDay) {
    businessHourList[index].value.lunchFinishHour = timeOfDay.hour;
    businessHourList[index].value.lunchFinishMinute = timeOfDay.minute;
    businessHourList[index].refresh();
  }

  void setDinnerOpenTime(int index, TimeOfDay timeOfDay) {
    businessHourList[index].value.dinnerStartHour = timeOfDay.hour;
    businessHourList[index].value.dinnerStartMinute = timeOfDay.minute;
    businessHourList[index].refresh();
  }

  void setDinnerFinishTime(int index, TimeOfDay timeOfDay) {
    businessHourList[index].value.dinnerFinishHour = timeOfDay.hour;
    businessHourList[index].value.dinnerFinishMinute = timeOfDay.minute;
    businessHourList[index].refresh();
  }

  Future<void> uploadBusinessHourList() async {
    final listOfMap = businessHourList.map((e) => e.value.toMap()).toList();
    try {
      EasyLoading.show(status: '保存中..');
      await _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .update({'businessHours': listOfMap});
      EasyLoading.dismiss();
      EasyLoading.showSuccess('保存しました！');
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('エラーが発生しました.');
      debugPrint(e.toString());
    }
  }

  //handle picture upload ---------------------------------------------------------
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

  Future<void> uploadPicture(String path, String fieldRef) async {
    try {
      Map<String, String>? data = await uploadImage(path);
      DocumentReference ref = _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid);
      await ref.update({fieldRef: data});
    } catch (e) {
      debugPrint(e.toString());
      buildGetSnackbar('エラーが発生しました、もう一度お試しください', 'Error');
    }
  }

  Future<void> uploadRestaurantBasicData() async {
    try {
      DocumentReference ref = _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid);
      ref.update({
        'name': basicInfoForm.control('name').value,
        'address': basicInfoForm.control('address').value,
        'genre': basicInfoForm.control('genre').value,
        'phoneNumber': basicInfoForm.control('phoneNumber').value,
      });
    } catch (e) {
      debugPrint(e.toString());
      buildGetSnackbar('エラーが発生しました、もう一度お試しください', 'Error');
      return;
    }
  }

  //save basic info screen ---------------------------------------------------------
  final _homeController = HomeController.instance;
  Future<void> saveEditBasicInfoScreen() async {
    EasyLoading.show(status: '保存中..');
    try {
      if (!profilePictureUrl.value.startsWith('https://')) {
        await uploadPicture(profilePictureUrl.value, 'profileImageRef');
      }
      if (!bgPictureUrl.value.startsWith('https://')) {
        await uploadPicture(bgPictureUrl.value, 'bgImageRef');
      }
      await uploadRestaurantBasicData();
      await initAccBasicInfo();
      _homeController.restaurantAccInfo.value = restaurantAccInfo.value;
      EasyLoading.dismiss();
      EasyLoading.showSuccess('保存しました！');
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.dismiss();
      EasyLoading.showError('エラーが発生しました.');
    }
  }

  //handle table numbers ----------------------------------------------------------
  Future<void> saveTableNumbers() async {
    try {
      EasyLoading.show(status: '保存中..');
      await _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .update({'tableNumbers': tableNumbers});
      EasyLoading.dismiss();
      EasyLoading.showSuccess('保存しました！');
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('エラーが発生しました.');
      debugPrint(e.toString());
    }
  }

  //handle seats available now --------------------------------------------------------------
  Future<void> saveOpenNowSettings() async {
    try {
      EasyLoading.show(status: '更新中...');
      await _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .update({'seatAvailableNow': seatAvailableNow.value});
      EasyLoading.dismiss();
      EasyLoading.showSuccess('営業状態が更新しました');
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.dismiss();
      EasyLoading.showError('エラーが発生しました');
    }
  }

  Future<void> initSeatAvailableStatusAndTableNumbers() async {
    try {
      await _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((doc) {
            seatAvailableNow.value = doc.data()!['seatAvailableNow'] ?? true;
            tableNumbers.value = doc.data()!['tableNumbers'] != null
                ? List.from(doc.data()!['tableNumbers'])
                : [];
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //reset variables
  void resetSettingVariables() {
    profilePictureUrl.value = '';
    bgPictureUrl.value = '';
    seatAvailableNow.value = true;
    tableNumbers.value = <String>[];
    restaurantAccInfo.value = AccBasicInfo(name: '', profileImageUrl: '');
    businessHourList = List.generate(
      7,
      (index) => BusinessHour(weekday: index + 1).obs,
    );
    basicInfoForm.reset();
    introController.clear();
  }
}
