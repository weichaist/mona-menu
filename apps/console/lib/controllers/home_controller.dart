import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mona_console/models/acc_basic_info_model.dart';
import 'package:mona_console/models/customer_order_model.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  static const int pageSize = 30;

  // drawer management --------------------------------------------------------------------
  final _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  @override
  void onInit() async {
    super.onInit();
    await initOnboarding();
  }

  void openOrCloseDrawer() {
    if (_scaffoldKey.currentState != null) {
      if (_scaffoldKey.currentState!.isDrawerOpen) {
        _scaffoldKey.currentState!.openEndDrawer();
      } else {
        _scaffoldKey.currentState!.openDrawer();
      }
    }
  }

  void setMenuIndex(int index) {
    _selectedIndex.value = index;
  }

  //fetch restaurant account data----------------------------------------------------------
  final restaurantAccInfo = AccBasicInfo(name: '', profileImageUrl: '').obs;

  Future<AccBasicInfo?> fetchRestaurantBasicInfoData() async {
    try {
      return await _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((doc) {
            if (doc.exists) {
              return AccBasicInfo.fromFirestore(doc.data()!);
            } else {
              return null;
            }
          });
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  //onboarding process

  Future<void> initOnboarding() async {
    late bool onboarded;
    final res = await fetchRestaurantBasicInfoData();
    if (res != null) {
      onboarded = res.onboardingCompleted!;
      if (!onboarded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed('/onboarding');
        });
      }
      if (res.name != null) {
        restaurantAccInfo.value = res;
      }
    } else {
      Get.offAllNamed('/not-found');
    }
  }

  //fetch order stream------------------------------------------------------------
  final outstandingOrders = <CustomerOrder>[].obs;
  final completeOrders = <CustomerOrder>[].obs;

  void initBindingTodayOrders() {
    outstandingOrders.clear();
    completeOrders.clear();
    try {
      outstandingOrders.bindStream(streamOutstandingOrders());
      completeOrders.bindStream(streamCompleteOrders());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  final _startOfDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  final _endOfDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day + 1,
  );
  Stream<List<CustomerOrder>> streamOutstandingOrders() {
    return _db
        .collection('restaurant_accounts')
        .doc(_auth.currentUser!.uid)
        .collection('customer_orders')
        .where('orderStatus', isEqualTo: 'paid')
        // .where('orderTimeStamp', isGreaterThan: _startOfDay)
        // .where('orderTimeStamp', isLessThan: _endOfDay)
        .orderBy('orderTimeStamp', descending: true)
        .snapshots()
        .map((snap) {
          return snap.docs
              .map((doc) => CustomerOrder.fromFirestore(doc.data()))
              .toList();
        });
  }

  Stream<List<CustomerOrder>> streamCompleteOrders() {
    return _db
        .collection('restaurant_accounts')
        .doc(_auth.currentUser!.uid)
        .collection('customer_orders')
        .where('orderStatus', isEqualTo: 'confirmed')
        .where('orderTimeStamp', isGreaterThan: _startOfDay)
        .where('orderTimeStamp', isLessThan: _endOfDay)
        .orderBy('orderTimeStamp', descending: true)
        .snapshots()
        .map((snap) {
          return snap.docs
              .map((doc) => CustomerOrder.fromFirestore(doc.data()))
              .toList();
        });
  }

  //view order details---------------------------------------------------------
  Rx<CustomerOrder> customerOrderOnDisplay = CustomerOrder(orderId: '').obs;

  void changeOrderOnDisplay(CustomerOrder orderToView) {
    if (customerOrderOnDisplay.value.orderId == orderToView.orderId) {
      customerOrderOnDisplay.value = CustomerOrder(orderId: '');
    } else {
      customerOrderOnDisplay.value = orderToView;
    }
  }

  Future<void> updateOrderStatus(
    String orderId,
    String status,
    String notifySuccessUpdate,
  ) async {
    try {
      DocumentReference ref = _db
          .collection('restaurant_accounts')
          .doc(_auth.currentUser!.uid)
          .collection('customer_orders')
          .doc(orderId);
      await ref.update({'orderStatus': status});
      await updateMenuItemInOrder(orderId, status);
      EasyLoading.showSuccess(notifySuccessUpdate);
      customerOrderOnDisplay.value = CustomerOrder(orderId: '');
    } catch (err) {
      debugPrint(err.toString());
      EasyLoading.showSuccess('エラーが発生しました...');
    }
  }

  Future<void> updateMenuItemInOrder(String orderId, String status) async {
    CollectionReference menuItems = _db
        .collection('restaurant_accounts')
        .doc(_auth.currentUser!.uid)
        .collection('customer_orders')
        .doc(orderId)
        .collection('menuItems');
    WriteBatch batch = FirebaseFirestore.instance.batch();
    return await menuItems.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {'orderStatus': status});
      }
      return batch.commit();
    });
  }

  Future<void> refundStripePayment(
    String stripeIntent,
    String orderId,
    String status,
  ) async {
    try {
      final mode = await fetchStripeMode();
      final res = await FirebaseFunctions.instance
          .httpsCallable('refundStripePayment')
          .call({'mode': mode, 'stripeIntent': stripeIntent});
      debugPrint(res.toString());
      await updateOrderStatus(orderId, status, '返金を実行しました');
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError('エラーが発生しました...');
    }
  }

  Future<String> fetchStripeMode() async {
    try {
      return await _db
          .collection('env')
          .doc('stripe_mode')
          .get()
          .then((doc) => doc.data()!['mode'] ?? 'TEST');
    } catch (e) {
      debugPrint(e.toString());
      return 'TEST';
    }
  }

  //calculate today revenue-------------------------------------------------------
  double calculateTodayRevenue() {
    if (completeOrders.isNotEmpty) {
      return completeOrders.fold(0, (acc, element) {
        return acc + element.totalPrice!;
      });
    } else {
      return 0;
    }
  }

  //reset variables-------------------------------------------------------------
  void resetHomeController() {
    restaurantAccInfo.value = AccBasicInfo(name: '', profileImageUrl: '');
    outstandingOrders.value = <CustomerOrder>[];
    completeOrders.value = <CustomerOrder>[];
  }
}
