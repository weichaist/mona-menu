import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/screens/restaurant_screen/components/single_marker_google_map.dart';

Future<dynamic> buildRestaurantInfoBottomSheet() {
  final restaurantController = RestaurantController.instance;
  return Get.bottomSheet(
    Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          topLeft: Radius.circular(12),
        ),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Get.back();
              },
              title: SelectableText(
                restaurantController.restaurantData.value.name!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(CupertinoIcons.clear_circled),
            ),
            SingleMarkerGMap(
              markerPosition: LatLng(
                restaurantController.restaurantData.value.lat!,
                restaurantController.restaurantData.value.lng!,
              ),
            ),
            ListTile(
              leading: Text(tr('Address')),
              title: SelectableText(
                restaurantController.restaurantData.value.address!,
              ),
            ),
            const Divider(height: 0),
            ListTile(
              leading: Text(tr('About the store')),
              title: SelectableText(
                restaurantController.restaurantData.value.about!,
              ),
            ),
            const Divider(height: 0),
            ListTile(
              leading: Text(tr('Phone Number')),
              title: SelectableText(
                restaurantController.restaurantData.value.phoneNumber!,
              ),
            ),
            const Divider(height: 0),
            Column(
              children: List.generate(
                restaurantController.restaurantData.value.businessHours!.length,
                (index) => ListTile(
                  leading: Text(convertDayToYobi(index)),
                  title: Text(
                    restaurantController
                        .restaurantData
                        .value
                        .businessHours![index]
                        .toFormattedString(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}

String convertDayToYobi(int index) {
  switch (index) {
    case 0:
      return tr('Monday');
    case 1:
      return tr('Tuesday');
    case 2:
      return tr('Wednesday');
    case 3:
      return tr('Thursday');
    case 4:
      return tr('Friday');
    case 5:
      return tr('Saturday');
    case 6:
      return tr('Sunday');
    default:
      return '';
  }
}
