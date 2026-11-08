import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_console/size_config.dart';
import 'package:mona_console/top_level_components/buttons/default_text_button.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_get_snackbar.dart';

Future<dynamic> buildCategoryBottomSheet(String? initValue) {
  final controller = TextEditingController();
  if (initValue != null) {
    controller.text = initValue;
  }
  return Get.bottomSheet(
    Container(
      height: getScreenHeight() / 2,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ListTile(
            title: const Text('新しいカテゴリを作成'),
            leading: IconButton(
              icon: const Icon(CupertinoIcons.clear_circled),
              onPressed: () {
                Get.back();
              },
            ),
            trailing: DefaultTextButton(
              label: '作成',
              fontSize: 15,
              onPressed: () {
                final newCategory = controller.text.trim();
                if (newCategory.isNotEmpty) {
                  Get.back(result: newCategory);
                } else {
                  buildGetSnackbar('カテゴリを入力してください', 'カテゴリエラー');
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '新しいカテゴリ',
                labelText: '新しいカテゴリ',
              ),
            ),
          ),
        ],
      ),
    ),
    isDismissible: true,
    enableDrag: false,
  );
}
