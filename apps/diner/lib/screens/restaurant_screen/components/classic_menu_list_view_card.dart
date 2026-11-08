import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/models/restaurant_menu_item_model.dart';
import 'package:mona_diner/screens/restaurant_screen/components/restaurant_dish_tile.dart';
import 'package:mona_diner/screens/top_level_components/counter/icon_text_button_with_counter.dart';

class RestaurantMenuListViewCard extends StatelessWidget {
  final bool addedToCart;
  final RestaurantMenuItem menuItem;
  final VoidCallback onTap;

  const RestaurantMenuListViewCard({
    super.key,
    required this.menuItem,
    required this.onTap,
    this.addedToCart = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          boxShadow: const [kDefaultShadow],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(9),
                topLeft: Radius.circular(9),
              ),
              child: RestaurantDishTile(
                restaurantMenuItem: menuItem,
                isSelected: addedToCart,
              ),
            ),
            const Divider(height: 0),
            SizedBox(
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconTextButtonWithCounter(
                          size: 9.6,
                          icon: CupertinoIcons.add_circled,
                          label: tr('Posted'),
                        ),
                        IconTextButtonWithCounter(
                          size: 9.6,
                          icon: CupertinoIcons.money_yen_circle,
                          label: tr('Purchased'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 96,
                    height: 45,
                    decoration: BoxDecoration(
                      color: menuItem.soldOut
                          ? CupertinoColors.systemGrey
                          : kPrimaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(9),
                        topLeft: Radius.circular(9),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          menuItem.soldOut ? tr('Sold out') : tr('Order'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
