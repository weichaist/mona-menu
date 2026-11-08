import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/home_controller.dart';
import 'package:mona_diner/screens/home_screen/components/home_screen_restaurant_card.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = HomeController.instance;
    return DefaultTabController(
      length: HomeScreenTabs.homeTabs.length,
      child: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: StickyTabBarDelegate(
                TabBar(
                  tabs: HomeScreenTabs.homeTabs,
                  isScrollable: true,
                  unselectedLabelColor: Colors.black26,
                  indicatorColor: kPrimaryColor,
                  labelColor: kPrimaryColor,
                  indicator: DotIndicator(
                    distanceFromCenter: 15,
                    color: kPrimaryColor,
                  ),
                  // isScrollable: true,
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            Obx(
              () => RefreshIndicator(
                color: kPrimaryColor,
                onRefresh: () async {
                  await homeController.initFetchAvailableRestaurant();
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 24),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return HomeScreenRestaurantCard(
                      restaurantAcc: homeController.restaurants[index],
                    );
                  },
                  itemCount: homeController.restaurants.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreenTabs {
  static final List<Tab> homeTabs = <Tab>[
    Tab(text: '${tr('Nearby shop')} 🕺🏻'),
    // Tab(
    //   text: 'ただいま人気📈'.tr(),
    // ),
  ];
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(3.0),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
