import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/profile_controller.dart';
import 'package:mona_diner/screens/profile_screen/components/profile_screen_number_status.dart';
import 'package:mona_diner/screens/profile_screen/components/profile_screen_setting_tile.dart';
import 'package:mona_diner/screens/profile_screen/sub_screens/edit_bank_account_screen.dart';
import 'package:mona_diner/screens/profile_screen/sub_screens/edit_credit_card_screen.dart';
import 'package:mona_diner/screens/profile_screen/sub_screens/edit_profile_screen.dart';
import 'package:mona_diner/screens/profile_screen/sub_screens/followed_by_user_screen.dart';
import 'package:mona_diner/screens/profile_screen/sub_screens/following_user_screen.dart';
import 'package:mona_diner/screens/profile_screen/sub_screens/order_history_screen.dart';
import 'package:mona_diner/screens/profile_screen/sub_screens/post_history_screen.dart';
import 'package:mona_diner/screens/profile_screen/sub_screens/reward_history_screen.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_icon_button.dart';
import 'package:mona_diner/screens/top_level_components/money/to_jpy_string.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final profileController = ProfileController.instance;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.0),
              child: Icon(CupertinoIcons.lock_circle, color: kAppBarTextColor),
            ),
            Text(
              profileController.mUser.value.displayName!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kAppBarTextColor,
              ),
            ),
            const Spacer(),
            DefaultIconButton(
              onTap: () {
                Get.to(() => const EditProfileScreen());
              },
              icon: CupertinoIcons.pencil,
              size: 18,
            ),
          ],
        ),
      ),
      body: const Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = ProfileController.instance;
    profileController.initFetchingCurrentUserPostHistory();
    profileController.initFollowingCount();
    return SafeArea(
      child: RefreshIndicator(
        color: kPrimaryColor,
        onRefresh: () async {
          await profileController.initFetchingCurrentUserPostHistory();
          await profileController.initFollowingCount();
          Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 150),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 9,
                      horizontal: 18,
                    ),
                    child: Row(
                      children: [
                        ProfileAvatarContainer(
                          radius: 84,
                          imageUrl:
                              profileController.mUser.value.profilePictureURL!,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${profileController.mUser.value.firstName!} ${profileController.mUser.value.lastName!}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  profileController.mUser.value.bio!,
                                  maxLines: 5,
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(color: kBodyTextColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    boxShadow: const [kDefaultShadow],
                    color: CupertinoColors.white,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Obx(
                              () => ProfileScreenNumberStatus(
                                topNumber: profileController
                                    .currentUserPostHistory
                                    .length
                                    .toString(),
                                bottomDescription: tr('Number of posts'),
                                onTap: () {
                                  Get.to(() => const PostHistoryScreen());
                                },
                              ),
                            ),
                            const VerticalDivider(
                              indent: 15.0,
                              endIndent: 15.0,
                              thickness: 1.5,
                            ),
                            ProfileScreenNumberStatus(
                              topNumber: toJPYString(0),
                              bottomDescription: tr('This month\'s reward'),
                              onTap: () {
                                Get.to(() => const RewardHistoryScreen());
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 0, thickness: 0.3),
                      Obx(
                        () => Expanded(
                          child: Row(
                            children: [
                              ProfileScreenNumberStatus(
                                topNumber: profileController
                                    .userFollowedByCount
                                    .value
                                    .toString(),
                                bottomDescription: tr('Follower'),
                                onTap: () {
                                  Get.to(() => const FollowedByUserScreen());
                                },
                              ),
                              const VerticalDivider(
                                indent: 15.0,
                                endIndent: 15.0,
                                thickness: 1.5,
                              ),
                              ProfileScreenNumberStatus(
                                topNumber: profileController
                                    .userFollowingCount
                                    .value
                                    .toString(),
                                bottomDescription: tr('Following'),
                                onTap: () {
                                  Get.to(() => const FollowingUserScreen());
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 9.0,
                    vertical: 9.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    boxShadow: const [kDefaultShadow],
                    color: CupertinoColors.white,
                  ),
                  child: Column(
                    children: [
                      ProfileScreenCustomTile(
                        leadingIcon: const Icon(
                          Icons.history_rounded,
                          color: kPrimaryColor,
                        ),
                        title: tr('Order History'),
                        onTap: () {
                          Get.to(() => const OrderHistoryScreen());
                        },
                      ),
                      const Divider(height: 0, thickness: 0.9),
                      ProfileScreenCustomTile(
                        leadingIcon: const Icon(
                          CupertinoIcons.person_2,
                          color: kPrimaryColor,
                        ),
                        title: tr('Reward History'),
                        onTap: () {
                          Get.to(() => const RewardHistoryScreen());
                        },
                      ),
                      const Divider(height: 0, thickness: 0.9),
                      ProfileScreenCustomTile(
                        leadingIcon: const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: kPrimaryColor,
                        ),
                        title: tr('Method of payment'),
                        onTap: () {
                          Get.to(() => const EditCreditCardScreen());
                        },
                      ),
                      const Divider(height: 0, thickness: 0.9),
                      ProfileScreenCustomTile(
                        leadingIcon: const Icon(
                          Icons.monetization_on_outlined,
                          color: kPrimaryColor,
                        ),
                        title: tr('How to receive rewards'),
                        onTap: () {
                          Get.to(() => const EditBankAccountScreen());
                        },
                      ),
                      const Divider(height: 0, thickness: 0.9),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
