import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/micro_data_controller.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/models/mona_user_model.dart';
import 'package:mona_diner/screens/restaurant_screen/sub_screens/creator_in_restaurant_screen.dart';

class PostHistoryTile extends StatelessWidget {
  const PostHistoryTile({super.key});
  @override
  Widget build(BuildContext context) {
    final restaurantMenuController = RestaurantController.instance;
    restaurantMenuController.initCurrentUserPostHistory();
    MicroDataController microDataController = MicroDataController.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    return FutureBuilder<MUser?>(
      future: microDataController.fetchAccountUserData(auth.currentUser!.uid),
      builder: (context, snapshot) {
        final mUser = snapshot.data;
        return Obx(
          () => ListTile(
            tileColor: Colors.white,
            minLeadingWidth: 18,
            leading: Icon(
              Icons.history,
              color: restaurantMenuController.currentUserPostHistory.isNotEmpty
                  ? kPrimaryColor
                  : kAppBarTextColor,
            ),
            title: Text(
              tr('Posting History'),
              style: TextStyle(
                color:
                    restaurantMenuController.currentUserPostHistory.isNotEmpty
                    ? kPrimaryColor
                    : kAppBarTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              if (restaurantMenuController.currentUserPostHistory.isNotEmpty) {
                if (mUser != null) {
                  Get.to(
                    () => CreatorInRestaurantScreen(
                      mUser: mUser,
                      restaurantUid:
                          restaurantMenuController.restaurantUid.value,
                    ),
                  );
                }
              }
            },
          ),
        );
      },
    );
  }
}
