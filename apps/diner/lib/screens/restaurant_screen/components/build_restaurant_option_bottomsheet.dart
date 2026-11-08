import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/screens/restaurant_screen/components/build_restaurant_info_bottom_sheet.dart';
import 'package:mona_diner/screens/restaurant_screen/components/restaurant_option_post_history_tile.dart';
import 'package:mona_diner/screens/restaurant_screen/components/restaurant_option_repeater_tile.dart';
import 'package:mona_diner/size_config.dart';
import 'package:toggle_switch/toggle_switch.dart';

Future<dynamic> buildInRestaurantBottomSheet() {
  final restaurantController = RestaurantController.instance;
  return Get.bottomSheet(
    Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 36),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (!restaurantController.restaurantData.value.oneSetMenu)
              Obx(
                () => ToggleSwitch(
                  minWidth: getScreenWidth() / 2.4,
                  cornerRadius: 18.0,
                  activeBgColors: const [
                    [kPrimaryColor],
                    [kPrimaryColor],
                  ],
                  activeFgColor: Colors.white,
                  inactiveBgColor: CupertinoColors.systemFill,
                  inactiveFgColor: Colors.white,
                  initialLabelIndex: restaurantController.menuGroups.indexOf(
                    restaurantController.currentMenuGroup.value,
                  ),
                  totalSwitches: 2,
                  labels: [tr('Lunch menu'), tr('Dinner menu')],
                  radiusStyle: true,
                  onToggle: (index) {
                    if (index != null) {
                      restaurantController.currentMenuGroup.value =
                          restaurantController.menuGroups[index];
                      restaurantController.manuallySetMenuGroup(index);
                    }
                  },
                ),
              ),
            if (!restaurantController.restaurantData.value.oneSetMenu)
              const Divider(thickness: 0.3),
            InkWell(
              splashColor: kPrimaryLightColor,
              highlightColor: kPrimaryLightColor,
              onTap: () async {
                await buildRestaurantInfoBottomSheet();
              },
              child: ListTile(
                minLeadingWidth: 18,
                leading: const Icon(
                  CupertinoIcons.info_circle,
                  color: kBodyTextColor,
                ),
                title: Text(
                  tr('Store information'),
                  style: const TextStyle(
                    color: kBodyTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Divider(thickness: 0.3),
            const PostHistoryTile(),
            const Divider(thickness: 0.3),
            const RepeaterStatusTile(),
            const Divider(thickness: 0.3),
            ListTile(
              tileColor: Colors.white,
              leading: const Icon(Icons.arrow_drop_down, color: kBodyTextColor),
              title: const Text(
                'Close',
                style: TextStyle(
                  color: kBodyTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    ),
  );
}
