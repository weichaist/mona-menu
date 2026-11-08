import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/customer_controller.dart';
import 'package:mona_console/screens/customer_management_screen/components/applied_customer_list.dart';
import 'package:mona_console/screens/customer_management_screen/components/approved_repeat_customer_list.dart';
import 'package:mona_console/top_level_components/cards/overview_card.dart';
import 'package:mona_console/top_level_components/utils/sticky_tab_bar_delegate.dart';

class Body extends StatelessWidget {
  const Body({super.key});
  @override
  Widget build(BuildContext context) {
    final customerOverViewController = CustomerController.instance;
    customerOverViewController.initFetchingRepeaterApplications();
    final List<Tab> tabs = <Tab>[
      const Tab(text: '申請中リピーター客'),
      const Tab(text: '認定済みリピーター客'),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // AppBarとTabBarの間のコンテンツ
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  height: 120,
                  padding: const EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 18,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OverviewCard(
                          topWidget: const Text('申請中リピーター客'),
                          bottomWidget: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: customerOverViewController
                                      .applications
                                      .length
                                      .toString(),
                                  style: const TextStyle(
                                    color: kRestaurantColor,
                                    fontSize: 27,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: OverviewCard(
                          topWidget: const Text('認定済みリピーター客'),
                          bottomWidget: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: '--',
                                  style: TextStyle(
                                    color: kRestaurantColor,
                                    fontSize: 27,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                    ],
                  ),
                ),
              ]),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: StickyTabBarDelegate(
                TabBar(
                  tabs: tabs,
                  unselectedLabelColor: Colors.black26,
                  indicatorColor: kRestaurantColor,
                  labelColor: kRestaurantColor,
                  // isScrollable: true,
                ),
              ),
            ),
          ];
        },
        body: const TabBarView(
          children: [
            PaginatedAppliedCustomerList(),
            PaginatedApprovedRepeatCustomerList(),
          ],
        ),
      ),
    );
  }
}
