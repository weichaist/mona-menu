import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';

Future<dynamic> buildTimePicker(
  BuildContext context,
  void Function(TimeOfDay) onChange,
) {
  return Navigator.of(context).push(
    showPicker(
      context: context,
      accentColor: kRestaurantColor,
      barrierDismissible: false,
      is24HrFormat: true,
      okText: 'OK',
      okStyle: const TextStyle(color: kRestaurantColor),
      cancelText: 'キャンセル',
      cancelStyle: const TextStyle(color: CupertinoColors.systemGrey),
      minuteInterval: TimePickerInterval.FIVE,
      value: Time(hour: 9, minute: 0),
      onChange: onChange,
    ),
  );
}
