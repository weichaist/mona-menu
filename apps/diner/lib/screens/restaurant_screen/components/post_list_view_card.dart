import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/cart_controller.dart';
import 'package:mona_diner/controllers/micro_data_controller.dart';
import 'package:mona_diner/models/mona_menu_post_model.dart';
import 'package:mona_diner/models/mona_user_model.dart';
import 'package:mona_diner/models/restaurant_menu_item_model.dart';
import 'package:mona_diner/screens/restaurant_screen/components/restaurant_dish_tile.dart';
import 'package:mona_diner/screens/restaurant_screen/sub_screens/creator_in_restaurant_screen.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:mona_diner/screens/top_level_components/counter/icon_text_button_with_counter.dart';
import 'package:mona_diner/screens/top_level_components/screens/photo_gallery_screen.dart';

class PostListViewCard extends StatelessWidget {
  const PostListViewCard({
    super.key,
    required this.monaMenuPost,
    required this.onTap,
    this.mUser,
    this.badges,
    this.menuItem,
  });

  final MonaMenuPost monaMenuPost;
  final MUser? mUser;
  final List<String>? badges;
  final RestaurantMenuItem? menuItem;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    MicroDataController microDataController = MicroDataController.instance;
    final orderInCartController = CartController.instance;
    return GestureDetector(
      onTap: onTap,
      child: Obx(
        () => Container(
          margin: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            color:
                orderInCartController.monaMenuItemExistsInCart(
                  monaMenuPost.postId,
                )
                ? kPrimaryLightColor
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [kDefaultShadow],
          ),
          child: Column(
            children: [
              mUser != null
                  ? GestureDetector(
                      onTap: () {
                        Get.to(
                          () => CreatorInRestaurantScreen(
                            mUser: mUser!,
                            restaurantUid: monaMenuPost.restaurantUid!,
                          ),
                        );
                      },
                      child: MonaMenuCardProfileTile(
                        mUser: mUser!,
                        badges: badges!,
                      ),
                    )
                  : MonaMenuCardProfileTile(
                      mUser: microDataController.mUser.value,
                      badges: const [],
                    ),
              const Divider(color: kPrimaryColor),
              Padding(
                padding: const EdgeInsets.only(
                  left: 9.0,
                  right: 9.0,
                  bottom: 9.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        monaMenuPost.userComment!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        tr('See more'),
                        style: const TextStyle(
                          color: kPrimaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (monaMenuPost.userImages!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 9.0),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                        () => PhotoGalleryScreen(
                          imageUrls: monaMenuPost.userImages!,
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 138,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 9.0),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 135,
                            width: 135,
                            margin: const EdgeInsets.only(right: 9),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9.0),
                              image: DecorationImage(
                                image: NetworkImage(
                                  monaMenuPost.userImages![index],
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        itemCount: monaMenuPost.userImages!.length,
                      ),
                    ),
                  ),
                ),
              menuItem != null
                  ? RestaurantDishTile(
                      restaurantMenuItem: menuItem!,
                      isSelected: orderInCartController
                          .monaMenuItemExistsInCart(monaMenuPost.postId),
                    )
                  : RestaurantDishTile(
                      restaurantMenuItem: microDataController.menuItem.value,
                    ),
              const Divider(height: 0),
              SizedBox(
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconTextButtonWithCounter(
                            size: 12,
                            backgroundColor:
                                orderInCartController.monaMenuItemExistsInCart(
                                  monaMenuPost.postId,
                                )
                                ? kPrimaryLightColor
                                : Colors.white,
                            icon: CupertinoIcons.book,
                            label: tr('Ordered_2'),
                            count: null,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 96,
                      height: 45,
                      decoration: BoxDecoration(
                        color: menuItem != null
                            ? menuItem!.soldOut
                                  ? CupertinoColors.systemGrey
                                  : kPrimaryColor
                            : kPrimaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(9),
                          topLeft: Radius.circular(9),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            menuItem != null
                                ? menuItem!.soldOut
                                      ? tr('Sold out')
                                      : tr('Order')
                                : tr('Order'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MonaMenuCardProfileTile extends StatelessWidget {
  final MUser mUser;
  final List<String> badges;

  const MonaMenuCardProfileTile({
    super.key,
    required this.mUser,
    required this.badges,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      minLeadingWidth: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 9, vertical: 0),
      title: Text(
        mUser.displayName!,
        style: const TextStyle(color: kBodyTextColor),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mUser.bio!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: kBodyTextColor),
          ),
          if (badges.isNotEmpty)
            SizedBox(
              height: 30,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 3),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Chip(
                    visualDensity: const VisualDensity(vertical: -4),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 3),
                    label: Text(
                      badges[index],
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: kPrimaryLightColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 3);
                },
                itemCount: badges.length,
              ),
            ),
        ],
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
