import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/micro_data_controller.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/models/mona_menu_post_model.dart';
import 'package:mona_diner/models/mona_user_model.dart';
import 'package:mona_diner/models/restaurant_menu_item_model.dart';
import 'package:mona_diner/screens/restaurant_screen/sub_screens/mona_menu_item_detail_screen.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:mona_diner/screens/top_level_components/shimmer/muted_empty_list_container.dart';
import 'package:mona_diner/screens/top_level_components/shimmer/shimmer_container.dart';
import 'package:timeago/timeago.dart' as timeago;

class MonaMenuItemPostShortList extends StatelessWidget {
  const MonaMenuItemPostShortList({
    super.key,
    required this.restaurantUid,
    required this.menuItem,
  });
  final String restaurantUid;
  final RestaurantMenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    final restaurantController = RestaurantController.instance;
    restaurantController.initFetchPostsForMenuItem(
      restaurantUid,
      menuItem.docId!,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Text(
            tr('Posts for everyone'),
            style: const TextStyle(color: kAppBarTextColor),
          ),
        ),
        Obx(() {
          var posts = restaurantController.menuItemShortPosts;
          return posts.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 108),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return MonaMenuItemPostShortTile(
                      monaMenuPost: posts[index],
                    );
                  },
                )
              : const MutedEmptyListContainer();
        }),
      ],
    );
  }
}

class MonaMenuItemPostShortTile extends StatelessWidget {
  final MonaMenuPost monaMenuPost;
  const MonaMenuItemPostShortTile({super.key, required this.monaMenuPost});

  @override
  Widget build(BuildContext context) {
    MicroDataController microDataController = MicroDataController.instance;
    return FutureBuilder(
      future: Future.wait([
        microDataController.fetchAccountUserData(monaMenuPost.postedBy!),
        microDataController.fetchRestaurantMenuItemData(
          monaMenuPost.restaurantUid!,
          monaMenuPost.menuItemId!,
        ),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const ListTile(title: ShimmerContainer());
        } else {
          MUser? mUser = snapshot.data![0];
          RestaurantMenuItem? menuItem = snapshot.data![1];
          bool hasData() {
            if (mUser != null && menuItem != null) {
              return true;
            } else {
              return false;
            }
          }

          return MonaMenuShortPostContainer(
            mUser: mUser,
            monaMenuPost: monaMenuPost,
            onTap: () {
              if (hasData()) {
                Get.to(
                  () => MonaMenuItemDetailScreen(
                    mUser: mUser!,
                    menuItem: menuItem!,
                    monaMenu: monaMenuPost,
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}

class MonaMenuShortPostContainer extends StatelessWidget {
  const MonaMenuShortPostContainer({
    super.key,
    required this.mUser,
    required this.monaMenuPost,
    required this.onTap,
  });

  final MUser? mUser;
  final MonaMenuPost monaMenuPost;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 9.0),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: Colors.white,
          boxShadow: const [kDefaultShadow],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 9.0),
              child: ProfileAvatarContainer(
                radius: 48,
                imageUrl: mUser != null ? mUser!.profilePictureURL! : '',
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mUser != null
                      ? Text(
                          '${timeago.format(monaMenuPost.postedAt!, locale: 'ja')} ${mUser!.displayName!}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: CupertinoColors.systemGrey,
                          ),
                        )
                      : const Text(''),
                  Text(
                    monaMenuPost.userComment!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: kBodyTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'see more',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: kPrimaryColor,
                        ),
                      ),
                      if (monaMenuPost.userImages!.isNotEmpty)
                        const Icon(
                          CupertinoIcons.photo_on_rectangle,
                          color: kAppBarTextColor,
                          size: 21,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
