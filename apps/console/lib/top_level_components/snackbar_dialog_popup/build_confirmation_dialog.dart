import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<dynamic> buildConfirmationDialog({String? title}) {
  return Get.defaultDialog(
    title: title ?? 'もう一度のご確認',
    content: Column(
      children: [
        ListTile(
          title: const Text(
            'はい',
            style: TextStyle(color: CupertinoColors.systemGreen),
          ),
          leading: const Icon(Icons.check, color: CupertinoColors.systemGreen),
          onTap: () {
            Get.back(result: true);
          },
        ),
        ListTile(
          title: const Text(
            'いいえ',
            style: TextStyle(color: CupertinoColors.systemRed),
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
