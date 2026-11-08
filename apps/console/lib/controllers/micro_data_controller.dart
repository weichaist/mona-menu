import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mona_console/models/m_user_model.dart';
import 'package:mona_console/models/menu_item_in_order_model.dart';
import 'package:mona_console/models/restaurant_menu_item_model.dart';

class MicroDataController extends GetxController {
  static MicroDataController instance = Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final mUser = MUser(
    displayName: '',
    lastName: '',
    firstName: '',
    profilePictureURL: '',
    bio: '',
  ).obs;

  final menuItem = RestaurantMenuItem(
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  ).obs;

  Future<MUser?> fetchAccountUserData(String userUid) async {
    try {
      return await _db
          .collection('app_users')
          .doc(userUid)
          .get()
          .then((doc) => MUser.fromFirestore(doc.data()!));
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

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

  //badges -----------------------------------------------------------------------------
  Future<List<String>> fetchUserBadges(String uid) async {
    List<String> badges = [];
    try {
      var repeater = await fetchCurrentUserRepeaterStatus(
        _auth.currentUser!.uid,
        uid,
      );
      if (repeater) {
        badges.add('リピーター');
      }
      return badges;
    } catch (err) {
      debugPrint(err.toString());
      return badges;
    }
  }

  Future<bool> fetchCurrentUserRepeaterStatus(
    String restaurantUid,
    String uid,
  ) async {
    try {
      return await _db
          .collection('restaurant_accounts')
          .doc(restaurantUid)
          .collection('repeaters')
          .doc(uid)
          .get()
          .then((doc) {
            if (doc.exists) {
              return doc.data()!['status'] == 'approved';
            } else {
              return false;
            }
          });
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  //menu item in order -------------------------------------------------------------

  Future<List<MenuItemInOrder>?> fetchMenuItemsInOrder(String orderId) async {
    try {
      return await _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .collection('customer_orders')
          .doc(orderId)
          .collection('menuItems')
          .get()
          .then(
            (snap) => snap.docs
                .map((doc) => MenuItemInOrder.fromFirestore(doc.data()))
                .toList(),
          );
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
