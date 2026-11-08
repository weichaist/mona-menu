import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';

void buildGetSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: kRestaurantColor.withValues(alpha: 0.95),
    colorText: Colors.white,
    isDismissible: true,
    snackPosition: SnackPosition.BOTTOM,
  );
}
