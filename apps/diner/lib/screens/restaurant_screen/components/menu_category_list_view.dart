import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/size_config.dart';

class MenuCategoryListView extends StatelessWidget {
  const MenuCategoryListView({super.key, required this.onTap});
  final Function(int) onTap;
  @override
  Widget build(BuildContext context) {
    final restaurantController = RestaurantController.instance;
    return SizedBox(
      height: 54,
      width: getScreenWidth(),
      child: Obx(
        () => ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          scrollDirection: Axis.horizontal,
          itemCount: restaurantController.menuCategories.length,
          separatorBuilder: (context, index) {
            return const SizedBox(width: 12);
          },
          itemBuilder: (context, index) {
            return Obx(
              () => GestureDetector(
                onTap: () {
                  onTap(index);
                },
                child: Chip(
                  label: Text(
                    restaurantController.menuCategories[index],
                    style: TextStyle(
                      color:
                          restaurantController.categoryPositionIndex.value ==
                              index
                          ? Colors.white
                          : kPrimaryColor,
                    ),
                  ),
                  backgroundColor:
                      restaurantController.categoryPositionIndex.value == index
                      ? kPrimaryColor
                      : kPrimaryLightColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
