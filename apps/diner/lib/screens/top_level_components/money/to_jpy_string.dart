import 'package:flutter_multi_formatter/formatters/formatter_extension_methods.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';

String toJPYString(int money) {
  return double.parse(
    money.toString(),
  ).toCurrencyString(mantissaLength: 0, leadingSymbol: MoneySymbols.YEN_SIGN);
}
