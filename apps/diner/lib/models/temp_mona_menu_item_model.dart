import 'package:mona_diner/models/mona_menu_post_model.dart';
import 'package:mona_diner/models/restaurant_menu_item_model.dart';

class TempMonaMenuItem {
  final String? title;
  final String? description;
  final List<String>? categories;
  final String? menuGroup;
  final int? price;
  final String? postedBy;
  final String? postId;
  final String? menuItemId;
  final bool soldOut;

  TempMonaMenuItem({
    this.title,
    this.description,
    this.categories,
    this.menuGroup,
    this.price,
    this.postedBy,
    this.postId,
    this.menuItemId,
    this.soldOut = false,
  });

  TempMonaMenuItem.fromMonaMenu(
    MonaMenuPost monaMenu,
    RestaurantMenuItem restaurantMenuItem,
  ) : title = restaurantMenuItem.title,
      description = restaurantMenuItem.description,
      categories = restaurantMenuItem.categories,
      menuGroup = restaurantMenuItem.menuGroup,
      price = restaurantMenuItem.price,
      menuItemId = restaurantMenuItem.docId,
      postedBy = monaMenu.postedBy,
      soldOut = restaurantMenuItem.soldOut,
      postId = monaMenu.postId;
}
