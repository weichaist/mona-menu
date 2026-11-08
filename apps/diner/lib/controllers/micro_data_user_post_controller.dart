import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mona_diner/models/mona_menu_post_model.dart';
import 'package:mona_diner/models/restaurant_menu_item_model.dart';

class MicroDataUserPostController extends GetxController {
  static MicroDataUserPostController instance = Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Rx<RestaurantMenuItem> menuItem = RestaurantMenuItem(
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  ).obs;

  RxBool menuItemPosted = false.obs;

  Rx<MonaMenuPost> monaMenu = MonaMenuPost().obs;

  Future<RestaurantMenuItem?> fetchRestaurantMenuItemData(
    String restaurantUid,
    String menuItemId,
  ) async {
    try {
      return await _db
          .collection('restaurant_accounts')
          .doc(restaurantUid)
          .collection('menu')
          .doc(menuItemId)
          .get()
          .then((doc) => RestaurantMenuItem.fromFirestore(doc.data()!));
    } catch (err) {
      debugPrint(err.toString());
      return null;
    }
  }

  Future<MonaMenuPost?> fetchMonaMenu(String menuItemId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snap = await _db
          .collection('creator_mona_menu')
          .where('menuItemId', isEqualTo: menuItemId)
          .where('postedBy', isEqualTo: _auth.currentUser!.uid)
          .get();
      if (snap.size > 0) {
        QueryDocumentSnapshot<Map<String, dynamic>> doc = snap.docs[0];
        return MonaMenuPost.fromFirestore(doc.data());
      }
    } catch (err) {
      debugPrint(err.toString());
      return null;
    }
    return null;
  }

  Future<bool> fetchMonaMenuExits(String menuItemId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snap = await _db
          .collection('creator_mona_menu')
          .where('menuItemId', isEqualTo: menuItemId)
          .where('postedBy', isEqualTo: _auth.currentUser!.uid)
          .get();
      if (snap.size > 0) {
        // QueryDocumentSnapshot<Map<String,dynamic>> doc = snap.docs[0];
        return true;
      } else {
        return false;
      }
    } catch (err) {
      debugPrint(err.toString());
      return false;
    }
  }
}
