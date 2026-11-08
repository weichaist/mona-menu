import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:mona_console/constants.dart';

class ConvertTextToCurrency extends StatelessWidget {
  final int price;
  final double fontSize;
  final Color fontColor;
  const ConvertTextToCurrency({
    super.key,
    required this.price,
    this.fontSize = 15,
    this.fontColor = kRestaurantColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      double.parse(price.toString()).toCurrencyString(
        mantissaLength: 0,
        leadingSymbol: MoneySymbols.YEN_SIGN,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: fontColor,
        fontSize: fontSize,
      ),
    );
  }
}
