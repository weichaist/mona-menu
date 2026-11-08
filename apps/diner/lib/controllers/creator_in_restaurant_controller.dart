import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mona_diner/controllers/micro_data_controller.dart';
import 'package:mona_diner/models/mona_menu_post_model.dart';

class CreatorInRestaurantController extends GetxController {
  static CreatorInRestaurantController instance = Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final isFollowing = false.obs;

  final allPostByCreator = <MonaMenuPost>[].obs;

  final userFollowingCount = 0.obs;
  final userFollowedByCount = 0.obs;

  //init controller
  Future<void> initController(String restaurantUid, String mUserUid) async {
    clearController();
    isFollowing.value = await fetchFollowRelation(mUserUid);
    await initFollowingCount(mUserUid);
    await initFetchPostsFromCreator(restaurantUid, mUserUid);
  }

  Future<bool> fetchFollowRelation(String mUserUid) async {
    try {
      return await _db
          .collection('app_users')
          .doc(_auth.currentUser!.uid)
          .collection('user_following')
          .doc(mUserUid)
          .get()
          .then((doc) {
            if (doc.exists) {
              if (doc.data()!['status'] == 'following') {
                return true;
              } else {
                return false;
              }
            } else {
              return false;
            }
          });
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> initFetchPostsFromCreator(
    String restaurantUid,
    String mUserUid,
  ) async {
    var res = await fetchPostsFromCreator(restaurantUid, mUserUid);
    if (res != null) {
      allPostByCreator.value = res;
    } else {
      allPostByCreator.value = [];
    }
  }

  Future<List<MonaMenuPost>?> fetchPostsFromCreator(
    String restaurantUid,
    String mUserUid,
  ) async {
    try {
      return await _db
          .collection('posts')
          .where('restaurantUid', isEqualTo: restaurantUid)
          .where('postedBy', isEqualTo: mUserUid)
          .where('active', isEqualTo: true)
          .orderBy('postedAt', descending: true)
          .get()
          .then(
            (snap) => snap.docs
                .map((doc) => MonaMenuPost.fromFirestore(doc.data()))
                .toList(),
          );
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  final _microDataController = MicroDataController.instance;
  Future<void> updateFollowRelationship(String mUserUid, bool follow) async {
    String status;
    if (follow) {
      status = 'following';
    } else {
      status = 'unfollowed';
    }
    try {
      final targetRef = _db
          .collection('app_users')
          .doc(mUserUid)
          .collection('user_followed_by')
          .doc(_auth.currentUser!.uid);
      await targetRef.set({
        'uid': _auth.currentUser!.uid,
        'timeStamp': DateTime.now(),
        'status': status,
        'score': 0,
      }, SetOptions(merge: true));
      final ref = _db
          .collection('app_users')
          .doc(_auth.currentUser!.uid)
          .collection('user_following')
          .doc(mUserUid);
      await ref.set({
        'uid': mUserUid,
        'timeStamp': DateTime.now(),
        'status': status,
        'score': 0,
      }, SetOptions(merge: true));
      await _microDataController.updateUserFollowingCounter(
        _auth.currentUser!.uid,
        mUserUid,
        follow,
      );
      if (follow) {
        EasyLoading.showSuccess('Following');
      } else {
        EasyLoading.showSuccess('I canceled the follow');
      }
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError(tr('An error has occurred'));
      return;
    }
  }

  Future<void> initFollowingCount(String mUserUid) async {
    final followingCount = await fetchUserFollowingCount(mUserUid);
    userFollowingCount.value = followingCount.length;
    final followedByCount = await fetchUserFollowedByCount(mUserUid);
    userFollowedByCount.value = followedByCount.length;
  }

  Future<List<String>> fetchUserFollowingCount(String mUserUid) async {
    try {
      return await _db
          .collection('app_users')
          .doc(mUserUid)
          .collection('counters')
          .doc('user_following')
          .get()
          .then((doc) {
            if (doc.exists) {
              return List.from(
                doc.data()!['list'],
              ).map((e) => e as String).toList();
            } else {
              return [];
            }
          });
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<String>> fetchUserFollowedByCount(String mUserUid) async {
    try {
      return await _db
          .collection('app_users')
          .doc(mUserUid)
          .collection('counters')
          .doc('user_followed_by')
          .get()
          .then((doc) {
            if (doc.exists) {
              return List.from(
                doc.data()!['list'],
              ).map((e) => e as String).toList();
            } else {
              return [];
            }
          });
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  void clearController() {
    isFollowing.value = false;
    allPostByCreator.clear();
    userFollowingCount.value = 0;
    userFollowedByCount.value = 0;
  }
}
