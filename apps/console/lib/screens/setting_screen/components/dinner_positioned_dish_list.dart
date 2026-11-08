import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/menu_controller.dart';
import 'package:mona_console/models/restaurant_menu_item_model.dart';
import 'package:mona_console/screens/setting_screen/components/build_category_bottom_sheet.dart';
import 'package:mona_console/screens/setting_screen/components/build_new_dish_bottom_sheet.dart';
import 'package:mona_console/screens/setting_screen/components/custom_dish_list_tile.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_confirmation_dialog.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_get_snackbar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DinnerPositionedDishList extends StatefulWidget {
  final List<String> categoryList;
  const DinnerPositionedDishList({super.key, required this.categoryList});
  @override
  State<DinnerPositionedDishList> createState() =>
      _DinnerPositionedDishListState();
}

class _DinnerPositionedDishListState extends State<DinnerPositionedDishList> {
  final _menuController = RestaurantMenuController.instance;
  @override
  void initState() {
    _menuController.dinnerItemPositionsListener.itemPositions.addListener(() {
      final visibleIndexes = _menuController
          .dinnerItemPositionsListener
          .itemPositions
          .value
          .toList()
          .map((itemPosition) => itemPosition.index)
          .toList();
      _menuController.dinnerCategoryPositionIndex.value = visibleIndexes.first;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _menuController.dinnerItemPositionsListener.itemPositions.removeListener(
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categoryList.isNotEmpty) {
      return ScrollablePositionedList.builder(
        itemCount: widget.categoryList.length,
        itemScrollController: _menuController.dinnerItemScrollController,
        itemPositionsListener: _menuController.dinnerItemPositionsListener,
        itemBuilder: (context, index) {
          return Obx(() {
            final category = widget.categoryList[index];
            final filteredList = _menuController.dinnerDishList
                .where((dish) => dish.categories!.contains(category))
                .toList();
            return Column(
              children: [
                ListTile(
                  title: Text(
                    widget.categoryList[index],
                    style: const TextStyle(fontSize: 21),
                  ),
                  leading: const Icon(
                    Icons.format_list_bulleted_rounded,
                    color: kRestaurantColor,
                  ),
                  trailing: const Icon(Icons.more_horiz_rounded),
                  onTap: () async {
                    await buildEditCategoryDialog(category, filteredList);
                  },
                ),
                const Divider(height: 0),
                for (final dish in filteredList)
                  CustomMenuListTile(
                    menuItem: dish,
                    onEdit: () async {
                      final res = await buildNewDishBottomSheet(
                        _menuController.dinnerMenuCategoryList,
                        dish,
                      );
                      if (res != null) {
                        await _menuController.editMenuItem(dish.docId!, res);
                      }
                    },
                    onDelete: () async {
                      final res = await buildConfirmationDialog();
                      if (res ?? false) {
                        await _menuController.deleteDish(dish.docId!);
                        await _menuController.initDishList();
                      }
                    },
                  ),
                const Divider(height: 0),
              ],
            );
          });
        },
      );
    } else {
      return Center(
        child: SvgPicture.asset(
          'assets/images/menu.svg',
          colorFilter: const ColorFilter.mode(
            kRestaurantColor,
            BlendMode.srcIn,
          ),
          height: 69,
        ),
      );
    }
  }

  Future<dynamic> buildEditCategoryDialog(
    String category,
    List<RestaurantMenuItem> dishes,
  ) async {
    Get.defaultDialog(
      title: 'Mona',
      content: Column(
        children: [
          ListTile(
            title: const Text('編集'),
            leading: const Icon(
              CupertinoIcons.pencil_circle,
              color: kRestaurantColor,
            ),
            onTap: () async {
              final res = await buildCategoryBottomSheet(category);
              if (res != null) {
                if (!_menuController.dinnerMenuCategoryList.contains(res)) {
                  int index = _menuController.dinnerMenuCategoryList.indexOf(
                    category,
                  );
                  _menuController.dinnerMenuCategoryList[index] = res;

                  final indexToChange = <int>[];
                  _menuController.dinnerDishList.asMap().forEach((key, dish) {
                    if (dish.categories!.contains(category)) {
                      indexToChange.add(key);
                    }
                  });
                  try {
                    EasyLoading.show(status: 'カテゴリ更新中..');
                    for (final i in indexToChange) {
                      final dish = _menuController.dinnerDishList[i];
                      dish.categories![_menuController
                              .dinnerDishList[i]
                              .categories!
                              .indexOf(category)] =
                          res;
                      await _menuController.updateCategory(
                        dish.docId!,
                        dish.categories!,
                      );
                    }
                    await _menuController.initDishList();
                    EasyLoading.dismiss();
                    EasyLoading.showSuccess('カテゴリが更新しました');
                  } catch (e) {
                    EasyLoading.dismiss();
                    EasyLoading.showError('エラーが発生しました');
                  }
                  Get.back();
                } else {
                  buildGetSnackbar('カテゴリはすでに追加されました', 'テゴリエラー');
                }
              }
            },
          ),
          const Divider(height: 0),
          ListTile(
            title: const Text('削除'),
            leading: const Icon(
              CupertinoIcons.delete,
              color: CupertinoColors.destructiveRed,
            ),
            onTap: () async {
              if (dishes.isNotEmpty) {
                buildGetSnackbar('削除できません', 'まずカテゴリにある料理を全て削除してください');
              } else {
                bool res = await buildConfirmationDialog();
                if (res) {
                  _menuController.dinnerMenuCategoryList.remove(category);
                  await _menuController.saveCategories();
                  Get.back();
                  setState(() {});
                } else {
                  Get.back();
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
