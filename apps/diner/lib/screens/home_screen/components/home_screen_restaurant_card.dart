import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/home_controller.dart';
import 'package:mona_diner/models/restaurant_account_model.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:mona_diner/size_config.dart';

class HomeScreenRestaurantCard extends StatelessWidget {
  final RestaurantAccount restaurantAcc;

  const HomeScreenRestaurantCard({super.key, required this.restaurantAcc});
  @override
  Widget build(BuildContext context) {
    final homeController = HomeController.instance;
    return GestureDetector(
      onTap: () {
        Get.toNamed('/restaurant/${restaurantAcc.uid!}');
      },
      child: Container(
        margin: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: CupertinoColors.white,
          boxShadow: const [kDefaultShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 21 / 10,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(9),
                        topRight: Radius.circular(9),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(restaurantAcc.bgImageUrl!),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 12,
                  child: SizedBox(
                    width: getScreenWidth() / 2,
                    child: Row(
                      children: [
                        Chip(
                          label: Text(
                            homeController.checkBusinessHour(restaurantAcc)
                                ? tr('Open for business')
                                : tr('Outside business hours'),
                            style: const TextStyle(color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          backgroundColor: CupertinoColors.darkBackgroundGray,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: SizedBox(
                    width: getScreenWidth(),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ProfileAvatarContainer(
                              imageUrl: restaurantAcc.profileImageUrl!,
                              radius: 54,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurantAcc.genre!,
                          style: const TextStyle(color: kPrimaryColor),
                        ),
                        Text(
                          restaurantAcc.name!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Text(
                  //   '🚶🏻3分',
                  //   style: TextStyle(),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
