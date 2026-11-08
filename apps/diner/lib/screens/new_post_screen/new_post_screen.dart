import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/micro_data_controller.dart';
import 'package:mona_diner/controllers/user_post_controller.dart';
import 'package:mona_diner/models/live_order_model.dart';
import 'package:mona_diner/models/restaurant_account_model.dart';
import 'package:mona_diner/screens/new_post_screen/components/new_post_order_history_tile.dart';
import 'package:mona_diner/screens/top_level_components/list/paginated_list_view.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(UserPostController());
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tr('Posted on Mona menu'),
                style: const TextStyle(color: kAppBarTextColor),
              ),
            ],
          ),
        ),
      ),
      body: const Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});
  @override
  Widget build(BuildContext context) {
    final microDataController = MicroDataController.instance;
    final postController = UserPostController.instance;
    postController.initFetchOrderHistory();
    return Obx(() {
      if (postController.orderHistory.isNotEmpty) {
        return PaginatedListView(
          pageSize: 10,
          query: postController.orderHistoryQuery(),
          build: (context, data) {
            LiveOrder order = LiveOrder.fromFirestore(data);
            return FutureBuilder<RestaurantAccount?>(
              future: microDataController.fetchRestaurantAccountData(
                order.restaurantUid!,
              ),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? NewPostOrderHistoryTile(
                        liveOrder: order,
                        restaurantAcc: snapshot.data!,
                      )
                    : NewPostOrderHistoryTile(
                        liveOrder: order,
                        restaurantAcc: microDataController.restaurantAcc.value,
                      );
              },
            );
          },
        );
      } else {
        return Center(
          child: Text(
            tr('First, let\'s order with Mona Menu!'),
            style: const TextStyle(color: kPrimaryColor),
          ),
        );
      }
    });
  }
}
