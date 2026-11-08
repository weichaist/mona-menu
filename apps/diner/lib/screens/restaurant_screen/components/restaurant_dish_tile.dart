import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/models/restaurant_menu_item_model.dart';
import 'package:mona_diner/screens/top_level_components/money/jpy_text.dart';
import 'package:mona_diner/screens/top_level_components/screens/photo_gallery_screen.dart';

class RestaurantDishTile extends StatelessWidget {
  final RestaurantMenuItem restaurantMenuItem;
  final bool isSelected;

  const RestaurantDishTile({
    super.key,
    required this.restaurantMenuItem,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      color: isSelected ? kPrimaryLightColor : kBgColor,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Row(
        children: [
          restaurantMenuItem.imageUrl != ''
              ? AspectRatio(
                  aspectRatio: 4 / 3,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                        () => PhotoGalleryScreen(
                          imageUrls: [restaurantMenuItem.imageUrl!],
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        image: DecorationImage(
                          image: NetworkImage(restaurantMenuItem.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                )
              : AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  restaurantMenuItem.title!,
                  maxLines: restaurantMenuItem.title!.length < 25 ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  restaurantMenuItem.description!,
                  maxLines: restaurantMenuItem.title!.length < 25 ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                JPYText(price: restaurantMenuItem.price!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
