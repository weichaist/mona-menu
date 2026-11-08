import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/micro_data_controller.dart';
import 'package:mona_diner/controllers/profile_controller.dart';
import 'package:mona_diner/models/customer_order_model.dart';
import 'package:mona_diner/models/restaurant_account_model.dart';
import 'package:mona_diner/screens/profile_screen/sub_screens/customer_order_detail_screen.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:mona_diner/screens/top_level_components/list/paginated_list_view.dart';
import 'package:mona_diner/screens/top_level_components/money/jpy_text.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = ProfileController.instance;
    profileController.initFetchingCurrentUserOrderHistory();
    final microDataController = MicroDataController.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('Order History'),
          style: const TextStyle(color: kAppBarTextColor),
        ),
      ),
      body: Obx(() {
        if (profileController.currentUserOrderHistory.isNotEmpty) {
          return PaginatedListView(
            query: profileController.orderHistoryQuery(),
            pageSize: 15,
            build: (context, data) {
              final order = CustomerOrder.fromFirestore(data);
              return FutureBuilder<RestaurantAccount?>(
                future: microDataController.fetchRestaurantAccountData(
                  order.restaurantUid!,
                ),
                builder: (context, snapshot) {
                  var restaurant = snapshot.data;
                  return restaurant != null
                      ? OrderHistoryTile(
                          customerOrder: order,
                          restaurantAccount: restaurant,
                        )
                      : OrderHistoryTile(
                          customerOrder: order,
                          restaurantAccount:
                              microDataController.restaurantAcc.value,
                        );
                },
              );
            },
          );
        } else {
          return Center(
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              height: 36,
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
          );
        }
      }),
    );
  }
}

class OrderHistoryTile extends StatelessWidget {
  const OrderHistoryTile({
    super.key,
    required this.customerOrder,
    required this.restaurantAccount,
  });
  final CustomerOrder customerOrder;
  final RestaurantAccount restaurantAccount;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.to(
              () => CustomerOrderDetailScreen(
                customerOrder: customerOrder,
                restaurantAccount: restaurantAccount,
              ),
            );
          },
          splashColor: kPrimaryLightColor,
          highlightColor: kPrimaryLightColor,
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileAvatarContainer(
                  imageUrl: restaurantAccount.profileImageUrl!,
                  radius: 45,
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [JPYText(price: customerOrder.totalPrice!.toInt())],
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurantAccount.name!,
                  style: const TextStyle(color: CupertinoColors.label),
                ),
                Text(
                  restaurantAccount.address!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'ID: ${customerOrder.orderId!}',
                  style: const TextStyle(color: kAppBarTextColor, fontSize: 12),
                ),
              ],
            ),
            subtitle: Text(
              DateFormat(
                'yyyy-MM-dd HH:mm',
              ).format(customerOrder.orderTimeStamp!),
              style: const TextStyle(
                fontSize: 12,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Divider(height: 0),
      ],
    );
  }
}
