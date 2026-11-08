import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/micro_data_controller.dart';
import 'package:mona_diner/models/customer_order_model.dart';
import 'package:mona_diner/models/menu_item_in_order_model.dart';
import 'package:mona_diner/models/mona_user_model.dart';
import 'package:mona_diner/models/restaurant_account_model.dart';
import 'package:mona_diner/screens/restaurant_screen/components/customer_order_detail_card.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:mona_diner/screens/top_level_components/money/jpy_text.dart';
import 'package:mona_diner/screens/top_level_components/shimmer/shimmer_container.dart';

class CustomerOrderDetailScreen extends StatelessWidget {
  const CustomerOrderDetailScreen({
    super.key,
    required this.restaurantAccount,
    required this.customerOrder,
  });
  final RestaurantAccount restaurantAccount;
  final CustomerOrder customerOrder;
  @override
  Widget build(BuildContext context) {
    final microDataController = MicroDataController.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('Order Number:') + customerOrder.orderId!,
          style: const TextStyle(color: kAppBarTextColor, fontSize: 12),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                dense: true,
                title: Text(
                  DateFormat(
                    'yyyy-MM-dd HH:mm',
                  ).format(customerOrder.orderTimeStamp!),
                  style: const TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 12,
                  ),
                ),
              ),
              ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProfileAvatarContainer(
                      imageUrl: restaurantAccount.profileImageUrl!,
                      radius: 45,
                    ),
                  ],
                ),
                title: Text(restaurantAccount.name!),
                subtitle: Text(
                  restaurantAccount.address!,
                  style: const TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 12,
                  ),
                ),
              ),
              ListTile(
                leading: Text(tr('Order Status')),
                title: Row(
                  children: [
                    Chip(
                      label: Text(
                        _statusJPN(customerOrder.status!),
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Text(tr('Total (Tax Included)')),
                title: JPYText(price: customerOrder.totalPrice!.toInt()),
              ),
              ListTile(
                dense: true,
                leading: const Icon(CupertinoIcons.bag, color: kPrimaryColor),
                title: Text(
                  tr('Ordered Product'),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              FutureBuilder<List<MenuItemInOrder>?>(
                future: microDataController.fetchMenuItemsInOrder(
                  restaurantAccount.uid!,
                  customerOrder.orderId!,
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
                                future: microDataController
                                    .fetchAccountUserData(
                                      menuItem.affiliateUserUid!,
                                    ),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    final mUser = snapshot.data!;
                                    return GestureDetector(
                                      onTap: () {
                                        // widget.onTapProfile(_mUser);
                                      },
                                      child: ProfileDisplayNameTile(
                                        mUser: mUser,
                                      ),
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
                leading: Text(tr('Payment Details')),
                title: Text(
                  customerOrder.paymentMethod ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      height: 201,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(restaurantAccount.bgImageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      height: 201,
                      color: CupertinoColors.black.withValues(alpha: 0.5),
                      child: Center(
                        child: Text(
                          tr('Thank you for your order!'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _statusJPN(String status) {
  String msg;

  if (status == 'ordered') {
    msg = tr('Ordered');
  } else if (status == 'paid') {
    // 入力されたメールアドレスが登録されていない場合
    msg = tr('Paid');
  } else if (status == 'canceled') {
    // 入力されたパスワードが間違っている場合
    msg = tr('Cancel');
  } else if (status == 'refunded') {
    // メールアドレスかパスワードがEmpty or Nullの場合
    msg = tr('Refunded');
  } else {
    msg = status;
  }

  return msg;
}
