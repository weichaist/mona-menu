import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';

ThemeData monaTheme() {
  return ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'NotoSansJP',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: kPrimaryColor,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: kPrimaryColor,
        fontSize: 21,
        fontWeight: FontWeight.w900,
      ),
      headlineSmall: TextStyle(
        color: kPrimaryColor,
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
      titleLarge: TextStyle(color: kBodyTextColor, fontSize: 15),
      titleMedium: TextStyle(
        color: kPrimaryColor,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        color: kBodyTextColor,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      bodySmall: TextStyle(color: kBodyTextColor, fontSize: 12),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: kPrimaryColor,
    ),
    inputDecorationTheme: inputDecorationTheme(),
  );
}

InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
    // floatingLabelBehavior: FloatingLabelBehavior.never,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    labelStyle: const TextStyle(color: kAppBarTextColor),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: kPrimaryColor),
      gapPadding: 10,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      gapPadding: 10,
      borderSide: const BorderSide(color: kPrimaryColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      gapPadding: 10,
      borderSide: const BorderSide(color: CupertinoColors.destructiveRed),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      gapPadding: 10,
      borderSide: const BorderSide(color: CupertinoColors.systemGrey),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      gapPadding: 10,
      borderSide: const BorderSide(color: CupertinoColors.destructiveRed),
    ),
  );
}
