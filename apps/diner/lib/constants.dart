import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);
const kSecondaryColor = Color(0xFFCFD4F1);
const kSecondaryDarkColor = Color(0xFFBBA4BF);
const kBgColor = CupertinoColors.systemGrey6;
const kAppBarTextColor = Colors.black38;
const kBodyTextColor = Color(0xFF666666);
const kDarkBlackColor = Color(0xFF191919);

const kDefaultPadding = 20.0;
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
  spreadRadius: 0.6,
  blurRadius: 1.5,
  color: Colors.black26,
);
