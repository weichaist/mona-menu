import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mona_diner/models/restaurant_account_model.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_network_error_dialog.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_version_check_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  //variables ------------------------------------------------------------------------

  RxBool hideBottomNavigationBar = false.obs;

  RxInt initIndex = 0.obs;

  final restaurants = <RestaurantAccount>[].obs;

  final followingUserUid = <String>[].obs;

  //init home controller -----------------------------------------------------------------------------

  Future<void> initHomeController() async {
    await initAppVersionCheck();
    await initFetchAvailableRestaurant();
  }

  Future<void> initAppVersionCheck() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String? latestVersion = await _db
          .collection('env')
          .doc('app_version')
          .get()
          .then((doc) => doc.data()!['version']);
      String? link = await _db
          .collection('env')
          .doc('app_version')
          .get()
          .then((doc) => doc.data()!['link']);
      if (version != latestVersion) {
        if (Get.isDialogOpen ?? false) {
          debugPrint('Update is ready');
        } else {
          if (link != null) {
            buildVersionCheckDialog(link);
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      buildNetworkErrorDialog();
    }
  }

  //fetch available restaurants -----------------------------------------------------------------------------

  Future<void> initFetchAvailableRestaurant() async {
    List<RestaurantAccount>? res = await fetchAvailableRestaurants();
    if (res != null) {
      restaurants.value = res;
    }
  }

  Future<List<RestaurantAccount>?> fetchAvailableRestaurants() async {
    try {
      return await _db
          .collection('restaurant_accounts')
          .where('public', isEqualTo: true)
          .get()
          .then(
            (snap) => snap.docs
                .map((doc) => RestaurantAccount.fromFirestore(doc.data()))
                .toList(),
          );
    } catch (err) {
      debugPrint(err.toString());
      buildNetworkErrorDialog();
      return null;
    }
  }

  //fetch following list ----------------------------------------------------------------------------

  Future<void> initFetchFollowingUserUIDs() async {
    List<String>? res = await fetchFollowingUserUIDs();
    if (res != null) {
      followingUserUid.value = res;
    } else {
      followingUserUid.clear();
    }
  }

  Future<List<String>?> fetchFollowingUserUIDs() async {
    try {
      return await _db
          .collection('mona_menu_follow_relationship')
          .where('followedByUserUid', isEqualTo: _auth.currentUser!.uid)
          .orderBy('relationScore', descending: true)
          .get()
          .then((snap) {
            if (snap.docs.isNotEmpty) {
              return snap.docs
                  .map((doc) => doc.data()['followingUserUid'] as String)
                  .toList();
            } else {
              return null;
            }
          });
    } catch (err) {
      debugPrint(err.toString());
      return null;
    }
  }

  bool checkBusinessHour(RestaurantAccount restaurant) {
    final now = DateTime.now();
    final businessHour = restaurant.businessHours![now.weekday - 1];
    return businessHour.isOpenNow();
  }
}
