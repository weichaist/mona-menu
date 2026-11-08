import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/controllers/micro_data_controller.dart';
import 'package:mona_diner/models/mona_menu_post_model.dart';
import 'package:mona_diner/screens/restaurant_screen/components/post_list_view_card.dart';
import 'package:mona_diner/screens/restaurant_screen/sub_screens/mona_menu_item_detail_screen.dart';

class FutureBuildPostListViewCard extends StatelessWidget {
  final MonaMenuPost post;

  const FutureBuildPostListViewCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final microDataController = MicroDataController.instance;
    return FutureBuilder(
      future: Future.wait([
        //mUser
        microDataController.fetchAccountUserData(post.postedBy!),
        //badges
        microDataController.fetchUserBadges(
          post.restaurantUid!,
          post.postedBy!,
        ),
        //menuItem
        microDataController.fetchRestaurantMenuItemData(
          post.restaurantUid!,
          post.menuItemId!,
        ),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          final mUser = snapshot.data![0];
          final badges = snapshot.data![1];
          final menuItem = snapshot.data![2];
          return PostListViewCard(
            monaMenuPost: post,
            mUser: mUser,
            badges: badges,
            menuItem: menuItem,
            onTap: () {
              Get.to(
                () => MonaMenuItemDetailScreen(
                  mUser: mUser,
                  menuItem: menuItem,
                  monaMenu: post,
                ),
              );
            },
          );
        } else {
          return const SizedBox(height: 0);
        }
      },
    );
  }
}
