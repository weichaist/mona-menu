import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/micro_data_controller.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/models/live_order_model.dart';
import 'package:mona_diner/models/mona_user_model.dart';
import 'package:mona_diner/screens/restaurant_screen/sub_screens/purchase_live_order_screen.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:mona_diner/size_config.dart';
import 'package:timeago/timeago.dart' as timeago;

class RestaurantLiveOrderView extends StatelessWidget {
  const RestaurantLiveOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantController = RestaurantController.instance;
    MicroDataController microDataController = MicroDataController.instance;
    return Obx(
      () => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child:
                restaurantController.restaurantData.value.bgImageUrl!.isNotEmpty
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          restaurantController.restaurantData.value.bgImageUrl!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : const Center(child: CupertinoActivityIndicator()),
          ),
          if (restaurantController.liveOrders.isNotEmpty)
            Container(
              height: getScreenWidth() / 16 * 9,
              color: CupertinoColors.black.withValues(alpha: 0.5),
              child: RefreshIndicator(
                color: kPrimaryColor,
                onRefresh: () async {
                  restaurantController.initBindingLiveOrders(
                    restaurantController.restaurantData.value.uid!,
                    restaurantController.currentMenuGroup.value,
                  );
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  itemBuilder: (context, index) {
                    final order = restaurantController.liveOrders[index];
                    return FutureBuilder<MUser?>(
                      future: microDataController.fetchAccountUserData(
                        order.orderedBy!,
                      ),
                      builder: (context, snapshot) {
                        var mUser = snapshot.data;
                        return mUser != null
                            ? LiveOrderCustomTile(
                                mUser: mUser,
                                liveOrder: order,
                              )
                            : LiveOrderCustomTile(
                                mUser: MUser(
                                  displayName: '',
                                  profilePictureURL: '',
                                ),
                                liveOrder: order,
                              );
                      },
                    );
                  },
                  itemCount: restaurantController.liveOrders.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class LiveOrderCustomTile extends StatelessWidget {
  final MUser mUser;
  final LiveOrder liveOrder;
  const LiveOrderCustomTile({
    super.key,
    required this.mUser,
    required this.liveOrder,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(
          () => PurchaseLiveOrderScreen(liveOrder: liveOrder, mUser: mUser),
        );
      },
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      title: Text(
        '${timeago.format(liveOrder.orderTimeStamp!, locale: 'ja')} ${mUser.displayName}${tr('Order')}',
        maxLines: 1,
        overflow: TextOverflow.fade,
        style: const TextStyle(color: CupertinoColors.systemGrey3),
      ),
      subtitle: Text(
        liveOrder.menuItemTitles!.join('、'),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: CupertinoColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      minLeadingWidth: 6.0,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProfileAvatarContainer(
            imageUrl: mUser.profilePictureURL!,
            radius: 30,
          ),
        ],
      ),
    );
  }
}
