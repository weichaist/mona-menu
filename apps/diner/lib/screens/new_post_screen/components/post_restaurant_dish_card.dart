import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mona_diner/config.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/models/mona_menu_post_model.dart';
import 'package:mona_diner/models/restaurant_menu_item_model.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_icon_button.dart';
import 'package:mona_diner/screens/top_level_components/money/jpy_text.dart';
import 'package:share_plus/share_plus.dart';

class PostRestaurantDishCard extends StatelessWidget {
  final bool isPosted;
  final MonaMenuPost? post;
  final RestaurantMenuItem menuItem;
  final VoidCallback onTap;

  const PostRestaurantDishCard({
    super.key,
    required this.menuItem,
    required this.onTap,
    this.isPosted = false,
    this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: CupertinoColors.opaqueSeparator)),
      ),
      child: Column(
        children: [
          Container(
            height: 108,
            color: isPosted ? kPrimaryLightColor : kBgColor,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Row(
              children: [
                menuItem.imageUrl != ''
                    ? AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            image: DecorationImage(
                              image: NetworkImage(menuItem.imageUrl!),
                              fit: BoxFit.cover,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        menuItem.title!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      JPYText(price: menuItem.price!),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0, thickness: 0.3),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: isPosted ? kPrimaryLightColor : kBgColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  isPosted
                      ? Text(
                          tr('Edit post'),
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          tr('Posting'),
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  if (isPosted)
                    DefaultIconButton(
                      icon: CupertinoIcons.share_up,
                      size: 21,
                      backgroundColor: Colors.transparent,
                      onTap: () async {
                        await SharePlus.instance.share(
                          ShareParams(
                            text:
                                '${AppConfig.shareBaseUrl}/post/${post!.postId!}',
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
