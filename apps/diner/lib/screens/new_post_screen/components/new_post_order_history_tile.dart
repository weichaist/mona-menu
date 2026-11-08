import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/micro_select_order_to_post_data_future.dart';
import 'package:mona_diner/models/live_order_model.dart';
import 'package:mona_diner/models/mona_menu_post_model.dart';
import 'package:mona_diner/models/restaurant_account_model.dart';
import 'package:mona_diner/models/restaurant_menu_item_model.dart';
import 'package:mona_diner/screens/new_post_screen/components/post_restaurant_dish_card.dart';
import 'package:mona_diner/screens/new_post_screen/sub_screens/edit_post_screen.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:intl/intl.dart';

class NewPostOrderHistoryTile extends StatelessWidget {
  final LiveOrder liveOrder;
  final RestaurantAccount restaurantAcc;
  const NewPostOrderHistoryTile({
    super.key,
    required this.liveOrder,
    required this.restaurantAcc,
  });
  @override
  Widget build(BuildContext context) {
    final controller = MicroSelectOrderToPostDataController.instance;
    return Container(
      margin: const EdgeInsets.only(left: 9.0, right: 9.0, bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        boxShadow: const [kDefaultShadow],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileAvatarContainer(
                  imageUrl: restaurantAcc.profileImageUrl!,
                  radius: 45,
                ),
              ],
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurantAcc.name!,
                  style: const TextStyle(color: CupertinoColors.label),
                ),
                Text(
                  restaurantAcc.address!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(color: kAppBarTextColor),
                ),
              ],
            ),
            subtitle: Text(
              DateFormat('yyyy-MM-dd HH:mm').format(liveOrder.orderTimeStamp!),
              style: const TextStyle(
                fontSize: 12,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
                  controller.fetchMonaMenu(liveOrder.menuItemIds![index]),
                  controller.fetchMonaMenuExits(liveOrder.menuItemIds![index]),
                ]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    RestaurantMenuItem menuItem = snapshot.data![0];
                    MonaMenuPost? post = snapshot.data![1];
                    bool postExist = snapshot.data![2];
                    return !menuItem.categories!.contains('サービスチャージ')
                        ? PostRestaurantDishCard(
                            menuItem: menuItem,
                            post: post,
                            onTap: () {
                              Get.to(
                                () => EditPostScreen(
                                  menuItem: menuItem,
                                  post: post,
                                  restaurantUid: liveOrder.restaurantUid!,
                                ),
                                arguments: post,
                              );
                            },
                            isPosted: postExist,
                          )
                        : const SizedBox(height: 0);
                  } else {
                    return PostRestaurantDishCard(
                      menuItem: controller.menuItem.value,
                      onTap: () {},
                      isPosted: false,
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
