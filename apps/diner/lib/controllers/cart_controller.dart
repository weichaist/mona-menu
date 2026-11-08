import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/models/mona_order_in_cart_model.dart';
import 'package:mona_diner/models/mona_user_model.dart';
import 'package:mona_diner/models/order_in_cart_model.dart';
import 'package:mona_diner/models/restaurant_account_model.dart';
import 'package:mona_diner/models/restaurant_menu_item_model.dart';
import 'package:mona_diner/models/temp_mona_menu_item_model.dart';
import 'package:mona_diner/screens/restaurant_screen/components/build_success_order_dialog.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_network_error_dialog.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final cartIsOpen = false.obs;

  final ordersInCart = <OrderInCart>[].obs;
  final monaOrdersInCart = <MonaOrderInCart>[].obs;

  final orderType = OrderType.eatIn.obs;
  final selectedTableNumber = ''.obs;

  //check cart open status
  bool checkRestaurantOpenStatus(RestaurantAccount restaurantAccount) {
    final now = DateTime.now();
    final businessHour = restaurantAccount.businessHours![now.weekday - 1];
    if (businessHour.isOpenNow()) {
      return true;
    } else {
      return false;
    }
  }

  void checkCartOpenStatus(RestaurantAccount restaurantAccount) {
    final cartOpen = checkRestaurantOpenStatus(restaurantAccount);
    cartIsOpen.value = cartOpen;
  }

  //standard cart
  //------------------------------------------------------------------------------------------
  int totalStandardOrderCount() {
    return ordersInCart.fold(
      0,
      (previousValue, element) => previousValue + element.orderCount!,
    );
  }

  double totalStandardOrderPrice() {
    return ordersInCart.fold(
      0,
      (previousValue, element) =>
          previousValue + element.orderCount! * element.price!,
    );
  }

  int orderCountInCart(String? menuItemId) {
    int index = ordersInCart.indexWhere((el) => el.menuItemDocID == menuItemId);
    if (index < 0) {
      return 0;
    } else {
      if (ordersInCart[index].orderCount != null) {
        return ordersInCart[index].orderCount!;
      } else {
        return 0;
      }
    }
  }

  bool menuItemExistsInCart(String? menuItemId) {
    int index = ordersInCart.indexWhere((el) => el.menuItemDocID == menuItemId);
    if (index < 0) {
      return false;
    } else {
      return true;
    }
  }

  void addRestaurantMenuOrderToCart(RestaurantMenuItem menuItem) {
    if (!menuItemExistsInCart(menuItem.docId)) {
      ordersInCart.add(
        OrderInCart(
          menuItemDocID: menuItem.docId,
          menuItemTitle: menuItem.title,
          menuGroup: menuItem.menuGroup,
          price: double.parse(menuItem.price.toString()),
          menuItemCategories: menuItem.categories,
          orderCount: 1,
        ),
      );
    }
  }

  void updateOrderCountInCart(String? menuItemId, int index) {
    int menuIndex = ordersInCart.indexWhere(
      (el) => el.menuItemDocID == menuItemId,
    );
    if (menuIndex < 0) {
      return;
    } else {
      if (index == 0) {
        //plus button
        ordersInCart[menuIndex].orderCount =
            ordersInCart[menuIndex].orderCount! + 1;
        ordersInCart.refresh();
      } else {
        //minus button
        if (ordersInCart[menuIndex].orderCount! == 1) {
          ordersInCart.removeAt(menuIndex);
        } else {
          ordersInCart[menuIndex].orderCount =
              ordersInCart[menuIndex].orderCount! - 1;
          ordersInCart.refresh();
        }
      }
    }
  }

  //mona cart
  //------------------------------------------------------------------------------------------
  int totalMonaOrderCount() {
    return monaOrdersInCart.fold(
      0,
      (previousValue, element) => previousValue + element.orderCount!,
    );
  }

  double totalMonaOrderPrice() {
    return monaOrdersInCart.fold(
      0,
      (previousValue, element) =>
          previousValue + element.orderCount! * element.price!,
    );
  }

  int monaOrderCountInCart(String? postId) {
    int index = monaOrdersInCart.indexWhere(
      (el) => el.affiliatePostId == postId,
    );
    if (index < 0) {
      debugPrint("can't find standard order in cart");
      return 0;
    } else {
      if (monaOrdersInCart[index].orderCount != null) {
        return monaOrdersInCart[index].orderCount!;
      } else {
        return 0;
      }
    }
  }

  bool monaMenuItemExistsInCart(String? postId) {
    int index = monaOrdersInCart.indexWhere(
      (el) => el.affiliatePostId == postId,
    );
    if (index < 0) {
      return false;
    } else {
      return true;
    }
  }

  void addMonaMenuOrderToCart(TempMonaMenuItem monaMenuItem, MUser mUser) {
    if (!monaMenuItemExistsInCart(monaMenuItem.postId)) {
      monaOrdersInCart.add(
        MonaOrderInCart(
          menuItemDocID: monaMenuItem.menuItemId,
          menuItemTitle: monaMenuItem.title,
          menuGroup: monaMenuItem.menuGroup,
          price: double.parse(monaMenuItem.price.toString()),
          menuItemCategories: monaMenuItem.categories,
          orderCount: 1,
          affiliatePostId: monaMenuItem.postId,
          affiliateUserUid: monaMenuItem.postedBy,
          affiliateUserDisplayName: mUser.displayName,
          affiliateUserProfileUrl: mUser.profilePictureURL,
        ),
      );
    }
  }

  void updateMonaOrderCountInCart(String? monaMenuId, int index) {
    int menuIndex = monaOrdersInCart.indexWhere(
      (el) => el.affiliatePostId == monaMenuId,
    );
    if (menuIndex < 0) {
      debugPrint("can't find mona order in cart");
      return;
    } else {
      if (index == 0) {
        //plus button
        monaOrdersInCart[menuIndex].orderCount =
            monaOrdersInCart[menuIndex].orderCount! + 1;
        monaOrdersInCart.refresh();
      } else {
        //minus button
        if (monaOrdersInCart[menuIndex].orderCount! == 1) {
          monaOrdersInCart.removeAt(menuIndex);
        } else {
          monaOrdersInCart[menuIndex].orderCount =
              monaOrdersInCart[menuIndex].orderCount! - 1;
          monaOrdersInCart.refresh();
        }
      }
    }
  }
  //overall processing
  //------------------------------------------------------------------------------------------

  int totalOrderCount() {
    return totalStandardOrderCount() + totalMonaOrderCount();
  }

  double totalOrderPrice(double tax) {
    return (totalStandardOrderPrice() + totalMonaOrderPrice()) * (1 + tax);
  }

  bool checkOrderInfoCompleted() {
    if (selectedTableNumber.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void buildOrderConfirmationError() {
    if (selectedTableNumber.isEmpty) {
      EasyLoading.showError(tr('Please select a table'));
    }
  }

  List<Map<String, dynamic>> mergeTwoCartsForMenuItems() {
    List<Map<String, dynamic>> menuItems = ordersInCart
        .map(
          (order) => {
            'menuItemTitle': order.menuItemTitle!,
            'menuItemId': order.menuItemDocID!,
            'menuGroup': order.menuGroup!,
            'price': order.price!,
            'quantity': order.orderCount!,
          },
        )
        .toList();

    List<Map<String, dynamic>> monaMenuItems = monaOrdersInCart
        .map(
          (order) => {
            'menuItemTitle': order.menuItemTitle!,
            'menuItemId': order.menuItemDocID!,
            'menuGroup': order.menuGroup!,
            'price': order.price!,
            'quantity': order.orderCount!,
          },
        )
        .toList();
    List<String> mergedIds = mergeTwoCartsForMenuItemIds();
    List<Map<String, dynamic>> mergedList = [];
    for (String id in mergedIds) {
      final index = menuItems.indexWhere((el) => el['menuItemId'] == id);
      final indexMona = monaMenuItems.indexWhere(
        (el) => el['menuItemId'] == id,
      );
      if (index >= 0) {
        if (indexMona >= 0) {
          menuItems[index]['quantity'] =
              menuItems[index]['quantity'] +
              monaMenuItems[indexMona]['quantity'];
          mergedList.add(menuItems[index]);
        } else {
          mergedList.add(menuItems[index]);
        }
      } else {
        if (indexMona >= 0) {
          mergedList.add(monaMenuItems[indexMona]);
        }
      }
    }
    return mergedList;
  }

  List<String> mergeTwoCartsForMenuItemIds() {
    List<String> menuItemIds = ordersInCart
        .map((order) => order.menuItemDocID!)
        .toList();
    List<String> monaMenuItemIds = monaOrdersInCart
        .map((order) => order.menuItemDocID!)
        .toList();
    return {...menuItemIds, ...monaMenuItemIds}.toList();
  }

  //restaurant controller
  final _restaurantController = RestaurantController.instance;
  //send success order to database
  Future<void> sendCompletedOrder({
    required RestaurantAccount restaurant,
    required String stripeIntent,
    required String clientSecret,
    required String tokenId,
    required dynamic paymentMethod,
    required String stripeMode,
  }) async {
    try {
      EasyLoading.show(status: tr('Orders are being processed..'));
      List<Map<String, dynamic>> menuItems = mergeTwoCartsForMenuItems();
      List<String> menuItemIds = mergeTwoCartsForMenuItemIds();
      DocumentReference orderRef = _db
          .collection('restaurant_accounts')
          .doc(restaurant.uid!)
          .collection('customer_orders')
          .doc();
      await orderRef.set({
        'orderStatus': 'ordered',
        'orderID': orderRef.id,
        'stripeIntent': stripeIntent,
        'menuGroup': _restaurantController.checkCurrentMenuGroup(restaurant),
        'orderTimeStamp': DateTime.now(),
        'orderedBy': _auth.currentUser!.uid,
        'restaurantUid': restaurant.uid!,
        'restaurantName': restaurant.name!,
        'tableNumber': selectedTableNumber.value,
        'menuItemIds': menuItemIds,
        'menuItems': menuItems,
        'totalPrice': totalOrderPrice(_restaurantController.tax.value).toInt(),
        'paymentMethod': paymentMethod,
        'tokenId': tokenId,
        'clientSecret': clientSecret,
        'tax': _restaurantController.tax.value,
      }, SetOptions(merge: true));
      await setCustomerOrderMenuItems(orderRef.id, restaurant.uid!);
      EasyLoading.dismiss();
      resetCart();
      Get.offAndToNamed('/restaurant/${restaurant.uid!}');
      await buildSuccessOrderedDialog(restaurant.uid!);
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.dismiss();
      EasyLoading.showError(tr('An error has occurred'));
      return;
    }
  }

  Future<void> setCustomerOrderMenuItems(
    String orderRef,
    String restaurantUid,
  ) async {
    try {
      CollectionReference menuItemsCollectionRef = _db
          .collection('restaurant_accounts')
          .doc(restaurantUid)
          .collection('customer_orders')
          .doc(orderRef)
          .collection('menuItems');
      if (ordersInCart.isNotEmpty) {
        for (var order in ordersInCart) {
          await menuItemsCollectionRef.add({
            'orderStatus': 'ordered',
            'menuItemTitle': order.menuItemTitle!,
            'menuItemId': order.menuItemDocID!,
            'menuItemCategories': order.menuItemCategories!,
            'menuGroup': order.menuGroup,
            'price': order.price!,
            'quantity': order.orderCount!,
            'total': order.price! * order.orderCount!,
            'orderID': orderRef,
            'restaurantUid': restaurantUid,
            'orderTimeStamp': DateTime.now(),
            'orderedBy': _auth.currentUser!.uid,
            'affiliateOrder': false,
          });
        }
      }
      if (monaOrdersInCart.isNotEmpty) {
        for (var order in monaOrdersInCart) {
          await menuItemsCollectionRef.add({
            'orderStatus': 'ordered',
            'menuItemTitle': order.menuItemTitle!,
            'menuItemId': order.menuItemDocID!,
            'menuItemCategories': order.menuItemCategories!,
            'menuGroup': order.menuGroup,
            'price': order.price!,
            'quantity': order.orderCount!,
            'total': order.price! * order.orderCount!,
            'orderID': orderRef,
            'restaurantUid': restaurantUid,
            'orderTimeStamp': DateTime.now(),
            'orderedBy': _auth.currentUser!.uid,
            'affiliateOrder': true,
            'affiliateUserUid': order.affiliateUserUid,
            'affiliatePostId': order.affiliatePostId,
          });
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.dismiss();
      EasyLoading.showError(tr('An error has occurred'));
    }
  }

  //handle menu item sold out-------------------------------------------------------
  Future<bool> fetchMenuItemSoldOutStatus(
    String menuItemId,
    String restaurantId,
  ) async {
    try {
      return await _db
          .collection('restaurant_accounts')
          .doc(restaurantId)
          .collection('menu')
          .doc(menuItemId)
          .get()
          .then((doc) => doc.data()!['soldOut'] ?? false);
    } catch (e) {
      debugPrint(e.toString());
      buildNetworkErrorDialog();
      return false;
    }
  }

  void removeSoldOutMenuItems(String menuItemId) {
    ordersInCart.value = ordersInCart
        .where((val) => val.menuItemDocID! != menuItemId)
        .toList();
    monaOrdersInCart.value = monaOrdersInCart
        .where((val) => val.menuItemDocID! != menuItemId)
        .toList();
  }

  void resetCart() {
    ordersInCart.clear();
    monaOrdersInCart.clear();
  }

  void resetController() {
    cartIsOpen.value = false;
    ordersInCart.clear();
    monaOrdersInCart.clear();

    selectedTableNumber.value = '';
  }
}

enum OrderType { eatIn, takeOut }
