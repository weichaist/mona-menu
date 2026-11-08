import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mona_diner/models/bank_accout_model.dart';
import 'package:mona_diner/models/customer_order_model.dart';
import 'package:mona_diner/models/mona_menu_post_model.dart';
import 'package:mona_diner/models/mona_order_in_cart_model.dart';
import 'package:mona_diner/models/mona_user_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ProfileController extends GetxController {
  static ProfileController instance = Get.find();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  final mUser = MUser(
    displayName: '',
    firstName: '',
    lastName: '',
    bio: '',
    profilePictureURL: '',
  ).obs;

  final currentUserPostHistory = <MonaMenuPost>[].obs;
  final currentUserPostPurchasedHistory = <MonaOrderInCart>[].obs;

  final currentUserOrderHistory = <CustomerOrder>[].obs;

  final profilePictureUrl = ''.obs;
  final phoneNumber = ''.obs;
  final email = ''.obs;
  final emailVerified = false.obs;
  final postCount = 0.obs;
  final userFollowingCount = 0.obs;
  final userFollowedByCount = 0.obs;

  FormGroup profileForm = FormGroup({
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

  final userBankAccount = UserBankAccount().obs;

  FormGroup bankInfoForm = FormGroup({
    'bankName': FormControl<String>(validators: [Validators.required]),
    'branch': FormControl<String>(validators: [Validators.required]),
    'accType': FormControl<String>(validators: [Validators.required]),
    'accNumber': FormControl<String>(validators: [Validators.required]),
    'accName': FormControl<String>(validators: [Validators.required]),
  });

  //init controller -------------------------------------------------------------
  Future<void> initProfile() async {
    try {
      final res = await _db
          .collection('app_users')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((doc) => doc.data()!['onboarded']);
      if (!res) {
        _initOnboarding();
      } else {
        await setProfile();
        await initFetchAccountPrivacyData();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> setProfile() async {
    var res = await fetchAccountUserData();
    if (res != null) {
      mUser.value = res;
    }
  }

  Future<MUser?> fetchAccountUserData() async {
    try {
      return await _db
          .collection('app_users')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((doc) => MUser.fromFirestore(doc.data()!));
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> initFetchAccountPrivacyData() async {
    try {
      emailVerified.value = _auth.currentUser!.emailVerified;
      return await _db
          .collection('app_users')
          .doc(_auth.currentUser!.uid)
          .collection('secrets')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((doc) {
            email.value = doc.data()!['email'];
            phoneNumber.value = doc.data()!['phoneNumber'];
            if (doc.data()!['bankInfo'] != null) {
              userBankAccount.value = UserBankAccount.fromFirestore(
                doc.data()!['bankInfo'],
              );
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //init profile statistics-----------------------------------------------------------
  // Future<void> initProfileNumbers() async {
  //   await initFetchingCurrentUserPostHistory();
  //   await initFetchingCurrentUserPostPurchasedHistory();
  // }

  Future<void> initFetchingCurrentUserPostHistory() async {
    var res = await _fetchingCurrentUserPostHistory();
    if (res != null) {
      currentUserPostHistory.value = res;
    }
  }

  Query postHistoryPost() {
    return _db
        .collection('posts')
        .where('active', isEqualTo: true)
        .where('postedBy', isEqualTo: _auth.currentUser!.uid)
        .orderBy('postedAt', descending: true);
  }

  Future<List<MonaMenuPost>?> _fetchingCurrentUserPostHistory() async {
    try {
      return await _db
          .collection('posts')
          .where('postedBy', isEqualTo: _auth.currentUser!.uid)
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

  //init order history -----------------------------------------------------------
  Future<void> initFetchingCurrentUserOrderHistory() async {
    var res = await _fetchingCurrentUserOrderHistory();
    if (res != null) {
      currentUserOrderHistory.value = res;
    }
  }

  Query orderHistoryQuery() {
    return _db
        .collectionGroup('customer_orders')
        .where('orderedBy', isEqualTo: _auth.currentUser!.uid)
        .orderBy('orderTimeStamp', descending: true);
  }

  Future<List<CustomerOrder>?> _fetchingCurrentUserOrderHistory() async {
    try {
      return await _db
          .collectionGroup('customer_orders')
          .where('orderedBy', isEqualTo: _auth.currentUser!.uid)
          .orderBy('orderTimeStamp', descending: true)
          .get()
          .then(
            (snap) => snap.docs
                .map((doc) => CustomerOrder.fromFirestore(doc.data()))
                .toList(),
          );
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  //init purchase history -----------------------------------------------------------

  Future<void> initFetchingCurrentUserPostPurchasedHistory() async {
    currentUserPostPurchasedHistory.clear();
    var res = await _fetchingCurrentUserPostPurchasedHistory();
    if (res != null) {
      currentUserPostPurchasedHistory.value = res;
    } else {
      currentUserPostPurchasedHistory.clear();
    }
  }

  Query rewardHistoryQuery() {
    return _db
        .collectionGroup('menuItems')
        .where('affiliateUserUid', isEqualTo: _auth.currentUser!.uid)
        .orderBy('orderTimeStamp', descending: true);
  }

  Future<List<MonaOrderInCart>?>
  _fetchingCurrentUserPostPurchasedHistory() async {
    try {
      return await _db
          .collectionGroup('menuItems')
          .where('affiliateUserUid', isEqualTo: _auth.currentUser!.uid)
          .orderBy('orderTimeStamp', descending: true)
          .get()
          .then(
            (snap) => snap.docs
                .map((doc) => MonaOrderInCart.fromFirestore(doc.data()))
                .toList(),
          );
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  //following users and followed by users

  Future<void> initFollowingCount() async {
    final followingCount = await fetchUserFollowingCount();
    userFollowingCount.value = followingCount.length;
    final followedByCount = await fetchUserFollowedByCount();
    userFollowedByCount.value = followedByCount.length;
  }

  Query userFollowingQuery() {
    return _db
        .collection('app_users')
        .doc(_auth.currentUser!.uid)
        .collection('user_following')
        .where('status', isEqualTo: 'following');
  }

  Future<List<String>> fetchUserFollowingCount() async {
    try {
      return await _db
          .collection('app_users')
          .doc(_auth.currentUser!.uid)
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

  Query userFollowedByQuery() {
    return _db
        .collection('app_users')
        .doc(_auth.currentUser!.uid)
        .collection('user_followed_by')
        .where('status', isEqualTo: 'following');
  }

  Future<List<String>> fetchUserFollowedByCount() async {
    try {
      return await _db
          .collection('app_users')
          .doc(_auth.currentUser!.uid)
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

  //update user profile---------------------------------------------------------------------
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

  Future<void> updatedUserProfilePicture(String filePath) async {
    try {
      EasyLoading.show(status: tr('Saving'));
      if (!profilePictureUrl.startsWith('https://')) {
        Map<String, String>? imageRef = await _uploadImage(filePath);
        if (imageRef != null) {
          await _db.collection('app_users').doc(_auth.currentUser!.uid).update({
            'profilePictureURL': imageRef,
          });
        }
      }
      EasyLoading.dismiss();
      EasyLoading.showSuccess(tr('I saved!'));
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.dismiss();
      EasyLoading.showError(tr('An error has occurred'));
    }
  }

  Future<void> updatedUserProfile() async {
    try {
      EasyLoading.show(status: tr('Saving'));
      await _db.collection('app_users').doc(_auth.currentUser!.uid).update({
        'displayName': profileForm.value['displayName'],
        'firstName': profileForm.value['firstName'],
        'lastName': profileForm.value['lastName'],
        'bio': profileForm.value['bio'],
      });
      EasyLoading.dismiss();
      EasyLoading.showSuccess(tr('I saved!'));
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.dismiss();
      EasyLoading.showError(tr('An error has occurred'));
    }
  }

  Future<void> updateUserPrivacyData(Map<String, dynamic> dataToUpdate) async {
    try {
      EasyLoading.show(status: tr('Saving'));
      await _db
          .collection('app_users')
          .doc(_auth.currentUser!.uid)
          .collection('secrets')
          .doc(_auth.currentUser!.uid)
          .update(dataToUpdate);
      EasyLoading.dismiss();
      EasyLoading.showSuccess(tr('I saved!'));
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.dismiss();
      EasyLoading.showError(tr('An error has occurred'));
    }
  }

  //init profile edit process --------------------------------------------------------------------------------------
  void initProfileEditingProcess() {
    profileForm.value = {
      'email': email.value,
      'firstName': mUser.value.firstName,
      'lastName': mUser.value.lastName,
      'bio': mUser.value.bio,
      'displayName': mUser.value.displayName,
    };
    profilePictureUrl.value = mUser.value.profilePictureURL!;
  }

  //init onboarding process --------------------------------------------------------------------------------------
  void _initOnboarding() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed('/onboard');
    });
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

  //update post status
  Future<void> updatePostStatus(String postId) async {
    try {
      await _db.collection('posts').doc(postId).update({'active': false});
      EasyLoading.showSuccess(tr('Post has been deleted'));
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError(tr('An error has occurred'));
    }
  }

  //sign out --------------------------------------------------------------------------------------

  void signOutAcc() async {
    await _auth.signOut();
    Get.offAllNamed('/');
    _resetProfileController();
  }

  void _resetProfileController() {
    mUser.value = MUser(
      displayName: '',
      firstName: '',
      lastName: '',
      bio: '',
      profilePictureURL: '',
    );
    userBankAccount.value = UserBankAccount();
    profileForm.reset();

    currentUserPostHistory.clear();
    currentUserPostPurchasedHistory.clear();
    currentUserOrderHistory.clear();

    profilePictureUrl.value = '';
    phoneNumber.value = '';
    email.value = '';
    emailVerified.value = false;
    postCount.value = 0;

    userFollowingCount.value = 0;
    userFollowedByCount.value = 0;
  }
}
