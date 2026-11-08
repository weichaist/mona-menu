import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/cart_controller.dart';
import 'package:mona_diner/controllers/micro_select_order_to_post_data_future.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/models/live_order_model.dart';
import 'package:mona_diner/models/mona_user_model.dart';
import 'package:mona_diner/models/restaurant_menu_item_model.dart';
import 'package:mona_diner/screens/restaurant_screen/components/classic_menu_list_view_card.dart';
import 'package:mona_diner/screens/restaurant_screen/sub_screens/creator_in_restaurant_screen.dart';
import 'package:mona_diner/screens/restaurant_screen/sub_screens/menu_item_detail_screen.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:timeago/timeago.dart' as timeago;

class PurchaseLiveOrderScreen extends StatelessWidget {
  final LiveOrder liveOrder;
  final MUser mUser;
  const PurchaseLiveOrderScreen({
    super.key,
    required this.liveOrder,
    required this.mUser,
  });
  @override
  Widget build(BuildContext context) {
    final restaurantMenuController = RestaurantController.instance;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ProfileAvatarContainer(
              imageUrl: restaurantMenuController
                  .restaurantData
                  .value
                  .profileImageUrl!,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 9.0, right: 6.0),
              child: Text(
                restaurantMenuController.restaurantData.value.name!,
                style: const TextStyle(color: kAppBarTextColor),
              ),
            ),
          ],
        ),
      ),
      body: PurchaseLiveOrderScreenBody(liveOrder: liveOrder, mUser: mUser),
    );
  }
}

class PurchaseLiveOrderScreenBody extends StatelessWidget {
  final LiveOrder liveOrder;
  final MUser mUser;
  const PurchaseLiveOrderScreenBody({
    super.key,
    required this.liveOrder,
    required this.mUser,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final controller = MicroSelectOrderToPostDataController.instance;
    return SingleChildScrollView(
      child: Column(
        children: [
          const Divider(thickness: 1),
          ListTile(
            onTap: () {
              Get.to(
                () => CreatorInRestaurantScreen(
                  mUser: mUser,
                  restaurantUid: liveOrder.restaurantUid!,
                ),
              );
            },
            visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
            title: Text(
              '${timeago.format(liveOrder.orderTimeStamp!, locale: 'ja')} ${mUser.displayName}のご注文 ',
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: const TextStyle(color: kAppBarTextColor),
            ),
            subtitle: Text(
              liveOrder.menuItemTitles!.join('、'),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            minLeadingWidth: 6.0,
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileAvatarContainer(
                  imageUrl: mUser.profilePictureURL!,
                  radius: 48,
                ),
              ],
            ),
          ),
          const Divider(thickness: 1),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: Future.wait([
                  controller.fetchRestaurantMenuItemData(
                    liveOrder.restaurantUid!,
                    liveOrder.menuItemIds![index],
                  ),
                ]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    RestaurantMenuItem menuItem = snapshot.data![0];
                    return !menuItem.categories!.contains('サービスチャージ')
                        ? Obx(
                            () => RestaurantMenuListViewCard(
                              menuItem: menuItem,
                              onTap: () {
                                Get.to(
                                  () =>
                                      MenuItemDetailScreen(menuItem: menuItem),
                                );
                              },
                              addedToCart: cartController.menuItemExistsInCart(
                                menuItem.docId,
                              ),
                            ),
                          )
                        : const SizedBox(height: 0);
                  } else {
                    return RestaurantMenuListViewCard(
                      menuItem: controller.menuItem.value,
                      onTap: () {},
                      addedToCart: false,
                    );
                  }
                },
              );
            },
            itemCount: liveOrder.menuItemIds!.length,
          ),
        ],
      ),
    );
  }
}
