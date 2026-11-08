import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/cart_controller.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/screens/home_screen/components/body.dart';
import 'package:mona_diner/screens/restaurant_screen/components/build_restaurant_info_bottom_sheet.dart';
import 'package:mona_diner/screens/restaurant_screen/components/build_restaurant_option_bottomsheet.dart';
import 'package:mona_diner/screens/restaurant_screen/components/floating_order_confirmation_tile_button.dart';
import 'package:mona_diner/screens/restaurant_screen/components/restaurant_live_order_view.dart';
import 'package:mona_diner/screens/restaurant_screen/restaurant_screen_tabs.dart';
import 'package:mona_diner/screens/restaurant_screen/sub_screens/order_today_screen.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_icon_button.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantController = RestaurantController.instance;
    final cartController = CartController.instance;
    restaurantController.initRestaurantController();
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: DefaultIconButton(
            icon: CupertinoIcons.back,
            onTap: () {
              restaurantController.resetRestaurantControllerVariables();
              cartController.resetController();
              Get.offAndToNamed('/');
            },
            size: 21,
            iconColor: kAppBarTextColor,
          ),
          title: Obx(
            () => GestureDetector(
              onTap: () async {
                if (restaurantController
                    .restaurantData
                    .value
                    .name!
                    .isNotEmpty) {
                  await buildRestaurantInfoBottomSheet();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ProfileAvatarContainer(
                    imageUrl: restaurantController
                        .restaurantData
                        .value
                        .profileImageUrl!,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 9.0, right: 6.0),
                      child: Text(
                        restaurantController.restaurantData.value.name!,
                        style: const TextStyle(color: kAppBarTextColor),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                  const Icon(
                    CupertinoIcons.info_circle,
                    size: 21,
                    color: kAppBarTextColor,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            DefaultIconButton(
              icon: Icons.more_horiz_rounded,
              iconColor: kPrimaryColor,
              onTap: () async {
                await buildInRestaurantBottomSheet();
              },
              size: 24,
            ),
          ],
        ),
        body: const Body(),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final restaurantController = RestaurantController.instance;
    return Obx(() {
      if (restaurantController.restaurantData.value.uid != null) {
        restaurantController.initTodayOrders(
          restaurantController.restaurantData.value,
        );
      }
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          DefaultTabController(
            length: RestaurantScreenTabs.tabs.length,
            child: NestedScrollView(
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Stack(
                        children: [
                          const RestaurantLiveOrderView(),
                          Obx(() {
                            if (restaurantController.todayOrders.isNotEmpty) {
                              return Positioned(
                                bottom: 9,
                                right: 9,
                                child: FloatingActionButton(
                                  heroTag: 'orderToday',
                                  onPressed: () {
                                    Get.to(() => const TodayOrdersScreen());
                                  },
                                  backgroundColor: kPrimaryLightColor,
                                  child: badges.Badge(
                                    showBadge: true,
                                    child: const Icon(
                                      Icons.assignment_turned_in_outlined,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),
                        ],
                      ),
                    ]),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: StickyTabBarDelegate(
                      TabBar(
                        tabs: RestaurantScreenTabs.tabs,
                        isScrollable: true,
                        unselectedLabelColor: Colors.black26,
                        indicatorColor: kPrimaryColor,
                        labelColor: kPrimaryColor,
                        // indicatorPadding: EdgeInsets.symmetric(horizontal: 36),
                        // indicatorSize: TabBarIndicatorSize.label,
                        indicator: DotIndicator(
                          color: kPrimaryColor,
                          distanceFromCenter: 18,
                          radius: 3,
                          paintingStyle: PaintingStyle.fill,
                        ),
                        // isScrollable: true,
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: RestaurantScreenTabs.tabViews,
              ),
            ),
          ),
          if (cartController.monaOrdersInCart.isNotEmpty ||
              cartController.ordersInCart.isNotEmpty)
            const SafeArea(child: FloatingOrderConfirmationTileButton()),
        ],
      );
    });
  }
}
