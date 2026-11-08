import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/cart_controller.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_icon_button.dart';
import 'package:mona_diner/size_config.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_get_snackbar.dart';

class SelectTableTile extends StatelessWidget {
  const SelectTableTile({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantController = RestaurantController.instance;
    final cartController = CartController.instance;
    return ListTile(
      onTap: () {
        showBarModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: false,
          topControl: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DefaultIconButton(
                    icon: CupertinoIcons.clear,
                    iconColor: Colors.white,
                    backgroundColor: kPrimaryColor,
                    size: 24,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  DefaultIconButton(
                    icon: CupertinoIcons.checkmark_alt,
                    iconColor: cartController.selectedTableNumber.isNotEmpty
                        ? Colors.white
                        : kBodyTextColor,
                    backgroundColor:
                        cartController.selectedTableNumber.isNotEmpty
                        ? kPrimaryColor
                        : kBgColor,
                    size: 24,
                    onTap: () {
                      if (cartController.selectedTableNumber.isNotEmpty) {
                        Get.back();
                      } else {
                        buildGetSnackbar(
                          tr('Please select a table'),
                          tr('Tables are required'),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          builder: (context) => SizedBox(
            height: getScreenHeight() / 2,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Obx(
                  () => Column(
                    children: [
                      ListTile(
                        onTap: () {
                          cartController.selectedTableNumber.value =
                              restaurantController.restaurantTables[index];
                        },
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 27.0,
                          vertical: 9.0,
                        ),
                        title: Text(
                          restaurantController.restaurantTables[index],
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing:
                            cartController.selectedTableNumber.value ==
                                restaurantController.restaurantTables[index]
                            ? const Icon(
                                CupertinoIcons.check_mark_circled,
                                color: kPrimaryColor,
                              )
                            : null,
                      ),
                      const Divider(thickness: 0.6, height: 0),
                    ],
                  ),
                );
              },
              itemCount: restaurantController.restaurantTables.length,
            ),
          ),
        );
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.5),
            child: SvgPicture.asset(
              'assets/icons/dinner-table.svg',
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
              height: 27,
            ),
          ),
        ],
      ),
      title: Text(
        tr('Select a table'),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Obx(
        () => Text(
          cartController.selectedTableNumber.value.isNotEmpty
              ? cartController.selectedTableNumber.value
              : tr('Tap here'),
        ),
      ),
    );
  }
}
