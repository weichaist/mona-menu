import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/micro_data_controller.dart';
import 'package:mona_console/controllers/post_controller.dart';
import 'package:mona_console/models/m_user_model.dart';
import 'package:mona_console/models/mona_menu_post_model.dart';
import 'package:mona_console/screens/gallery_screen/photo_gallery_screen.dart';
import 'package:mona_console/screens/home_screen/components/view_order_card_profile_tile.dart';
import 'package:mona_console/top_level_components/buttons/icon_text_button_with_counter.dart';
import 'package:mona_console/top_level_components/cards/overview_card.dart';
import 'package:mona_console/top_level_components/custom_list/paginated_list_view.dart';
import 'package:mona_console/top_level_components/utils/empty_list.dart';
import 'package:mona_console/top_level_components/utils/sticky_tab_bar_delegate.dart';
import 'package:intl/intl.dart';

class PostSection extends StatefulWidget {
  const PostSection({super.key});

  @override
  State<PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<PostSection> {
  final List<Tab> _tabs = <Tab>[const Tab(text: '最新投稿')];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  height: 120,
                  padding: const EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 18,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: OverviewCard(
                          topWidget: const Text('Monaメニュー投稿数'),
                          bottomWidget: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: '--',
                                  style: TextStyle(
                                    color: kRestaurantColor,
                                    fontSize: 27,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: OverviewCard(
                          topWidget: const Text('Monaメニュー投稿ユーザー数'),
                          bottomWidget: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: '--',
                                  style: TextStyle(
                                    color: kRestaurantColor,
                                    fontSize: 27,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: StickyTabBarDelegate(
                TabBar(
                  tabs: _tabs,
                  unselectedLabelColor: Colors.black26,
                  indicatorColor: kRestaurantColor,
                  labelColor: kRestaurantColor,
                  // isScrollable: true,
                ),
              ),
            ),
          ];
        },
        body: const TabBarView(children: [PaginatedPostList()]),
      ),
    );
  }
}

class PaginatedPostList extends StatelessWidget {
  const PaginatedPostList({super.key});

  @override
  Widget build(BuildContext context) {
    final postController = PostController.instance;
    postController.initFetchMonaMenuPosts();
    final microDataController = MicroDataController.instance;
    return Obx(() {
      if (postController.posts.isNotEmpty) {
        return PaginatedListView(
          query: postController.monaPostQuery(),
          pageSize: 15,
          build: (context, data) {
            final monaMenuPost = MonaMenuPost.fromFirestore(data);
            return Column(
              children: [
                ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        monaMenuPost.menuItemName!,
                        style: const TextStyle(
                          color: kRestaurantColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        monaMenuPost.userComment!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat(
                          'yyyy-MM-dd HH:mm:ss',
                        ).format(monaMenuPost.postedAt!),
                        style: const TextStyle(color: kAppBarColor),
                      ),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconTextButtonWithCounter(
                              icon: CupertinoIcons.money_yen_circle,
                              onTap: () {},
                              label: '購入された',
                            ),
                            IconTextButtonWithCounter(
                              icon: CupertinoIcons.number_circle,
                              onTap: () {},
                              label: '投稿観覧',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  title: FutureBuilder(
                    future: Future.wait([
                      microDataController.fetchAccountUserData(
                        monaMenuPost.postedBy!,
                      ),
                      microDataController.fetchUserBadges(
                        monaMenuPost.postedBy!,
                      ),
                    ]),
                    builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.hasData) {
                        final MUser mUser = snapshot.data![0];
                        final badges = snapshot.data![1];
                        return GestureDetector(
                          onTap: () {
                            // widget.onTapProfile(_mUser);
                          },
                          child: MonaMenuCardProfileTile(
                            mUser: mUser,
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
                  trailing: monaMenuPost.userImages!.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            Get.to(
                              () => PhotoGalleryScreen(
                                imageUrls: monaMenuPost.userImages!,
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                CupertinoIcons.photo_on_rectangle,
                                size: 24,
                                color: kPrimaryColor,
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
                const Divider(height: 0, color: kRestaurantColor),
              ],
            );
          },
        );
      } else {
        return const EmptyList(
          assetPath: 'assets/images/trust.svg',
          label: 'お客さんに声をかけてみましょう！',
        );
      }
    });
  }
}
