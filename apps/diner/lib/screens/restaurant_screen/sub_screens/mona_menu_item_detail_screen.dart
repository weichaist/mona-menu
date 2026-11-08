import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/cart_controller.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/models/mona_menu_post_model.dart';
import 'package:mona_diner/models/mona_user_model.dart';
import 'package:mona_diner/models/restaurant_menu_item_model.dart';
import 'package:mona_diner/models/temp_mona_menu_item_model.dart';
import 'package:mona_diner/screens/restaurant_screen/components/cart_management_tile.dart';
import 'package:mona_diner/screens/restaurant_screen/components/floating_order_confirmation_tile_button.dart';
import 'package:mona_diner/screens/restaurant_screen/sub_screens/creator_in_restaurant_screen.dart';
import 'package:mona_diner/screens/restaurant_screen/sub_screens/menu_item_detail_screen.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:mona_diner/screens/top_level_components/money/jpy_text.dart';
import 'package:mona_diner/screens/top_level_components/screens/photo_gallery_screen.dart';
import 'package:mona_diner/screens/top_level_components/snackbar_dialog_bottomsheet/build_report_content_bottom_sheet.dart';
import 'package:mona_diner/size_config.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_get_snackbar.dart';

class MonaMenuItemDetailScreen extends StatelessWidget {
  final MonaMenuPost monaMenu;
  final RestaurantMenuItem menuItem;
  final MUser mUser;
  const MonaMenuItemDetailScreen({
    super.key,
    required this.menuItem,
    required this.mUser,
    required this.monaMenu,
  });

  @override
  Widget build(BuildContext context) {
    final restaurantMenuController = RestaurantController.instance;
    final orderInCartController = CartController.instance;
    return Obx(
      () => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(
                restaurantMenuController.restaurantData.value.name!,
                style: const TextStyle(color: kAppBarTextColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 9.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [JPYText(price: menuItem.price!, fontSize: 17.7)],
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                width: getScreenWidth(),
                child: Column(
                  children: [
                    Hero(
                      tag: menuItem.imageUrl! + monaMenu.postId!,
                      child: Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(menuItem.imageUrl!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: getScreenWidth() / 4 * 3,
                            width: getScreenWidth(),
                            color: CupertinoColors.black.withValues(
                              alpha: 0.57,
                            ),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(
                                top: 18,
                                left: 12,
                                right: 12,
                              ),
                              child: Column(
                                children: [
                                  ProfileAvatarContainer(
                                    imageUrl: mUser.profilePictureURL!,
                                    radius: 36,
                                  ),
                                  Text(
                                    mUser.displayName!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Text(
                                      '" ${monaMenu.userComment!} "',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (monaMenu.userImages!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12.0,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => PhotoGalleryScreen(
                                              imageUrls: monaMenu.userImages!,
                                            ),
                                          );
                                        },
                                        child: SizedBox(
                                          height: 138,
                                          child: ListView.builder(
                                            // padding: EdgeInsets.symmetric(horizontal: 9.0),
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                height: 135,
                                                width: 135,
                                                margin: const EdgeInsets.only(
                                                  right: 9,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        9.0,
                                                      ),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      monaMenu
                                                          .userImages![index],
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            },
                                            itemCount:
                                                monaMenu.userImages!.length,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => MenuItemDetailScreen(menuItem: menuItem));
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 3.0,
                                    ),
                                    child: Text(
                                      menuItem.title!,
                                      style: const TextStyle(
                                        fontSize: 17.7,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    menuItem.description!,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      minLeadingWidth: 12,
                      leading: const Icon(CupertinoIcons.flag_circle),
                      title: Text(
                        tr('report'),
                        style: const TextStyle(color: kAppBarTextColor),
                      ),
                      onTap: () {
                        buildReportContentBottomSheet('post', monaMenu.postId!);
                      },
                    ),
                    const Divider(thickness: 0.5),
                    MonaCartManagementTile(
                      tempMenuItem: TempMonaMenuItem.fromMonaMenu(
                        monaMenu,
                        menuItem,
                      ),
                      mUser: mUser,
                    ),
                    const Divider(thickness: 0.5),
                    ListTile(
                      onTap: () {
                        Get.to(
                          () => CreatorInRestaurantScreen(
                            mUser: mUser,
                            restaurantUid: monaMenu.restaurantUid!,
                          ),
                        );
                      },
                      leading: ProfileAvatarContainer(
                        imageUrl: mUser.profilePictureURL!,
                        radius: 36,
                      ),
                      title: Text(
                        mUser.displayName!,
                        style: const TextStyle(color: kBodyTextColor),
                      ),
                      subtitle: Text(
                        tr('Display the posted menu'),
                        style: const TextStyle(color: kPrimaryColor),
                      ),
                    ),
                    const Divider(thickness: 0.5),
                  ],
                ),
              ),
            ),
          ),
          if (orderInCartController.monaOrdersInCart.isNotEmpty ||
              orderInCartController.ordersInCart.isNotEmpty)
            const SafeArea(child: FloatingOrderConfirmationTileButton()),
        ],
      ),
    );
  }
}

class MonaCartManagementTile extends StatelessWidget {
  const MonaCartManagementTile({
    super.key,
    required this.tempMenuItem,
    required this.mUser,
  });
  final TempMonaMenuItem tempMenuItem;
  final MUser mUser;
  @override
  Widget build(BuildContext context) {
    final orderInCartController = CartController.instance;
    final restaurantController = RestaurantController.instance;
    return Obx(
      () => orderInCartController.monaMenuItemExistsInCart(tempMenuItem.postId)
          ? SettingTileWithToggleSwitch(
              title:
                  '${tr('Quantity')}: ${orderInCartController.monaOrderCountInCart(tempMenuItem.postId)}',
              labels: const ['+', '-'],
              initLabelIndex: 0,
              onToggle: (index) async {
                if (index != null) {
                  final soldOut = tempMenuItem.soldOut;
                  if (!soldOut) {
                    orderInCartController.updateMonaOrderCountInCart(
                      tempMenuItem.postId!,
                      index,
                    );
                  } else {
                    buildGetSnackbar(
                      tr('The food is sold out.'),
                      tr('Sold out'),
                    );
                    orderInCartController.removeSoldOutMenuItems(
                      tempMenuItem.menuItemId!,
                    );
                  }
                }
              },
            )
          : SettingTileWithToggleSwitch(
              title: '${tr('Quantity')}: 0',
              labels: [tr('Add Order')],
              initLabelIndex: 0,
              fontSize: 15,
              onToggle: (index) {
                if (index != null) {
                  bool canOrder =
                      restaurantController.confirmMenuItemInCurrentMenuGroup(
                        tempMenuItem.menuGroup!,
                      ) &&
                      orderInCartController.checkRestaurantOpenStatus(
                        restaurantController.restaurantData.value,
                      );
                  if (canOrder) {
                    final soldOut = tempMenuItem.soldOut;
                    if (!soldOut) {
                      orderInCartController.addMonaMenuOrderToCart(
                        tempMenuItem,
                        mUser,
                      );
                    } else {
                      buildGetSnackbar(
                        tr('The food is sold out.'),
                        tr('Sold out'),
                      );
                    }
                  } else {
                    buildGetSnackbar(
                      tr('I can\'t use it right now.'),
                      '🙅🏻‍♂️',
                    );
                  }
                }
              },
            ),
    );
  }
}
