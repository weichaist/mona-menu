import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mona_diner/config.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/micro_data_controller.dart';
import 'package:mona_diner/models/live_order_model.dart';
import 'package:mona_diner/models/mona_menu_post_model.dart';
import 'package:mona_diner/models/restaurant_account_model.dart';
import 'package:mona_diner/models/restaurant_menu_item_model.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_dialog_text_button.dart';
import 'package:mona_diner/size_config.dart';
import 'package:share_plus/share_plus.dart';

class UserPostController extends GetxController {
  static UserPostController instance = Get.find();
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;

  TextEditingController commentController = TextEditingController();

  //variables ------------------------------------------------------------------

  final comment = ''.obs;
  final imageFiles = <String>[].obs;

  final monaMenuToEdit = MonaMenuPost().obs;
  final editingProcess = false.obs;

  final orderHistory = <LiveOrder>[].obs;

  //handle new post ------------------------------------------------------------------
  bool readyToPost() {
    if (comment.trim().isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

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

  Future<List<Map<String, String>>> uploadImageFiles(
    List<String> imageFilePaths,
  ) async {
    List<Map<String, String>> imageRefList = [];
    try {
      if (imageFilePaths.isNotEmpty) {
        for (final path in imageFilePaths) {
          var res = await _uploadImage(path);
          if (res != null) {
            imageRefList.add(res);
          }
        }
        return imageRefList;
      } else {
        return imageRefList;
      }
    } catch (e) {
      debugPrint(e.toString());
      return imageRefList;
    }
  }

  Future<void> uploadNewMonaMenu(
    String restaurantUid,
    RestaurantMenuItem menuItem,
  ) async {
    try {
      EasyLoading.show(status: '投稿中..');
      final refList = await uploadImageFiles(imageFiles);
      DocumentReference ref = _db.collection('posts').doc();
      await ref.set({
        'active': true,
        'rankingScore': 0.0,
        'postId': ref.id,
        'postedBy': _auth.currentUser!.uid,
        'postedAt': DateTime.now(),
        'menuItemId': menuItem.docId!,
        'menuItemName': menuItem.title!,
        'menuItemCategories': menuItem.categories!,
        'menuGroup': menuItem.menuGroup,
        'price': menuItem.price!,
        'restaurantUid': restaurantUid,
        'comment': comment.value,
        'images': refList,
      }, SetOptions(merge: true));
      EasyLoading.dismiss();
      Get.back();
      buildSuccessPostedDialog(restaurantUid, ref.id);
      return;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return;
    }
  }

  //edit post
  void initEditingProcess(MonaMenuPost monaPost) {
    monaMenuToEdit.value = monaPost;
    editingProcess.value = true;
    commentController.text = monaPost.userComment!;
    comment.value = monaPost.userComment!;
    if (monaPost.userImages != null) {
      imageFiles.value = monaPost.userImages!;
    }
  }

  Future<List<Map<String, String>>> uploadEditedImages(
    List<String> imageFilePaths,
    List<Map<String, String>> imagesWithRef,
  ) async {
    List<Map<String, String>> imageRefList = [];
    try {
      if (imageFilePaths.isNotEmpty) {
        for (String path in imageFilePaths) {
          if (!path.startsWith('https://')) {
            var res = await _uploadImage(path);
            if (res != null) {
              imageRefList.add(res);
            }
          } else {
            imageRefList.add(imagesWithRef[imageFilePaths.indexOf(path)]);
          }
        }
        return imageRefList;
      } else {
        return imageRefList;
      }
    } catch (e) {
      debugPrint(e.toString());
      return imageRefList;
    }
  }

  Future<void> saveEditedMonaMenu() async {
    try {
      EasyLoading.show(status: tr('Saving'));
      List<Map<String, String>> refList = await uploadEditedImages(
        imageFiles,
        monaMenuToEdit.value.userImagesWithRef!,
      );
      DocumentReference ref = _db
          .collection('posts')
          .doc(monaMenuToEdit.value.postId);
      await ref.set({
        'editedAt': DateTime.now(),
        'comment': comment.value,
        'images': refList,
      }, SetOptions(merge: true));
      await ref.update({'rankingScore': FieldValue.increment(0.1)});
      EasyLoading.dismiss();
      Get.back();
      return;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError('Oops.. ${tr('Error')}');
      return;
    }
  }

  //display order history and post history
  Future<void> initFetchOrderHistory() async {
    final res = await _fetchLiveOrders();
    if (res != null) {
      orderHistory.value = res;
    }
  }

  Query orderHistoryQuery() {
    return _db
        .collectionGroup('customer_orders')
        .where('orderedBy', isEqualTo: _auth.currentUser!.uid)
        .orderBy('orderTimeStamp', descending: true);
  }

  Future<List<LiveOrder>?> _fetchLiveOrders() async {
    try {
      return await _db
          .collectionGroup('customer_orders')
          .where('orderedBy', isEqualTo: _auth.currentUser!.uid)
          .orderBy('orderTimeStamp', descending: true)
          .get()
          .then(
            (snap) => snap.docs
                .map((doc) => LiveOrder.fromFirestore(doc.data()))
                .toList(),
          );
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  void resetController() {
    comment.value = '';
    commentController.clear();
    imageFiles.clear();
    monaMenuToEdit.value = MonaMenuPost();
    editingProcess.value = false;

    orderHistory.clear();
  }
}

Future<dynamic> buildSuccessPostedDialog(
  String restaurantUid,
  String postId,
) async {
  MicroDataController microDataController = MicroDataController.instance;
  final newPostController = UserPostController.instance;
  await Get.defaultDialog(
    title: '投稿ありがとう！',
    barrierDismissible: false,
    content: FutureBuilder<RestaurantAccount?>(
      future: microDataController.fetchRestaurantAccountData(restaurantUid),
      builder: (context, snapshot) {
        var restaurantAcc = snapshot.data;
        return SizedBox(
          width: getScreenWidth() / 3 * 2,
          child: Column(
            children: [
              ProfileAvatarContainer(
                imageUrl: restaurantAcc != null
                    ? restaurantAcc.profileImageUrl!
                    : '',
                radius: 96,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 12,
                ),
                child: Text(
                  restaurantAcc != null ? restaurantAcc.name! : '',
                  style: const TextStyle(fontSize: 15, color: kBodyTextColor),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 12,
                ),
                child: Text(
                  tr('It will be useful for everyone\'s orders!'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: kBodyTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    ),
    confirm: DefaultDialogTextButton(
      text: tr('Share with friends'),
      onTap: () async {
        newPostController.initFetchOrderHistory();
        Get.back();
        await SharePlus.instance.share(
          ShareParams(text: '${AppConfig.shareBaseUrl}/post/$postId'),
        );
      },
    ),
    cancel: DefaultDialogTextButton(
      text: 'Close',
      bgColor: kBgColor,
      textColor: kBodyTextColor,
      onTap: () {
        newPostController.initFetchOrderHistory();
        Get.back();
      },
    ),
  );
}
