import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/history_controller.dart';
import 'package:mona_console/controllers/micro_data_controller.dart';
import 'package:mona_console/models/customer_order_model.dart';
import 'package:mona_console/models/m_user_model.dart';
import 'package:mona_console/screens/order_history_screen/components/build_order_details_dialog.dart';
import 'package:mona_console/screens/order_history_screen/components/order_history_custom_tile.dart';
import 'package:mona_console/top_level_components/cards/overview_card.dart';
import 'package:mona_console/top_level_components/custom_list/paginated_list_view.dart';
import 'package:mona_console/top_level_components/utils/sticky_tab_bar_delegate.dart';

class Body extends StatelessWidget {
  const Body({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Tab> tabs = <Tab>[const Tab(text: 'オーダー履歴')];
    final historyController = HistoryController.instance;
    historyController.initFetchingOrderHistory();
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
                  height: 100,
                  padding: const EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 18,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OverviewCard(
                          topWidget: const Text('データ分析ツール（Coming soon）'),
                          bottomWidget: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'データダッシュボードを確認する',
                                  style: TextStyle(
                                    color: kRestaurantColor,
                                    fontSize: 18,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
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
                ),
              ),
            ),
          ];
        },
        body: const TabBarView(children: [PaginatedHistoryList()]),
      ),
    );
  }
}

class PaginatedHistoryList extends StatelessWidget {
  const PaginatedHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final historyController = HistoryController.instance;
    final microDataController = MicroDataController.instance;
    return Obx(() {
      if (historyController.orderHistory.isNotEmpty) {
        return PaginatedListView(
          query: historyController.orderHistoryQuery(),
          pageSize: 15,
          build: (context, data) {
            final order = CustomerOrder.fromFirestore(data);
            return FutureBuilder<MUser?>(
              future: microDataController.fetchAccountUserData(
                order.orderedBy!,
              ),
              builder: (context, snapshot) {
                var mUser = snapshot.data;
                return mUser != null
                    ? OrderHistoryCustomTile(
                        mUser: mUser,
                        customerOrder: order,
                        onTap: () async {
                          await buildOrderDetailDialog(order);
                        },
                      )
                    : OrderHistoryCustomTile(
                        mUser: microDataController.mUser.value,
                        customerOrder: order,
                        onTap: () {},
                      );
              },
            );
          },
        );
      } else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/history.svg',
                colorFilter: const ColorFilter.mode(
                  kRestaurantColor,
                  BlendMode.srcIn,
                ),
                height: 99,
              ),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  'みんなの注文を待ちましょう！',
                  style: TextStyle(color: kRestaurantColor, fontSize: 18),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
