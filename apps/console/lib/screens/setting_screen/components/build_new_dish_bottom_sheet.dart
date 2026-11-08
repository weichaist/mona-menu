import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/menu_controller.dart';
import 'package:mona_console/models/restaurant_menu_item_model.dart';
import 'package:mona_console/size_config.dart';
import 'package:mona_console/top_level_components/buttons/default_text_button.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_get_snackbar.dart';
import 'package:mona_console/top_level_components/utils/pick_gallary_image.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'dish_bottom_sheet_photo_container.dart';

Future<dynamic> buildNewDishBottomSheet(
  List<String> categoryList,
  RestaurantMenuItem? menuItem,
) {
  final menuController = RestaurantMenuController.instance;
  if (menuItem != null) {
    menuController.newDishForm.value = {
      'title': menuItem.title,
      'description': menuItem.description,
      'price': menuItem.price!.toCurrencyString(
        mantissaLength: 0,
        leadingSymbol: MoneySymbols.YEN_SIGN,
      ),
      'ranking': menuItem.ranking,
    };
    menuController.newDishCategories.value = menuItem.categories!;
    menuController.newDishImageUrl.value = menuItem.imageUrl!;
  } else {
    menuController.resetNewDishData();
  }
  return Get.bottomSheet(
    Container(
      height: getScreenHeight() / 3 * 2.7,
      width: getScreenWidth(),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: SafeArea(
        minimum: const EdgeInsets.only(top: 36),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListTile(
                title: const Text('新しい料理を作成'),
                leading: IconButton(
                  icon: const Icon(CupertinoIcons.clear_circled),
                  onPressed: () {
                    Get.back();
                  },
                ),
                trailing: DefaultTextButton(
                  label: '作成',
                  color: kRestaurantColor,
                  fontSize: 15,
                  onPressed: () {
                    if (menuController.newDishValid()) {
                      late int formattedPrice;
                      if (menuController.newDishForm.control('price').value ==
                          '￥0') {
                        formattedPrice = 0;
                      } else {
                        final tempPrice = menuController.newDishForm
                            .control('price')
                            .value
                            .split('￥')[1]
                            .replaceAll(',', '');
                        formattedPrice = int.parse(tempPrice);
                      }
                      Get.back(
                        result: {
                          'title': menuController.newDishForm
                              .control('title')
                              .value,
                          'description': menuController.newDishForm
                              .control('description')
                              .value,
                          'price': formattedPrice,
                          'ranking': menuController.newDishForm
                              .control('ranking')
                              .value,
                          'imageUrl': menuController.newDishImageUrl.value,
                          'categories': menuController.newDishCategories,
                        },
                      );
                    } else {
                      buildGetSnackbar('必須項目を入力してくだい', '料理の作成エラー');
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: ReactiveForm(
                  formGroup: menuController.newDishForm,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Obx(
                            () => GestureDetector(
                              onTap: () async {
                                final image = await PickGalleryImage()
                                    .getImageFromGallery(3, 2);
                                if (image != null) {
                                  menuController.newDishImageUrl.value =
                                      image.path;
                                }
                              },
                              child: DishBottomSheetPhotoContainer(
                                imageUrl: menuController.newDishImageUrl.value,
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              children: [
                                ReactiveTextField(
                                  formControlName: 'title',
                                  decoration: const InputDecoration(
                                    hintText: '料理のタイトルを入力してください ※',
                                    labelText: '料理のタイトルを入力してください ※',
                                  ),
                                  validationMessages: {
                                    ValidationMessage.required: (_) =>
                                        '料理のタイトルを入力してください',
                                  },
                                ),
                                const SizedBox(height: 36),
                                ReactiveTextField(
                                  formControlName: 'description',
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    hintText: '料理の説明を入力してください ※',
                                    labelText: '料理の説明を入力してください ※',
                                  ),
                                  validationMessages: {
                                    ValidationMessage.required: (_) =>
                                        '料理の説明を入力してください',
                                  },
                                ),
                                const SizedBox(height: 36),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 9,
                                        ),
                                        child: ReactiveTextField(
                                          formControlName: 'price',
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            CurrencyInputFormatter(
                                              mantissaLength: 0,
                                              leadingSymbol:
                                                  MoneySymbols.YEN_SIGN,
                                            ),
                                          ],
                                          decoration: const InputDecoration(
                                            hintText: '料理の価格(税抜)を入力してください ※',
                                            labelText: '料理の価格(税抜)を入力してください ※',
                                          ),
                                          validationMessages: {
                                            ValidationMessage.required: (_) =>
                                                '料理の価格(税抜)を入力してください',
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 9),
                                        child: ReactiveTextField(
                                          formControlName: 'ranking',
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          decoration: const InputDecoration(
                                            hintText: '表示優先度を入力してください ※　例：3',
                                            labelText: '表示優先度を入力してください ※　例：3',
                                          ),
                                          validationMessages: {
                                            ValidationMessage.required: (_) =>
                                                '表示優先度を入力してください',
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
              const Divider(color: kRestaurantLightColor),
              ListTile(
                title: const Text(
                  'カテゴリを選んでください',
                  style: TextStyle(color: kAppBarTextColor),
                ),
                subtitle: Obx(() {
                  if (menuController.newDishCategories.isNotEmpty) {
                    return Text(
                      menuController.newDishCategories
                          .toString()
                          .replaceAll('[', '')
                          .replaceAll(']', ', '),
                      style: const TextStyle(
                        fontSize: 15,
                        color: kRestaurantColor,
                      ),
                    );
                  } else {
                    return const Text(
                      'カテゴリ',
                      style: TextStyle(color: kRestaurantColor),
                    );
                  }
                }),
                onTap: () async {
                  menuController.newDishForm.unfocus();
                  await Future.delayed(const Duration(milliseconds: 500));
                  await Get.defaultDialog(
                    title: 'カテゴリ',
                    confirm: DefaultTextButton(
                      label: '完了',
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    content: SizedBox(
                      height: getScreenHeight() / 2.5,
                      width: getScreenWidth() / 3,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Obx(
                                () => CheckboxListTile(
                                  activeColor: kRestaurantColor,
                                  title: Text(categoryList[index]),
                                  value: menuController.newDishCategories
                                      .contains(categoryList[index]),
                                  onChanged: (check) {
                                    if (check != null) {
                                      if (check) {
                                        menuController.newDishCategories.add(
                                          categoryList[index],
                                        );
                                      } else {
                                        menuController.newDishCategories.remove(
                                          categoryList[index],
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                              const Divider(height: 0),
                            ],
                          );
                        },
                        itemCount: categoryList.length,
                      ),
                    ),
                  );
                },
                leading: const Icon(
                  Icons.format_list_bulleted_rounded,
                  color: kRestaurantColor,
                ),
              ),
              const Divider(color: kRestaurantLightColor),
            ],
          ),
        ),
      ),
    ),
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
  );
}
