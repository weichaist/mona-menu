import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';

void buildGetSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: kPrimaryColor.withValues(alpha: 0.95),
    colorText: Colors.white,
  );
}
