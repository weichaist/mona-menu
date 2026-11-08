import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/home_controller.dart';
import 'package:mona_console/screens/home_screen/lists/outstanding_order_list.dart';
import 'package:mona_console/screens/home_screen/lists/complete_order_list.dart';
import 'package:mona_console/top_level_components/cards/overview_card.dart';
import 'package:mona_console/top_level_components/utils/sticky_tab_bar_delegate.dart';

class HomeOrderListTabView extends StatefulWidget {
  const HomeOrderListTabView({super.key});

  @override
  State<HomeOrderListTabView> createState() => _HomeOrderListTabViewState();
}

class _HomeOrderListTabViewState extends State<HomeOrderListTabView> {
  final List<Tab> _tabs = <Tab>[
    const Tab(text: '未確定オーダー'),
    const Tab(text: '確定済オーダー'),
  ];
  @override
  Widget build(BuildContext context) {
    final homeController = HomeController.instance;
    return DefaultTabController(
      length: _tabs.length,
      child: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // AppBarとTabBarの間のコンテンツ
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 18,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.chart_bar_square,
                        size: 18,
                        color: kRestaurantColor,
                      ),
                      const SizedBox(width: 9),
                      const Text(
                        '今日 ',
                        style: TextStyle(color: kBodyTextColor, fontSize: 13),
                      ),
                      Text(
                        DateTime.now().toString().substring(0, 10),
                        style: const TextStyle(
                          color: kBodyTextColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 120,
                  padding: const EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 18,
                  ),
                  child: Row(
                    children: [
                      Obx(
                        () => Expanded(
                          child: OverviewCard(
                            topWidget: const Text('売上'),
                            bottomWidget: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: homeController
                                        .calculateTodayRevenue()
                                        .toString()
                                        .toCurrencyString(
                                          mantissaLength: 0,
                                          leadingSymbol: MoneySymbols.YEN_SIGN,
                                        ),
                                    style: const TextStyle(
                                      color: kRestaurantColor,
                                      fontSize: 21,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Obx(
                        () => Expanded(
                          child: OverviewCard(
                            topWidget: const Text('確定オーダー数'),
                            bottomWidget: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: homeController.completeOrders.length
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
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: StickyTabBarDelegate(
                TabBar(
                  tabs: _tabs,
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
          children: [OutstandingOrderList(), CompleteOrderList()],
        ),
      ),
    );
  }
}
