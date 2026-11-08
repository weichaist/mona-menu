import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mona_console/models/customer_order_model.dart';

class HistoryController extends GetxController {
  static HistoryController instance = Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  //applied repeaters-------------------------------------------------------------
  final orderHistory = <CustomerOrder>[].obs;

  Future<void> initFetchingOrderHistory() async {
    orderHistory.clear();
    final res = await fetchOrderHistory();
    if (res != null) {
      orderHistory.value = res;
    }
  }

  Query orderHistoryQuery() {
    return _db
        .collection('restaurant_accounts')
        .doc(_auth.currentUser!.uid)
        .collection('customer_orders')
        .orderBy('orderTimeStamp', descending: true);
  }

  Future<List<CustomerOrder>?> fetchOrderHistory() async {
    try {
      return await _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .collection('customer_orders')
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
}
