import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_text_button.dart';
import 'package:mona_diner/screens/top_level_components/snackbar_dialog_bottomsheet/build_confirmation_dialog.dart';

class RepeaterStatusTile extends StatelessWidget {
  const RepeaterStatusTile({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantMenuController = RestaurantController.instance;
    restaurantMenuController.initCurrentUserRepeaterStatus(
      restaurantMenuController.restaurantUid.value,
    );
    return Obx(() {
      if (restaurantMenuController.isRepeaterStatus.isEmpty ||
          restaurantMenuController.isRepeaterStatus.value == 'canceled') {
        return ListTile(
          tileColor: Colors.white,
          minLeadingWidth: 18,
          leading: const Icon(
            CupertinoIcons.person_crop_circle_badge_checkmark,
            color: kBodyTextColor,
          ),
          title: Text(
            tr('Repeater certification'),
            style: const TextStyle(
              color: kBodyTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: DefaultTextButton(
            label: tr('Apply'),
            fontSize: 15,
            onPressed: () async {
              await restaurantMenuController.setRepeaterStatus(
                restaurantMenuController.restaurantUid.value,
                'applied',
                '申請を提出しました',
              );
              await restaurantMenuController.initCurrentUserRepeaterStatus(
                restaurantMenuController.restaurantUid.value,
              );
            },
          ),
        );
      } else {
        if (restaurantMenuController.isRepeaterStatus.value == 'applied') {
          return ListTile(
            tileColor: Colors.white,
            minLeadingWidth: 18,
            leading: const Icon(CupertinoIcons.clock, color: kBodyTextColor),
            title: Text(
              tr('Repeater is now being certified'),
              style: const TextStyle(
                color: kBodyTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: DefaultTextButton(
              label: 'キャンセル',
              fontSize: 15,
              onPressed: () async {
                await restaurantMenuController.setRepeaterStatus(
                  restaurantMenuController.restaurantUid.value,
                  'canceled',
                  '申請をキャンセルしました',
                );
                await restaurantMenuController.initCurrentUserRepeaterStatus(
                  restaurantMenuController.restaurantUid.value,
                );
              },
            ),
          );
        } else {
          return ListTile(
            tileColor: Colors.white,
            minLeadingWidth: 18,
            leading: const Icon(
              CupertinoIcons.person_crop_circle_badge_checkmark,
              color: kBodyTextColor,
            ),
            title: Text(
              tr('Repeater certified'),
              style: const TextStyle(
                color: kBodyTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: DefaultTextButton(
              label: tr('Unlock'),
              fontSize: 15,
              onPressed: () async {
                final res = await buildConfirmationDialog(
                  title: 'リピーターを解除しますか？',
                );
                if (res ?? false) {
                  await restaurantMenuController.setRepeaterStatus(
                    restaurantMenuController.restaurantUid.value,
                    'canceled',
                    '解除しました',
                  );
                  await restaurantMenuController.initCurrentUserRepeaterStatus(
                    restaurantMenuController.restaurantUid.value,
                  );
                }
              },
            ),
          );
        }
      }
    });
  }
}
