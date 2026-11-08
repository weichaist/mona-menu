import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mona_diner/models/customer_order_model.dart';
import 'package:mona_diner/models/live_order_model.dart';
import 'package:mona_diner/models/mona_menu_post_model.dart';
import 'package:mona_diner/models/restaurant_account_model.dart';
import 'package:mona_diner/models/restaurant_menu_item_model.dart';
import 'package:mona_diner/services/post_search.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_network_error_dialog.dart';

class RestaurantController extends GetxController {
  static RestaurantController instance = Get.find();
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  //variables -----------------------------------------------------------------
  final restaurantUid = ''.obs;

  final currentMenuGroup = 'lunch'.obs;
  final menuGroups = ['lunch', 'dinner'];

  final restaurantData = RestaurantAccount(
    name: '',
    profileImageUrl: '',
    bgImageUrl: '',
  ).obs;

  final restaurantTables = <String>[].obs;
  final liveOrders = <LiveOrder>[].obs;
  final currentUserPostHistory = <MonaMenuPost>[].obs;
  final isRepeaterStatus = ''.obs;

  final classicMenuItems = <RestaurantMenuItem>[].obs;
  final menuCategories = <String>[].obs;
  final categoryPositionIndex = 0.obs;

  final dishList = <RestaurantMenuItem>[].obs;

  final menuItemShortPosts = <MonaMenuPost>[].obs;

  final todayOrders = <CustomerOrder>[].obs;

  final tax = 0.1.obs;

  final latestPostList = <MonaMenuPost>[].obs;
  final latestFilterCategory = ''.obs;

  final repeaterPostList = <MonaMenuPost>[].obs;
  final repeaterFilterCategory = ''.obs;
  final repeaterCurrentPage = 0.obs;
  final repeaterPostListLastPage = false.obs;
  final repeaterList = <String>[].obs;
  final repeaterListLoading = false.obs;

  final followingPostList = <MonaMenuPost>[].obs;
  final followingFilterCategory = ''.obs;
  final followingCurrentPage = 0.obs;
  final followingPostListLastPage = false.obs;
  final followingUserList = <String>[].obs;
  final followingListLoading = false.obs;

  //init restaurant controller --------------------------------------------------

  Future<void> initRestaurantController() async {
    if (Get.parameters['restaurantUid'] != null) {
      restaurantUid.value = Get.parameters['restaurantUid']!;
      try {
        await FirebaseFunctions.instance
            .httpsCallable('fetchStripePubKey')
            .call({'mode': 'TEST'});
        final res = await fetchRestaurantAccountData(restaurantUid.value);
        if (res != null) {
          restaurantData.value = res;
          restaurantTables.value = restaurantData.value.tableNumbers!;
          loadCurrentMenuGroup(res);
          categoryPositionIndex.value = 0;
          tax.value = res.eatIn ? 0.1 : 0.08;
          await fetchCurrentMenuItems(res);
          initBindingLiveOrders(res.uid!, currentMenuGroup.value);
        }
      } catch (e) {
        debugPrint(e.toString());
        buildNetworkErrorDialog();
      }
    } else {
      Get.offAllNamed('/');
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

  //init mona posts --------------------------------------------------------------
  Future<void> initLatestMonaPostView(String filter) async {
    latestPostList.clear();
    final res = await _fetchLatestPosts(filter);
    if (res != null) {
      latestPostList.value = res;
    }
  }

  Query latestPostQuery(String filter) {
    if (filter.isNotEmpty) {
      return _db
          .collection('posts')
          .where('active', isEqualTo: true)
          .where('restaurantUid', isEqualTo: restaurantUid.value)
          .where('menuGroup', isEqualTo: currentMenuGroup.value)
          .where('menuItemCategories', arrayContains: filter)
          .orderBy('postedAt', descending: true);
    } else {
      return _db
          .collection('posts')
          .where('active', isEqualTo: true)
          .where('restaurantUid', isEqualTo: restaurantUid.value)
          .where('menuGroup', isEqualTo: currentMenuGroup.value)
          .orderBy('postedAt', descending: true);
    }
  }

  Future<List<MonaMenuPost>?> _fetchLatestPosts(String filter) async {
    try {
      if (filter.isNotEmpty) {
        return await _db
            .collection('posts')
            .where('active', isEqualTo: true)
            .where('restaurantUid', isEqualTo: restaurantUid.value)
            .where('menuGroup', isEqualTo: currentMenuGroup.value)
            .where('menuItemCategories', arrayContains: filter)
            .orderBy('postedAt', descending: true)
            .limit(3)
            .get()
            .then(
              (snap) => snap.docs
                  .map((doc) => MonaMenuPost.fromFirestore(doc.data()))
                  .toList(),
            );
      } else {
        return await _db
            .collection('posts')
            .where('active', isEqualTo: true)
            .where('restaurantUid', isEqualTo: restaurantUid.value)
            .where('menuGroup', isEqualTo: currentMenuGroup.value)
            .orderBy('postedAt', descending: true)
            .limit(3)
            .get()
            .then(
              (snap) => snap.docs
                  .map((doc) => MonaMenuPost.fromFirestore(doc.data()))
                  .toList(),
            );
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  //init repeater posts ---------------------------------------------------------
  Future<void> initRepeaterMonaPostView(
    String filter,
    String restaurantUid,
  ) async {
    repeaterListLoading.value = true;
    repeaterPostList.clear();
    repeaterList.clear();
    repeaterPostListLastPage.value = false;
    repeaterCurrentPage.value = 0;
    repeaterFilterCategory.value = '';
    repeaterList.value = await _fetchRepeaterList(restaurantUid);
    if (repeaterList.isNotEmpty) {
      final res = await _fetchRepeaterPosts(
        filter,
        restaurantUid,
        repeaterList,
      );
      if (res != null) {
        repeaterPostList.value = res;
        repeaterListLoading.value = false;
      } else {
        repeaterListLoading.value = false;
      }
    } else {
      repeaterListLoading.value = false;
    }
  }

  Future<void> initFilteredRepeaterMonaPostView(
    String filter,
    String restaurantUid,
  ) async {
    repeaterListLoading.value = true;
    repeaterPostList.clear();
    repeaterCurrentPage.value = 0;
    repeaterPostListLastPage.value = false;
    final res = await _fetchRepeaterPosts(filter, restaurantUid, repeaterList);
    if (res != null) {
      repeaterPostList.value = res;
      repeaterListLoading.value = false;
    } else {
      repeaterListLoading.value = false;
    }
  }

  Future<List<String>> _fetchRepeaterList(String restaurantUid) async {
    try {
      return await _db
          .collection('restaurant_accounts')
          .doc(restaurantUid)
          .collection('repeaters')
          .where('status', isEqualTo: 'approved')
          .get()
          .then((snap) => snap.docs.map((doc) => doc.id).toList());
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  List<dynamic> _repeaterPostQuery(
    String filter,
    String restaurantUID,
    List<String> userList,
  ) {
    return PostSearch.restaurantPostsByUsers(
      restaurantUid: restaurantUID,
      userUids: userList,
      menuGroup: currentMenuGroup.value,
      category: filter,
    );
  }

  Future<List<MonaMenuPost>?> _fetchRepeaterPosts(
    String filter,
    String restaurantUID,
    List<String> repeaterList,
  ) async {
    try {
      final filteredQuery = _repeaterPostQuery(
        filter,
        restaurantUID,
        repeaterList,
      );
      final snap = await PostSearch.search(facetFilters: filteredQuery);
      if (snap.isLastPage) {
        repeaterPostListLastPage.value = true;
      }
      repeaterCurrentPage.value = snap.page;
      if (snap.nbHits > 0) {
        return snap.posts;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> repeaterListNextPage(String filter, String restaurantUID) async {
    repeaterListLoading.value = true;
    final filteredQuery = _repeaterPostQuery(
      filter,
      restaurantUID,
      repeaterList,
    );
    final snap = await PostSearch.search(
      facetFilters: filteredQuery,
      page: repeaterCurrentPage.value + 1,
    );
    repeaterListLoading.value = true;
    if (snap.isLastPage) {
      repeaterPostListLastPage.value = true;
    }
    repeaterPostList.addAll(snap.posts);
    repeaterCurrentPage.value++;
  }

  //init following users post list---------------------------------------------------
  Future<void> initFollowingMonaPostView(
    String filter,
    String restaurantUid,
  ) async {
    followingListLoading.value = true;
    followingPostList.clear();
    followingUserList.clear();
    followingPostListLastPage.value = false;
    followingCurrentPage.value = 0;
    followingFilterCategory.value = '';
    followingUserList.value = await _fetchFollowingUserList();
    if (followingUserList.isNotEmpty) {
      final res = await _fetchFollowingUserPosts(
        filter,
        restaurantUid,
        followingUserList,
      );
      if (res != null) {
        followingPostList.value = res;
        followingListLoading.value = false;
      } else {
        followingListLoading.value = false;
      }
    } else {
      followingListLoading.value = false;
    }
  }

  Future<void> initFilteredFollowingUserMonaPostView(
    String filter,
    String restaurantUid,
  ) async {
    followingListLoading.value = true;
    followingPostList.clear();
    followingCurrentPage.value = 0;
    followingPostListLastPage.value = false;
    final res = await _fetchFollowingUserPosts(
      filter,
      restaurantUid,
      followingUserList,
    );
    if (res != null) {
      followingPostList.value = res;
      followingListLoading.value = false;
    } else {
      followingListLoading.value = false;
    }
  }

  Future<List<String>> _fetchFollowingUserList() async {
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

  List<dynamic> _followingUserPostQuery(
    String filter,
    String restaurantUID,
    List<String> userList,
  ) {
    return PostSearch.restaurantPostsByUsers(
      restaurantUid: restaurantUID,
      userUids: userList,
      menuGroup: currentMenuGroup.value,
      category: filter,
    );
  }

  Future<List<MonaMenuPost>?> _fetchFollowingUserPosts(
    String filter,
    String restaurantUID,
    List<String> followingUserList,
  ) async {
    try {
      final filteredQuery = _followingUserPostQuery(
        filter,
        restaurantUID,
        followingUserList,
      );
      final snap = await PostSearch.search(facetFilters: filteredQuery);
      if (snap.isLastPage) {
        followingPostListLastPage.value = true;
      }
      followingCurrentPage.value = snap.page;
      if (snap.nbHits > 0) {
        return snap.posts;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> followingListNextPage(
    String filter,
    String restaurantUID,
  ) async {
    followingListLoading.value = true;
    final filteredQuery = _followingUserPostQuery(
      filter,
      restaurantUID,
      followingUserList,
    );
    final snap = await PostSearch.search(
      facetFilters: filteredQuery,
      page: followingCurrentPage.value + 1,
    );
    followingListLoading.value = true;
    if (snap.isLastPage) {
      followingPostListLastPage.value = true;
    }
    followingPostList.addAll(snap.posts);
    followingCurrentPage.value++;
  }

  //business hours and menu group -------------------------------------------------

  bool confirmMenuItemInCurrentMenuGroup(String menuGroup) {
    String menuGroup0 = checkCurrentMenuGroup(restaurantData.value);
    if (menuGroup != menuGroup0) {
      return false;
    } else {
      return true;
    }
  }

  String checkCurrentMenuGroup(RestaurantAccount restaurantAccount) {
    if (!restaurantAccount.oneSetMenu) {
      final now = DateTime.now();
      final businessHour = restaurantAccount.businessHours![now.weekday - 1];
      if (businessHour.isDinner()) {
        return 'dinner';
      } else {
        return 'lunch';
      }
    } else {
      if (restaurantAccount.lunchMenuCategoryList!.isEmpty) {
        return 'dinner';
      } else {
        return 'lunch';
      }
    }
  }

  void loadCurrentMenuGroup(RestaurantAccount restaurantAccount) {
    currentMenuGroup.value = 'lunch';
    currentMenuGroup.value = checkCurrentMenuGroup(restaurantAccount);
  }

  //init menu items----------------------------------------------------------------
  int loadCurrentMenuCategories(RestaurantAccount restaurantAccount) {
    if (currentMenuGroup.value == 'lunch') {
      return 0;
    } else {
      return 1;
    }
  }

  Future<void> fetchCurrentMenuItems(
    RestaurantAccount restaurantAccount,
  ) async {
    final res = loadCurrentMenuCategories(restaurantAccount);
    if (res == 0) {
      menuCategories.value = restaurantAccount.lunchMenuCategoryList!;
    } else {
      menuCategories.value = restaurantAccount.dinnerMenuCategoryList!;
    }
    await initDishList(restaurantAccount.uid!, res);
  }

  Future<List<RestaurantMenuItem>?> _fetchMenuItems(
    String restaurantId,
    int menuGroup,
  ) async {
    try {
      return await _db
          .collection('restaurant_accounts')
          .doc(restaurantId)
          .collection('menu')
          .where('active', isEqualTo: true)
          .orderBy('ranking')
          .get()
          .then(
            (snap) => snap.docs
                .map((doc) => RestaurantMenuItem.fromFirestore(doc.data()))
                .toList(),
          );
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> initDishList(String restaurantId, int menuGroup) async {
    final res = await _fetchMenuItems(restaurantId, menuGroup);
    if (res != null) {
      if (menuGroup == 0) {
        dishList.value = res
            .where((dish) => dish.menuGroup == 'lunch')
            .toList();
      } else {
        dishList.value = res
            .where((dish) => dish.menuGroup == 'dinner')
            .toList();
      }
    }
  }

  //manually set menu group to view ------------------------------------------------------------
  void manuallySetMenuGroup(int menuGroupIndex) async {
    if (menuGroupIndex == 0) {
      menuCategories.value = restaurantData.value.lunchMenuCategoryList!;
    } else {
      menuCategories.value = restaurantData.value.dinnerMenuCategoryList!;
    }
    await initDishList(restaurantData.value.uid!, menuGroupIndex);
  }

  //stream live order------------------------------------------------------------
  void initBindingLiveOrders(String restaurantUid, String menuGroup) {
    final res = streamLiveOrders(restaurantUid, menuGroup);
    if (res != null) {
      liveOrders.bindStream(res);
    }
  }

  Stream<List<LiveOrder>>? streamLiveOrders(
    String restaurantUid,
    String menuGroup,
  ) {
    final startOfDay = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final endOfDay = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day + 1,
    );
    try {
      return _db
          .collection('restaurant_accounts')
          .doc(restaurantUid)
          .collection('customer_orders')
          .where('orderStatus', whereIn: ['paid', 'ordered'])
          .where('menuGroup', isEqualTo: menuGroup)
          .where('orderTimeStamp', isGreaterThan: startOfDay)
          .where('orderTimeStamp', isLessThan: endOfDay)
          .orderBy('orderTimeStamp', descending: true)
          .snapshots()
          .map((snap) {
            return snap.docs
                .map((doc) => LiveOrder.fromFirestore(doc.data()))
                .toList();
          });
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  //mona posts for a specific menu item----------------------------------------------------
  Future<void> initFetchPostsForMenuItem(
    String restaurantUid,
    String menuItemId,
  ) async {
    var res = await _fetchPostForMenuItem(restaurantUid, menuItemId);
    if (res != null) {
      menuItemShortPosts.value = res;
    }
  }

  Future<List<MonaMenuPost>?> _fetchPostForMenuItem(
    String restaurantUid,
    String menuItemId,
  ) async {
    try {
      return await _db
          .collection('posts')
          .where('restaurantUid', isEqualTo: restaurantUid)
          .where('menuItemId', isEqualTo: menuItemId)
          .orderBy('postedAt', descending: true)
          .limit(30)
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

  //fetch today's orders----------------------------------
  Future<void> initTodayOrders(RestaurantAccount restaurant) async {
    final res = await fetchTodayOrders(restaurant);
    if (res != null) {
      todayOrders.value = res;
    }
  }

  Future<List<CustomerOrder>?> fetchTodayOrders(
    RestaurantAccount restaurant,
  ) async {
    try {
      final startOfDay = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      final endOfDay = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day + 1,
      );
      return await _db
          .collection('restaurant_accounts')
          .doc(restaurant.uid!)
          .collection('customer_orders')
          .where('menuGroup', isEqualTo: checkCurrentMenuGroup(restaurant))
          .where('orderedBy', isEqualTo: _auth.currentUser!.uid)
          .where('orderTimeStamp', isGreaterThan: startOfDay)
          .where('orderTimeStamp', isLessThan: endOfDay)
          .orderBy('orderTimeStamp', descending: true)
          .get()
          .then((snap) {
            if (snap.size > 0) {
              return snap.docs
                  .map((doc) => CustomerOrder.fromFirestore(doc.data()))
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

  //current user post history in restaurant
  Future<void> initCurrentUserPostHistory() async {
    var res = await _fetchingCurrentUserPostHistory();
    if (res != null) {
      currentUserPostHistory.value = res;
    }
  }

  Future<List<MonaMenuPost>?> _fetchingCurrentUserPostHistory() async {
    try {
      return await _db
          .collection('posts')
          .where('restaurantUid', isEqualTo: restaurantUid.value)
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

  //init repeater status --------------------------------------------------------
  Future<void> initCurrentUserRepeaterStatus(String restaurantUid) async {
    try {
      isRepeaterStatus.value = await _fetchCurrentUserRepeaterStatus(
        restaurantUid,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> _fetchCurrentUserRepeaterStatus(String restaurantUid) async {
    try {
      return await _db
          .collection('restaurant_accounts')
          .doc(restaurantUid)
          .collection('repeaters')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((doc) {
            if (doc.data() != null) {
              return doc.data()!['status'];
            } else {
              return '';
            }
          });
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  Future<void> setRepeaterStatus(
    String restaurantUid,
    String status,
    String notifySuccessUpdate,
  ) async {
    try {
      final ref = _db
          .collection('restaurant_accounts')
          .doc(restaurantUid)
          .collection('repeaters')
          .doc(_auth.currentUser!.uid);
      await ref.set({
        'status': status,
        'restaurantUid': restaurantUid,
        'uid': _auth.currentUser!.uid,
        'timestamp': DateTime.now(),
      }, SetOptions(merge: true));
      EasyLoading.showSuccess(notifySuccessUpdate);
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError(tr('An error has occurred'));
    }
  }

  //reset controller variables----------------------------------------------------
  void resetRestaurantControllerVariables() {
    restaurantUid.value = '';
    isRepeaterStatus.value = '';
    currentMenuGroup.value = 'lunch';
    restaurantData.value = RestaurantAccount(
      name: '',
      profileImageUrl: '',
      bgImageUrl: '',
    );
    restaurantTables.clear();
    liveOrders.clear();
    currentUserPostHistory.clear();

    classicMenuItems.clear();
    menuCategories.clear();
    categoryPositionIndex.value = 0;

    dishList.clear();
    menuItemShortPosts.clear();

    todayOrders.clear();

    latestPostList.clear();
    latestFilterCategory.value = '';

    repeaterListLoading.value = false;
    repeaterPostList.clear();
    repeaterList.clear();
    repeaterFilterCategory.value = '';
    repeaterCurrentPage.value = 0;
    repeaterPostListLastPage.value = false;

    followingListLoading.value = false;
    followingPostList.clear();
    followingUserList.clear();
    followingPostListLastPage.value = false;
    followingCurrentPage.value = 0;
    followingFilterCategory.value = '';
  }
}
