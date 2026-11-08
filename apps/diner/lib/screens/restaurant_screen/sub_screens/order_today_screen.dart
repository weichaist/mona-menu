import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/screens/restaurant_screen/components/customer_order_detail_card.dart';

class TodayOrdersScreen extends StatelessWidget {
  const TodayOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RestaurantController restaurantController = RestaurantController.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('Today\'s order'),
          style: const TextStyle(color: kAppBarTextColor),
        ),
      ),
      body: Obx(
        () => restaurantController.todayOrders.isNotEmpty
            ? RefreshIndicator(
                color: kPrimaryColor,
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 1));
                  await restaurantController.initTodayOrders(
                    restaurantController.restaurantData.value,
                  );
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        itemBuilder: (context, index) {
                          return OrderDetailCard(
                            order: restaurantController.todayOrders[index],
                          );
                        },
                        itemCount: restaurantController.todayOrders.length,
                      ),
                    ],
                  ),
                ),
              )
            : const Center(child: CupertinoActivityIndicator()),
      ),
    );
  }
}
