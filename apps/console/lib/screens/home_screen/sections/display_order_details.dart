import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/home_controller.dart';
import 'package:mona_console/controllers/micro_data_controller.dart';
import 'package:mona_console/models/m_user_model.dart';
import 'package:mona_console/models/menu_item_in_order_model.dart';
import 'package:mona_console/screens/home_screen/components/profile_display_name_tile.dart';
import 'package:mona_console/screens/home_screen/components/view_order_card_profile_tile.dart';
import 'package:mona_console/top_level_components/buttons/primary_full_width_button.dart';
import 'package:mona_console/top_level_components/currency_time_phone/convert_text_to_currency.dart';
import 'package:mona_console/top_level_components/shimmer/shimmer_widgets/shimmer_container.dart';
import 'package:intl/intl.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_confirmation_dialog.dart';

class DisplayOrderDetails extends StatelessWidget {
  const DisplayOrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = HomeController.instance;
    MicroDataController microDataController = MicroDataController.instance;
    return Container(
      margin: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        boxShadow: const [kDefaultShadow],
        color: Colors.white,
      ),
      child: Obx(() {
        final order = homeController.customerOrderOnDisplay.value;
        if (order.orderId!.isEmpty) {
          return Center(
            child: SvgPicture.asset(
              'assets/icons/orders.svg',
              colorFilter: const ColorFilter.mode(
                kRestaurantColor,
                BlendMode.srcIn,
              ),
              height: 66,
            ),
          );
        } else {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              children: [
                ListTile(
                  title: Text('注文番号: ${order.orderId!}'),
                  subtitle: Text(
                    DateFormat(
                      'yyyy-MM-dd HH:mm:ss',
                    ).format(order.orderTimeStamp!),
                  ),
                  leading: Text(
                    order.tableId!,
                    style: const TextStyle(
                      fontSize: 15,
                      color: kRestaurantColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(
                  height: 0,
                  thickness: 0.3,
                  color: kRestaurantColor,
                ),
                FutureBuilder(
                  future: Future.wait([
                    microDataController.fetchAccountUserData(order.orderedBy!),
                    microDataController.fetchUserBadges(order.orderedBy!),
                  ]),
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.hasData) {
                      final mUser = snapshot.data![0];
                      final badges = snapshot.data![1];
                      return GestureDetector(
                        onTap: () {
                          // widget.onTapProfile(_mUser);
                        },
                        child: MonaMenuCardProfileTile(
                          mUser: mUser!,
                          badges: badges,
                        ),
                      );
                    } else {
                      return MonaMenuCardProfileTile(
                        mUser: microDataController.mUser.value,
                        badges: const [],
                      );
                    }
                  },
                ),
                const Divider(
                  height: 0,
                  thickness: 0.3,
                  color: kRestaurantColor,
                ),
                FutureBuilder<List<MenuItemInOrder>?>(
                  future: microDataController.fetchMenuItemsInOrder(
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
                                subtitle: ConvertTextToCurrency(
                                  price: menuItem.price!.toInt(),
                                ),
                                trailing: Text(
                                  'x ${menuItem.quantity!.toString()}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kRestaurantColor,
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 0,
                                thickness: 0.3,
                                color: kAppBarColor,
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
                  title: const Text('合計'),
                  trailing: ConvertTextToCurrency(
                    price: order.totalPrice!.toInt(),
                  ),
                ),
                if (order.status == 'paid')
                  PrimaryFullWidthButton(
                    backgroundColor: CupertinoColors.systemGrey6,
                    centerWidget: const Text(
                      '注文を確認',
                      style: TextStyle(
                        color: kRestaurantColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    height: 54,
                    onTap: () async {
                      await homeController.updateOrderStatus(
                        order.orderId!,
                        'confirmed',
                        '注文を確認しました！',
                      );
                    },
                  )
                else if (order.status == 'confirmed')
                  PrimaryFullWidthButton(
                    centerWidget: const Text(
                      '返金する',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    height: 54,
                    onTap: () async {
                      final res = await buildConfirmationDialog(
                        title: '返金を実行しますか？',
                      );
                      if (res ?? false) {
                        await homeController.refundStripePayment(
                          order.stripeIntent!,
                          order.orderId!,
                          'refunded',
                        );
                      }
                    },
                  )
                else if (order.status == 'refunded')
                  PrimaryFullWidthButton(
                    centerWidget: const Text(
                      '返金済み',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    height: 54,
                    onTap: () async {},
                  )
                else
                  PrimaryFullWidthButton(
                    centerWidget: const Text(
                      '処理中',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    height: 54,
                    onTap: () async {},
                  ),
              ],
            ),
          );
        }
      }),
    );
  }
}
