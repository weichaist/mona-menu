import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/micro_data_controller.dart';
import 'package:mona_diner/controllers/profile_controller.dart';
import 'package:mona_diner/controllers/user_post_controller.dart';
import 'package:mona_diner/models/mona_menu_post_model.dart';
import 'package:mona_diner/models/restaurant_menu_item_model.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_icon_button.dart';
import 'package:mona_diner/screens/top_level_components/list/paginated_list_view.dart';
import 'package:mona_diner/screens/top_level_components/snackbar_dialog_bottomsheet/build_confirmation_dialog.dart';

class PostHistoryScreen extends StatelessWidget {
  const PostHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final profileController = ProfileController.instance;
    final microDataController = MicroDataController.instance;
    final postController = UserPostController.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('Posting History'),
          style: const TextStyle(color: kAppBarTextColor),
        ),
      ),
      body: Obx(() {
        if (profileController.currentUserPostHistory.isNotEmpty) {
          return PaginatedListView(
            query: profileController.postHistoryPost(),
            pageSize: 15,
            build: (context, data) {
              final post = MonaMenuPost.fromFirestore(data);
              return FutureBuilder<RestaurantMenuItem?>(
                future: microDataController.fetchRestaurantMenuItemData(
                  post.restaurantUid!,
                  post.menuItemId!,
                ),
                builder: (context, snapshot) {
                  var menuItem = snapshot.data;
                  return menuItem != null
                      ? Column(
                          children: [
                            ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ProfileAvatarContainer(
                                    imageUrl: menuItem.imageUrl!,
                                    radius: 54,
                                  ),
                                ],
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(menuItem.title!),
                                  Text(
                                    DateFormat(
                                      'yyyy-MM-dd HH:mm',
                                    ).format(post.postedAt!),
                                    style: const TextStyle(
                                      color: kAppBarTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                post.userComment!,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DefaultIconButton(
                                    icon: CupertinoIcons.delete,
                                    size: 21,
                                    onTap: () async {
                                      final res =
                                          await buildConfirmationDialog();
                                      if (res ?? false) {
                                        await profileController
                                            .updatePostStatus(post.postId!);
                                        await profileController
                                            .initFetchingCurrentUserPostHistory();
                                        postController.orderHistory.clear();
                                        await postController
                                            .initFetchOrderHistory();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 0),
                          ],
                        )
                      : const SizedBox(height: 0);
                },
              );
            },
          );
        } else {
          return Center(
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              height: 36,
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
          );
        }
      }),
    );
  }
}
