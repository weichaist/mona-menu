import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';

class OnboardingProfileContainer extends StatelessWidget {
  const OnboardingProfileContainer({
    super.key,
    required this.path,
    this.radius = 27,
  });

  final String path;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('https://')) {
      return Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: CupertinoColors.white, width: 1),
          image: DecorationImage(image: NetworkImage(path), fit: BoxFit.cover),
        ),
      );
    } else {
      if (path.startsWith('assets/') || path.startsWith('/')) {
        return Container(
          height: radius,
          width: radius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: CupertinoColors.white, width: 1),
            image: DecorationImage(
              image: FileImage(File(path)),
              fit: BoxFit.cover,
            ),
          ),
        );
      } else {
        return Container(
          height: radius,
          width: radius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kPrimaryColor,
            border: Border.all(color: CupertinoColors.white, width: 1),
          ),
          child: Center(
            child: Icon(
              CupertinoIcons.profile_circled,
              color: Colors.white,
              size: radius / 3,
            ),
          ),
        );
      }
    }
  }
}
