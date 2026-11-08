import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/micro_data_controller.dart';
import 'package:mona_diner/models/restaurant_account_model.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_dialog_text_button.dart';
import 'package:mona_diner/size_config.dart';

Future<dynamic> buildSuccessOrderedDialog(String restaurantUid) async {
  MicroDataController microDataController = MicroDataController.instance;
  await Get.defaultDialog(
    title: 'Success!',
    barrierDismissible: false,
    content: FutureBuilder<RestaurantAccount?>(
      future: microDataController.fetchRestaurantAccountData(restaurantUid),
      builder: (context, snapshot) {
        var restaurantAcc = snapshot.data;
        return SizedBox(
          width: getScreenWidth() / 3 * 2,
          child: Column(
            children: [
              ProfileAvatarContainer(
                imageUrl: restaurantAcc != null
                    ? restaurantAcc.profileImageUrl!
                    : '',
                radius: 96,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 12,
                ),
                child: Text(
                  restaurantAcc != null ? restaurantAcc.name! : '',
                  style: const TextStyle(fontSize: 15, color: kBodyTextColor),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 12,
                ),
                child: Text(
                  tr('Thank you for your order!'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: kBodyTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    ),
    cancel: DefaultDialogTextButton(
      text: 'Close',
      bgColor: kBgColor,
      textColor: kBodyTextColor,
      onTap: () {
        Get.back();
      },
    ),
  );
}
