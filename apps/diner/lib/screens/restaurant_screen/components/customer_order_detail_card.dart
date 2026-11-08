import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/micro_data_controller.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/models/customer_order_model.dart';
import 'package:mona_diner/models/menu_item_in_order_model.dart';
import 'package:mona_diner/models/mona_user_model.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:mona_diner/screens/top_level_components/money/jpy_text.dart';
import 'package:mona_diner/screens/top_level_components/shimmer/shimmer_container.dart';

class OrderDetailCard extends StatelessWidget {
  const OrderDetailCard({super.key, required this.order});
  final CustomerOrder order;

  @override
  Widget build(BuildContext context) {
    final microDataController = MicroDataController.instance;
    final restaurantController = RestaurantController.instance;
    return Container(
      margin: const EdgeInsets.only(left: 9, right: 9, bottom: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [kDefaultShadow],
      ),
      child: Column(
        children: [
          ListTile(
            dense: true,
            title: Text(
              '${tr('Order Number')}: ${order.orderId!.substring(0, 4)}',
            ),
            subtitle: Text(
              order.orderTimeStamp!.toIso8601String().split('.')[0],
            ),
            leading: Text(
              order.tableId!,
              style: const TextStyle(
                fontSize: 15,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: buildTrailingChip(order.status!),
          ),
          const Divider(height: 0, thickness: 0.3, color: kPrimaryColor),
          FutureBuilder<List<MenuItemInOrder>?>(
            future: microDataController.fetchMenuItemsInOrder(
              restaurantController.restaurantData.value.uid!,
              order.orderId!,
            ),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                List<MenuItemInOrder> menuItems = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 9.0),
                  itemBuilder: (context, index) {
                    final menuItem = menuItems[index];
                    return Column(
                      children: [
                        if (menuItem.affiliateUserUid != null)
                          FutureBuilder<MUser?>(
                            future: microDataController.fetchAccountUserData(
                              menuItem.affiliateUserUid!,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                final mUser = snapshot.data!;
                                return GestureDetector(
                                  onTap: () {
                                    // widget.onTapProfile(_mUser);
                                  },
                                  child: ProfileDisplayNameTile(mUser: mUser),
                                );
                              } else {
                                return ProfileDisplayNameTile(
                                  mUser: microDataController.mUser.value,
                                );
                              }
                            },
                          ),
                        ListTile(
                          title: Text(menuItem.menuItemTitle!),
                          subtitle: JPYText(price: menuItem.price!.toInt()),
                          trailing: Text(
                            'x ${menuItem.quantity!.toString()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 0,
                          thickness: 0.3,
                          color: kAppBarTextColor,
                        ),
                      ],
                    );
                  },
                  itemCount: menuItems.length,
                );
              } else {
                return Column(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 9.0),
                      child: ShimmerContainer(height: 54),
                    ),
                    ShimmerContainer(height: 54),
                    ShimmerContainer(height: 54),
                  ],
                );
              }
            },
          ),
          ListTile(
            dense: true,
            title: Text(
              tr('Consumption Tax'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: kBodyTextColor,
              ),
            ),
            trailing: Text('${restaurantController.tax.value * 100.toInt()}%'),
          ),
          ListTile(
            title: Text(tr('Total')),
            trailing: JPYText(price: order.totalPrice!.toInt()),
          ),
        ],
      ),
    );
  }
}

class ProfileDisplayNameTile extends StatelessWidget {
  final MUser mUser;

  const ProfileDisplayNameTile({super.key, required this.mUser});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 9,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
      title: Text(
        mUser.displayName!,
        style: const TextStyle(color: kBodyTextColor),
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProfileAvatarContainer(
            imageUrl: mUser.profilePictureURL!,
            radius: 36,
          ),
        ],
      ),
    );
  }
}

Widget buildTrailingChip(String status) {
  if (status == 'ordered') {
    return const Icon(
      CupertinoIcons.check_mark_circled_solid,
      color: CupertinoColors.systemGrey,
    );
  } else if (status == 'paid') {
    return const Icon(
      CupertinoIcons.check_mark_circled_solid,
      color: CupertinoColors.activeGreen,
    );
  } else if (status == 'canceled') {
    return Chip(
      backgroundColor: kPrimaryLightColor,
      label: Text(tr('Cancel'), style: const TextStyle(color: kPrimaryColor)),
    );
  } else if (status == 'refunded') {
    return Chip(
      backgroundColor: kPrimaryLightColor,
      label: Text(tr('Refunded'), style: const TextStyle(color: kPrimaryColor)),
    );
  } else {
    return const Icon(
      CupertinoIcons.question_circle,
      color: CupertinoColors.systemGrey,
    );
  }
}
