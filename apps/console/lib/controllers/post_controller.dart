import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mona_console/models/mona_menu_post_model.dart';

class PostController extends GetxController {
  static PostController instance = Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  //applied repeaters-------------------------------------------------------------
  final posts = <MonaMenuPost>[].obs;

  Future<void> initFetchMonaMenuPosts() async {
    final res = await fetchMonaMenuPosts();
    if (res != null) {
      posts.value = res;
    }
  }

  Query monaPostQuery() {
    return _db
        .collection('posts')
        .where('restaurantUid', isEqualTo: _auth.currentUser!.uid)
        .orderBy('postedAt', descending: true);
  }

  Future<List<MonaMenuPost>?> fetchMonaMenuPosts() async {
    try {
      return await _db
          .collection('posts')
          .where('restaurantUid', isEqualTo: _auth.currentUser!.uid)
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
}
