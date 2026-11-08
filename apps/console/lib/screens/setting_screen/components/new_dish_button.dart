import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/models/restaurant_menu_item_model.dart';
import 'package:mona_console/screens/setting_screen/components/build_new_dish_bottom_sheet.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_get_snackbar.dart';

class NewDishButton extends StatelessWidget {
  final List<RestaurantMenuItem> dishes;
  final List<String> categories;
  final Function(Map<String, dynamic>) onCreated;
  const NewDishButton({
    super.key,
    required this.onCreated,
    required this.dishes,
    required this.categories,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [kDefaultShadow],
      ),
      child: ListTile(
        dense: true,
        onTap: () async {
          if (categories.isEmpty) {
            buildGetSnackbar('カテゴリエラー', 'まずカテゴリを追加してください');
          } else {
            final res = await buildNewDishBottomSheet(categories, null);
            if (res != null) {
              onCreated(res);
            }
          }
        },
        title: const Text('新しい料理を追加'),
        subtitle: Text('料理数: ${dishes.length}'),
        trailing: const Icon(
          CupertinoIcons.add_circled,
          color: kRestaurantColor,
        ),
      ),
    );
  }
}
