import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/menu_controller.dart';
import 'package:mona_console/screens/setting_screen/components/dinner_positioned_dish_list.dart';
import 'package:mona_console/screens/setting_screen/components/new_category_button.dart';
import 'package:mona_console/screens/setting_screen/components/new_dish_button.dart';
import 'package:mona_console/screens/setting_screen/components/reorderable_category_tile_column.dart';

import '../../../size_config.dart';

class DinnerBody extends StatelessWidget {
  const DinnerBody({super.key});
  @override
  Widget build(BuildContext context) {
    final menuController = RestaurantMenuController.instance;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: getScreenHeight(),
          width: getScreenWidth() / 3 * 2,
          margin: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [kDefaultShadow],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Obx(
                    () => Expanded(
                      child: SwitchListTile(
                        value: menuController.dinnerMenuAvailable.value,
                        activeThumbColor: kRestaurantColor,
                        title: const Text('夜のメニュー'),
                        onChanged: (val) async {
                          menuController.dinnerMenuAvailable.value = val;
                        },
                      ),
                    ),
                  ),
                  Obx(
                    () => Expanded(
                      child: SwitchListTile(
                        value: menuController.oneSetMenu.value,
                        activeThumbColor: kRestaurantColor,
                        title: const Text('昼夜兼用'),
                        onChanged: (val) async {
                          menuController.oneSetMenu.value = val;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: const EdgeInsets.only(bottom: 9),
                height: 72,
                child: Row(
                  children: [
                    Obx(
                      () => Expanded(
                        child: NewCategoryButton(
                          categories: menuController.dinnerMenuCategoryList
                              .toList(),
                          onCreate: (category) async {
                            if (!menuController.dinnerMenuAvailable.value) {
                              menuController.dinnerMenuAvailable.value = true;
                            }
                            menuController.dinnerMenuCategoryList.add(category);
                            await menuController.saveCategories();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Obx(
                      () => Expanded(
                        child: NewDishButton(
                          onCreated: (dishMap) async {
                            try {
                              dishMap['menuGroup'] = 'dinner';
                              EasyLoading.show(status: '保存中..');
                              await menuController.saveNewMenuItem(dishMap);
                              await menuController.initDishList();
                              EasyLoading.dismiss();
                              EasyLoading.showSuccess('保存しました');
                            } catch (e) {
                              debugPrint(e.toString());
                              EasyLoading.dismiss();
                              EasyLoading.showError('エラーが発生しました..');
                            }
                            menuController.resetNewDishData();
                          },
                          categories: menuController.dinnerMenuCategoryList
                              .toList(),
                          dishes: menuController.dinnerDishList.toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Expanded(
                        flex: 1,
                        child: ReorderableCategoryTileColumn(
                          categoryList: menuController.dinnerMenuCategoryList
                              .toList(),
                          currentCategoryIndex:
                              menuController.dinnerCategoryPositionIndex.value,
                          afterReordered: (list) {
                            menuController.dinnerMenuCategoryList.value = list;
                            menuController.dinnerCategoryPositionIndex.value =
                                0;
                            menuController.dinnerItemScrollController.jumpTo(
                              index: 0,
                            );
                          },
                          onTap: (index) {
                            menuController.dinnerItemScrollController.scrollTo(
                              index: index,
                              duration: kDefaultDuration,
                            );
                          },
                        ),
                      ),
                    ),
                    const VerticalDivider(width: 0),
                    Obx(
                      () => Expanded(
                        flex: 3,
                        child: DinnerPositionedDishList(
                          categoryList: menuController.dinnerMenuCategoryList
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
