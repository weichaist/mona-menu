import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mona_console/models/restaurant_menu_item_model.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_get_snackbar.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class RestaurantMenuController extends GetxController {
  static RestaurantMenuController instance = Get.find();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // save settings & categories ---------------------------------------------------------------------
  Future<void> saveMenuSettings() async {
    try {
      EasyLoading.show(status: '保存中...');
      await _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .update({
            'oneSetMenu': oneSetMenu.value,
            'serviceCharge': serviceCharge.value.toInt(),
            'lunchMenuAvailable': lunchMenuAvailable.value,
            'dinnerMenuAvailable': dinnerMenuAvailable.value,
            'lunchMenuCategoryList': lunchMenuCategoryList,
            'dinnerMenuCategoryList': dinnerMenuCategoryList,
          });
      EasyLoading.dismiss();
      EasyLoading.showSuccess('メニュー情報が更新しました');
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.dismiss();
      EasyLoading.showError('エラーが発生しました');
    }
  }

  Future<void> saveCategories() async {
    try {
      await _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .update({
            'lunchMenuCategoryList': lunchMenuCategoryList,
            'dinnerMenuCategoryList': dinnerMenuCategoryList,
          });
      EasyLoading.showSuccess('カテゴリが更新しました');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // save dish ---------------------------------------------------------------------
  Future<Map<String, String>?> _uploadImage(String filePath) async {
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

  Future<void> saveMenuPicture(String docId, String filePath) async {
    try {
      Map<String, String>? imageRef = await _uploadImage(filePath);
      if (imageRef != null) {
        DocumentReference ref = _db
            .collection('restaurant_accounts')
            .doc(_auth.currentUser!.uid)
            .collection('menu')
            .doc(docId);
        await ref.update({'imageRef': imageRef});
      }
    } catch (e) {
      debugPrint(e.toString());
      buildGetSnackbar('エラーが発生しました、もう一度お試しください', 'Error');
    }
  }

  Future<void> saveMenuItem(String docId, Map<String, dynamic> dishData) async {
    final ref = _db
        .collection('restaurant_accounts')
        .doc(_auth.currentUser!.uid)
        .collection('menu')
        .doc(docId);
    try {
      return await ref.set(dishData, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> saveNewMenuItem(Map<String, dynamic> dishData) async {
    final ref = _db
        .collection('restaurant_accounts')
        .doc(_auth.currentUser!.uid)
        .collection('menu')
        .doc();
    dishData['docId'] = ref.id;
    dishData['soldOut'] = false;
    dishData['active'] = true;
    dishData['createdAt'] = DateTime.now();
    try {
      await saveMenuItem(ref.id, dishData);
      await saveMenuPicture(ref.id, dishData['imageUrl']);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateMenuItem(
    String docId,
    Map<String, dynamic> dishData,
  ) async {
    final ref = _db
        .collection('restaurant_accounts')
        .doc(_auth.currentUser!.uid)
        .collection('menu')
        .doc(docId);
    dishData['editedAt'] = DateTime.now();
    try {
      await saveMenuItem(ref.id, dishData);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //init set lunch settings and category ---------------------------------------------------------------------
  Future<void> initFetchSettings() async {
    try {
      await _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((doc) {
            oneSetMenu.value = doc.data()!['oneSetMenu'] ?? false;
            serviceCharge.value = doc.data()!['serviceCharge'] != null
                ? double.parse(doc.data()!['serviceCharge'].toString())
                : 0.0;
            lunchMenuAvailable.value =
                doc.data()!['lunchMenuAvailable'] ?? false;
            dinnerMenuAvailable.value =
                doc.data()!['dinnerMenuAvailable'] ?? false;
            lunchMenuCategoryList.value =
                doc.data()!['lunchMenuCategoryList'] != null
                ? List.from(doc.data()!['lunchMenuCategoryList'])
                : [];
            dinnerMenuCategoryList.value =
                doc.data()!['dinnerMenuCategoryList'] != null
                ? List.from(doc.data()!['dinnerMenuCategoryList'])
                : [];
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<RestaurantMenuItem>?> _fetchMenuItems() async {
    try {
      return await _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .collection('menu')
          .where('active', isEqualTo: true)
          .orderBy('ranking')
          .get()
          .then(
            (snap) => snap.docs
                .map((doc) => RestaurantMenuItem.fromFirestore(doc.data()))
                .toList(),
          );
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> initDishList() async {
    final res = await _fetchMenuItems();
    if (res != null) {
      lunchDishList.value = res
          .where((dish) => dish.menuGroup == 'lunch')
          .toList();
      dinnerDishList.value = res
          .where((dish) => dish.menuGroup == 'dinner')
          .toList();
    }
  }

  // general setting ---------------------------------------------------------------------
  final oneSetMenu = false.obs;
  final serviceCharge = 0.0.obs;

  //lunch menu ---------------------------------------------------------------------
  final lunchMenuAvailable = false.obs;
  final lunchMenuCategoryList = <String>[].obs;
  final lunchCategoryPositionIndex = 0.obs;

  final lunchDishList = <RestaurantMenuItem>[].obs;

  final ItemScrollController lunchItemScrollController = ItemScrollController();
  final ItemPositionsListener lunchItemPositionsListener =
      ItemPositionsListener.create();

  //dinner menu ---------------------------------------------------------------------
  final dinnerMenuAvailable = false.obs;
  final dinnerMenuCategoryList = <String>[].obs;
  final dinnerCategoryPositionIndex = 0.obs;

  final dinnerDishList = <RestaurantMenuItem>[].obs;

  final ItemScrollController dinnerItemScrollController =
      ItemScrollController();
  final ItemPositionsListener dinnerItemPositionsListener =
      ItemPositionsListener.create();

  //new dish ---------------------------------------------------------------------
  FormGroup newDishForm = FormGroup({
    'title': FormControl<String>(validators: [Validators.required]),
    'description': FormControl<String>(validators: [Validators.required]),
    'price': FormControl<String>(validators: [Validators.required]),
    'ranking': FormControl<int>(validators: [Validators.required]),
  });
  final newDishImageUrl = ''.obs;
  final newDishCategories = <String>[].obs;

  bool newDishValid() {
    if (newDishForm.valid &&
        newDishImageUrl.value.isNotEmpty &&
        newDishCategories.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void resetNewDishData() {
    newDishForm.unfocus();
    newDishForm.markAsUntouched();
    newDishForm.reset();
    newDishImageUrl.value = '';
    newDishCategories.clear();
  }

  //update dish setting ---------------------------------------------------------------------
  Future<void> updateSoldOutStatus(String dishId, bool status) async {
    try {
      EasyLoading.show(status: '更新中...');
      final ref = _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .collection('menu')
          .doc(dishId);
      await ref.update({'soldOut': status});
      EasyLoading.dismiss();
      EasyLoading.showSuccess('メニュー情報が更新しました');
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.dismiss();
      EasyLoading.showError('エラーが発生しました');
    }
  }

  Future<void> updateCategory(String dishId, List<String> categories) async {
    try {
      final ref = _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .collection('menu')
          .doc(dishId);
      await ref.update({'categories': categories});
      await saveCategories();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteDish(String dishId) async {
    try {
      EasyLoading.show(status: '更新中...');
      final ref = _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .collection('menu')
          .doc(dishId);
      await ref.update({'active': false});
      EasyLoading.dismiss();
      EasyLoading.showSuccess('料理を削除しました');
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.dismiss();
      EasyLoading.showError('エラーが発生しました');
    }
  }

  //edit dish
  Future<void> editMenuItem(String docId, Map<String, dynamic> dataMap) async {
    try {
      EasyLoading.show(status: '保存中..');
      final String imageUrl = dataMap['imageUrl'];
      if (!imageUrl.startsWith('https://')) {
        await saveMenuPicture(docId, imageUrl);
      }
      await updateMenuItem(docId, dataMap);
      await initDishList();
      EasyLoading.dismiss();
      EasyLoading.showSuccess('メニュー情報が更新しました');
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.dismiss();
      EasyLoading.showError('エラーが発生しました');
    }
    resetNewDishData();
  }

  //reset variables-----------------------------------------------------------------
  void resetMenuController() {
    oneSetMenu.value = false;
    serviceCharge.value = 0.0;

    lunchMenuAvailable.value = false;
    lunchMenuCategoryList.value = <String>[];
    lunchCategoryPositionIndex.value = 0;

    lunchDishList.value = <RestaurantMenuItem>[];

    //dinner menu ---------------------------------------------------------------------
    dinnerMenuAvailable.value = false;
    dinnerMenuCategoryList.value = <String>[];
    dinnerCategoryPositionIndex.value = 0;
    dinnerDishList.value = <RestaurantMenuItem>[];

    //new dish ---------------------------------------------------------------------
    newDishForm.reset();
    newDishImageUrl.value = '';
    newDishCategories.value = <String>[];
  }
}
