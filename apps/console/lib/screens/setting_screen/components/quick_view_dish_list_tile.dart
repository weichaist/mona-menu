import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/models/restaurant_menu_item_model.dart';
import 'package:mona_console/top_level_components/currency_time_phone/convert_text_to_currency.dart';

class QuickViewDishTile extends StatelessWidget {
  final RestaurantMenuItem menuItem;
  final Function(bool?) onSoldOut;
  const QuickViewDishTile({
    super.key,
    required this.menuItem,
    required this.onSoldOut,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: Text(
                        menuItem.title!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: kRestaurantColor,
                        ),
                      ),
                    ),
                    Text(
                      menuItem.description!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      // maxLines: 3,
                      // overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: Row(
                        children: [
                          Expanded(
                            child: ConvertTextToCurrency(
                              price: menuItem.price!,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '表示優先度: ${menuItem.ranking!.toString()}',
                              style: const TextStyle(
                                fontSize: 15,
                                color: kRestaurantLightColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 126,
                width: 189,
                margin: const EdgeInsets.only(left: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  image: !menuItem.imageUrl!.startsWith('https://')
                      ? DecorationImage(
                          image: AssetImage(menuItem.imageUrl!),
                          fit: BoxFit.fill,
                        )
                      : DecorationImage(
                          image: NetworkImage(menuItem.imageUrl!),
                          fit: BoxFit.fill,
                        ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 0, color: CupertinoColors.systemGrey6),
        CheckboxListTile(
          title: const Text('売り切れ'),
          value: menuItem.soldOut,
          activeColor: kRestaurantColor,
          onChanged: (val) {
            onSoldOut(val);
          },
        ),
        const Divider(
          thickness: 1,
          height: 0,
          color: CupertinoColors.systemGrey3,
        ),
      ],
    );
  }
}
