import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<dynamic> buildConfirmationDialog({String? title}) {
  return Get.defaultDialog(
    title: title ?? tr('Please confirm again'),
    content: Column(
      children: [
        ListTile(
          title: Text(
            tr('Yes'),
            style: const TextStyle(color: CupertinoColors.systemGreen),
          ),
          leading: const Icon(Icons.check, color: CupertinoColors.systemGreen),
          onTap: () {
            Get.back(result: true);
          },
        ),
        ListTile(
          title: Text(
            tr('No'),
            style: const TextStyle(color: CupertinoColors.systemRed),
          ),
          leading: const Icon(Icons.close, color: CupertinoColors.systemRed),
          onTap: () {
            Get.back(result: false);
          },
        ),
      ],
    ),
  );
}
