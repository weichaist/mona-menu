import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/creator_in_restaurant_controller.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/models/mona_user_model.dart';
import 'package:mona_diner/screens/restaurant_screen/components/future_build_post_list_view_card.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_icon_button.dart';
import 'package:mona_diner/screens/top_level_components/buttons/full_width_icon_text_button.dart';
import 'package:mona_diner/size_config.dart';

class CreatorInRestaurantScreen extends StatelessWidget {
  final MUser mUser;
  final String restaurantUid;
  const CreatorInRestaurantScreen({
    super.key,
    required this.mUser,
    required this.restaurantUid,
  });
  @override
  Widget build(BuildContext context) {
    final creatorInRestaurantController =
        CreatorInRestaurantController.instance;
    final restaurantController = RestaurantController.instance;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: DefaultIconButton(
          icon: CupertinoIcons.back,
          onTap: () {
            creatorInRestaurantController.clearController();
            Get.back();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfileAvatarContainer(
              imageUrl:
                  restaurantController.restaurantData.value.profileImageUrl!,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 9.0, right: 9.0),
                child: Text(
                  restaurantController.restaurantData.value.name!,
                  style: const TextStyle(color: kAppBarTextColor),
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Body(mUser: mUser),
    );
  }
}

class Body extends StatelessWidget {
  final MUser mUser;

  const Body({super.key, required this.mUser});

  @override
  Widget build(BuildContext context) {
    final restaurantController = RestaurantController.instance;
    final creatorInRestaurantController =
        CreatorInRestaurantController.instance;
    creatorInRestaurantController.initController(
      restaurantController.restaurantUid.value,
      mUser.uid!,
    );
    return ListView(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AspectRatio(
              aspectRatio: 3 / 2,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      restaurantController.restaurantData.value.bgImageUrl!,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              height: getScreenWidth() / 3 * 2,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              width: double.infinity,
              color: CupertinoColors.black.withValues(alpha: 0.6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9.0),
                    child: ProfileAvatarContainer(
                      imageUrl: mUser.profilePictureURL!,
                      radius: 60,
                    ),
                  ),
                  Text(
                    mUser.displayName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey6,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    mUser.bio!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CreatorInRestaurantProfileFollowContainer(mUser: mUser),
                ],
              ),
            ),
          ],
        ),
        Obx(() {
          return creatorInRestaurantController.allPostByCreator.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 12.0, bottom: 48),
                  itemCount:
                      creatorInRestaurantController.allPostByCreator.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12);
                  },
                  itemBuilder: (context, index) {
                    final post =
                        creatorInRestaurantController.allPostByCreator[index];
                    return FutureBuildPostListViewCard(post: post);
                  },
                )
              : Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 108, bottom: 12.0),
                        child: SvgPicture.asset(
                          'assets/icons/search.svg',
                          height: 36,
                          colorFilter: const ColorFilter.mode(
                            kPrimaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Text(tr('I haven\'t posted yet')),
                    ],
                  ),
                );
        }),
      ],
    );
  }
}

class CreatorInRestaurantProfileFollowContainer extends StatelessWidget {
  final MUser mUser;
  const CreatorInRestaurantProfileFollowContainer({
    super.key,
    required this.mUser,
  });
  @override
  Widget build(BuildContext context) {
    final restaurantController = RestaurantController.instance;
    final creatorInRestaurantController =
        CreatorInRestaurantController.instance;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Container(
      height: 60,
      margin: const EdgeInsets.only(top: 9.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Text(
                    creatorInRestaurantController.userFollowedByCount
                        .toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    tr('Follower'),
                    style: const TextStyle(color: Colors.white, fontSize: 10.8),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(color: Colors.white, thickness: 1, width: 0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Text(
                    creatorInRestaurantController.userFollowingCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    tr('Following'),
                    style: const TextStyle(color: Colors.white, fontSize: 10.8),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(color: Colors.white, thickness: 1, width: 0),
          Expanded(
            child: Center(
              child: mUser.uid != uid
                  ? Obx(() {
                      bool isFollowing =
                          creatorInRestaurantController.isFollowing.value;
                      return FullWidthIconTextButton(
                        label: isFollowing ? tr('Following') : tr('Follow-up'),
                        labelColor: Colors.white,
                        icon: isFollowing
                            ? CupertinoIcons.person
                            : CupertinoIcons.person_add,
                        iconColor: Colors.white,
                        backgroundColor: Colors.transparent,
                        onTap: () async {
                          await creatorInRestaurantController
                              .updateFollowRelationship(
                                mUser.uid!,
                                !isFollowing,
                              );
                          creatorInRestaurantController.isFollowing.value =
                              !isFollowing;
                          creatorInRestaurantController.initController(
                            restaurantController.restaurantUid.value,
                            mUser.uid!,
                          );
                        },
                      );
                    })
                  : FullWidthIconTextButton(
                      label: 'Me',
                      labelColor: Colors.white,
                      icon: CupertinoIcons.person,
                      iconColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      onTap: () {},
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
