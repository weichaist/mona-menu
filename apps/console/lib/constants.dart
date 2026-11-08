import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);
const kSecondaryColor = Color(0xFFCFD4F1);
const kSecondaryDarkColor = Color(0xFFBBA4BF);
const kBgColor = Color(0xFFE7E7E7);
const kBodyTextColor = Color(0xFF666666);
const kDarkBlackColor = Color(0xFF191919);
const kCreatorColor = Color(0xFFeea50b);
const kRestaurantColor = Color(0xFFb72621);
const kRestaurantLightColor = Color(0xFFE2A8A8);
const kAppBarColor = Colors.black45;
const kAppBarTextColor = Colors.black38;
const kSuccessColor = Color(0xFF1B813E);

const kDefaultPadding = 18.0;
const kMaxWidth = 1232.0;
const kDefaultDuration = Duration(milliseconds: 250);

const kDefaultGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomCenter,
  colors: [kPrimaryLightColor, kSecondaryDarkColor, kPrimaryColor],
  stops: [0.0, 0.5, 1.0],
);

const kDefaultShadow = BoxShadow(
  offset: Offset(0, 1),
  spreadRadius: 1,
  blurRadius: 2,
  color: Colors.black26,
);
