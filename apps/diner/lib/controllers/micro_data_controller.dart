import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mona_diner/models/menu_item_in_order_model.dart';
import 'package:mona_diner/models/mona_user_model.dart';
import 'package:mona_diner/models/restaurant_account_model.dart';
import 'package:mona_diner/models/restaurant_menu_item_model.dart';

class MicroDataController extends GetxController {
  static MicroDataController instance = Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Rx<MUser> mUser = MUser(displayName: '', profilePictureURL: '', bio: '').obs;

  Rx<RestaurantMenuItem> menuItem = RestaurantMenuItem(
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  ).obs;

  Rx<RestaurantAccount> restaurantAcc = RestaurantAccount(
    name: '',
    profileImageUrl: '',
    address: '',
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

  Future<RestaurantAccount?> fetchRestaurantAccountData(
    String restaurantUid,
  ) async {
    try {
      return await _db
          .collection('restaurant_accounts')
          .doc(restaurantUid)
          .get()
          .then((doc) => RestaurantAccount.fromFirestore(doc.data()!));
    } catch (err) {
      debugPrint(err.toString());
      return null;
    }
  }

  //badges -----------------------------------------------------------------------------
  Future<List<String>> fetchUserBadges(String restaurantUid, String uid) async {
    List<String> badges = [];
    try {
      var inRelation = await fetchFollowRelation(uid);
      var repeater = await fetchCurrentUserRepeaterStatus(restaurantUid, uid);
      if (inRelation) {
        badges.add(tr('Following'));
      }
      if (repeater) {
        badges.add(tr('Repeater'));
      }
      return badges;
    } catch (err) {
      debugPrint(err.toString());
      return badges;
    }
  }

  Future<bool> fetchFollowRelation(String uid) async {
    try {
      return await _db
          .collection('app_users')
          .doc(_auth.currentUser!.uid)
          .collection('user_following')
          .doc(uid)
          .get()
          .then((doc) {
            if (doc.exists) {
              return doc.data()!['status'] == 'following';
            } else {
              return false;
            }
          });
    } catch (e) {
      debugPrint(e.toString());
      return false;
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

  Future<List<MenuItemInOrder>?> fetchMenuItemsInOrder(
    String restaurantUid,
    String orderId,
  ) async {
    try {
      return await _db
          .collection('restaurant_accounts')
          .doc(restaurantUid)
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

  Future<void> updateUserFollowingCounter(
    String uid,
    String targetUid,
    bool follow,
  ) async {
    try {
      if (follow) {
        final ref = _db
            .collection('app_users')
            .doc(uid)
            .collection('counters')
            .doc('user_following');
        final targetRef = _db
            .collection('app_users')
            .doc(targetUid)
            .collection('counters')
            .doc('user_followed_by');
        await ref.set({
          'list': FieldValue.arrayUnion([targetUid]),
        }, SetOptions(merge: true));
        await targetRef.set({
          'list': FieldValue.arrayUnion([uid]),
        }, SetOptions(merge: true));
      } else {
        final ref = _db
            .collection('app_users')
            .doc(uid)
            .collection('counters')
            .doc('user_following');
        final targetRef = _db
            .collection('app_users')
            .doc(targetUid)
            .collection('counters')
            .doc('user_followed_by');
        await ref.set({
          'list': FieldValue.arrayRemove([targetUid]),
        }, SetOptions(merge: true));
        await targetRef.set({
          'list': FieldValue.arrayRemove([uid]),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> sendContentReport(Map<String, String> report) async {
    try {
      EasyLoading.show(status: tr('Sending'));
      await _db.collection('abuse_reports').add(report);
      EasyLoading.showSuccess(tr('Sent'));
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError(tr('An error has occurred'));
    }
  }
}
