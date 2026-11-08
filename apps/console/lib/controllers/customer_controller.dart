import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mona_console/models/repeater_application_model.dart';

class CustomerController extends GetxController {
  static CustomerController instance = Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  //applied repeaters-------------------------------------------------------------
  final applications = <RepeaterApplication>[].obs;

  Future<void> initFetchingRepeaterApplications() async {
    applications.clear();
    final res = await fetchRepeaterApplications();
    if (res != null) {
      applications.value = res;
    }
  }

  Query repeaterApplicationsQuery() {
    return _db
        .collection('restaurant_accounts')
        .doc(_auth.currentUser!.uid)
        .collection('repeaters')
        .orderBy('timestamp', descending: true);
  }

  Future<List<RepeaterApplication>?> fetchRepeaterApplications() async {
    try {
      return await _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .collection('repeaters')
          .where('status', isEqualTo: 'applied')
          .orderBy('timestamp', descending: true)
          .get()
          .then(
            (snap) => snap.docs
                .map((doc) => RepeaterApplication.fromFirestore(doc.data()))
                .toList(),
          );
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  //certified repeaters-------------------------------------------------------------
  final approvedRepeaters = <RepeaterApplication>[].obs;

  Future<void> initFetchingCertifiedCustomers() async {
    approvedRepeaters.clear();
    final res = await fetchCertifiedCustomers();
    if (res != null) {
      approvedRepeaters.value = res;
    }
  }

  Future<List<RepeaterApplication>?> fetchCertifiedCustomers() async {
    try {
      return await _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .collection('repeaters')
          .where('status', isEqualTo: 'approved')
          .orderBy('timestamp', descending: true)
          .limit(3)
          .get()
          .then(
            (snap) => snap.docs
                .map((doc) => RepeaterApplication.fromFirestore(doc.data()))
                .toList(),
          );
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> setRepeaterStatus(
    String uid,
    String status,
    String successMessage,
  ) async {
    try {
      await _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .collection('repeaters')
          .doc(uid)
          .update({'status': status});
      EasyLoading.showSuccess(successMessage);
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError('エラーが発生しました...');
    }
  }
}
