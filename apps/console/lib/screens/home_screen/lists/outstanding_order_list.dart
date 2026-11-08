import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/home_controller.dart';
import 'package:mona_console/controllers/micro_data_controller.dart';
import 'package:mona_console/models/customer_order_model.dart';
import 'package:mona_console/models/m_user_model.dart';
import 'package:mona_console/screens/home_screen/components/customer_order_list_view_tile.dart';

class OutstandingOrderList extends StatelessWidget {
  const OutstandingOrderList({super.key});
  @override
  Widget build(BuildContext context) {
    MicroDataController microDataController = MicroDataController.instance;
    HomeController homeController = HomeController.instance;
    return Obx(() {
      final orders = homeController.outstandingOrders;
      if (orders.isNotEmpty) {
        return RefreshIndicator(
          color: kRestaurantColor,
          onRefresh: () async {
            homeController.initBindingTodayOrders();
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            itemBuilder: (context, index) {
              CustomerOrder order = orders[index];
              return FutureBuilder<MUser?>(
                future: microDataController.fetchAccountUserData(
                  order.orderedBy!,
                ),
                builder: (context, snapshot) {
                  var mUser = snapshot.data;
                  return mUser != null
                      ? Obx(
                          () => LiveOrderCustomTile(
                            mUser: mUser,
                            customerOrder: order,
                            isSelected:
                                homeController
                                    .customerOrderOnDisplay
                                    .value
                                    .orderId ==
                                order.orderId,
                            onTap: () {
                              homeController.changeOrderOnDisplay(order);
                            },
                          ),
                        )
                      : LiveOrderCustomTile(
                          mUser: microDataController.mUser.value,
                          customerOrder: order,
                          onTap: () {},
                        );
                },
              );
            },
            itemCount: homeController.outstandingOrders.length,
          ),
        );
      } else {
        return const SizedBox(
          height: 150,
          child: Center(
            child: Text(
              'みんなの注文を待ちましょう！',
              style: TextStyle(color: kRestaurantColor),
            ),
          ),
        );
      }
    });
  }
}
