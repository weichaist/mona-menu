import 'package:intl/intl.dart';

class BusinessHour {
  final int? weekday;
  bool? isBusinessDay;
  bool? lunchOpen;
  int? lunchStartHour;
  int? lunchStartMinute;
  int? lunchFinishHour;
  int? lunchFinishMinute;
  bool? dinnerOpen;
  int? dinnerStartHour;
  int? dinnerStartMinute;
  int? dinnerFinishHour;
  int? dinnerFinishMinute;

  BusinessHour({
    this.weekday,
    this.isBusinessDay = false,
    this.lunchOpen = false,
    this.lunchStartHour = 0,
    this.lunchStartMinute = 0,
    this.lunchFinishHour = 0,
    this.lunchFinishMinute = 0,
    this.dinnerOpen = false,
    this.dinnerStartHour = 0,
    this.dinnerStartMinute = 0,
    this.dinnerFinishHour = 0,
    this.dinnerFinishMinute = 0,
  });

  BusinessHour.fromFirestore(Map<String, dynamic> parsedJson)
    : weekday = parsedJson['weekday'],
      isBusinessDay = parsedJson['isBusinessDay'],
      lunchOpen = parsedJson['lunchOpen'],
      lunchStartHour = parsedJson['lunchStartHour'] as int,
      lunchStartMinute = parsedJson['lunchStartMinute'] as int,
      lunchFinishHour = parsedJson['lunchFinishHour'] as int,
      lunchFinishMinute = parsedJson['lunchFinishMinute'] as int,
      dinnerOpen = parsedJson['dinnerOpen'],
      dinnerStartHour = parsedJson['dinnerStartHour'] as int,
      dinnerStartMinute = parsedJson['dinnerStartMinute'] as int,
      dinnerFinishHour = parsedJson['dinnerFinishHour'] as int,
      dinnerFinishMinute = parsedJson['dinnerFinishMinute'] as int;

  Map<String, dynamic> toMap() => {
    'weekday': weekday,
    'isBusinessDay': isBusinessDay,
    'lunchOpen': lunchOpen,
    'lunchStartHour': lunchStartHour,
    'lunchStartMinute': lunchStartMinute,
    'lunchFinishHour': lunchFinishHour,
    'lunchFinishMinute': lunchFinishMinute,
    'dinnerOpen': dinnerOpen,
    'dinnerStartHour': dinnerStartHour,
    'dinnerStartMinute': dinnerStartMinute,
    'dinnerFinishHour': dinnerFinishHour,
    'dinnerFinishMinute': dinnerFinishMinute,
  };

  bool isLunch() {
    final now = DateTime.now();
    final lunchStartDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      lunchStartHour!,
      lunchStartMinute!,
    );
    final lunchFinishDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      lunchFinishHour!,
      lunchFinishMinute!,
    );
    if (now.isBefore(lunchFinishDateTime) && now.isAfter(lunchStartDateTime)) {
      return true;
    } else {
      return false;
    }
  }

  bool isDinner() {
    final now = DateTime.now();
    final dinnerStartDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      dinnerStartHour!,
      dinnerStartMinute!,
    );
    final dinnerFinishDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      dinnerFinishHour!,
      dinnerFinishMinute!,
    );
    if (now.isBefore(dinnerFinishDateTime) &&
        now.isAfter(dinnerStartDateTime)) {
      return true;
    } else {
      return false;
    }
  }

  bool isOpenNow() {
    if (isLunch() || isDinner()) {
      return true;
    } else {
      return false;
    }
  }

  String toFormattedString() {
    final now = DateTime.now();
    final lunchStartDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      lunchStartHour!,
      lunchStartMinute!,
    );
    final lunchFinishDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      lunchFinishHour!,
      lunchFinishMinute!,
    );
    final dinnerStartDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      dinnerStartHour!,
      dinnerStartMinute!,
    );
    final dinnerFinishDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      dinnerFinishHour!,
      dinnerFinishMinute!,
    );

    String formatDateTime(DateTime dateTime) {
      return DateFormat('HH:mm').format(dateTime).toString();
    }

    late String lunchString;
    late String dinnerString;
    if (lunchOpen!) {
      lunchString =
          '${formatDateTime(lunchStartDateTime)}~${formatDateTime(lunchFinishDateTime)}';
    } else {
      lunchString = '営業時間外';
    }
    if (dinnerOpen!) {
      dinnerString =
          '${formatDateTime(dinnerStartDateTime)}~${formatDateTime(dinnerFinishDateTime)}';
    } else {
      dinnerString = '営業時間外';
    }
    return '🌞 $lunchString  🌘 $dinnerString';
  }

  void reset() {
    isBusinessDay = false;
    lunchOpen = false;
    lunchStartHour = 0;
    lunchStartMinute = 0;
    lunchFinishHour = 0;
    lunchFinishMinute = 0;
    dinnerOpen = false;
    dinnerStartHour = 0;
    dinnerStartMinute = 0;
    dinnerFinishHour = 0;
    dinnerFinishMinute = 0;
  }
}
