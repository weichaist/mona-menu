import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileAvatarContainer extends StatelessWidget {
  final double radius;
  final String imageUrl;
  final Color bgColor;
  const ProfileAvatarContainer({
    super.key,
    this.radius = 36,
    required this.imageUrl,
    this.bgColor = Colors.white,
  });
  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
        child: Center(
          child: Text(
            'M',
            style: TextStyle(color: Colors.white, fontSize: 15 / 36 * radius),
          ),
        ),
      );
    } else {
      return Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: CupertinoColors.white, width: 1),
          image: imageUrl.contains('https://')
              ? DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                )
              : DecorationImage(
                  image: FileImage(File(imageUrl)),
                  fit: BoxFit.cover,
                ),
        ),
      );
    }
  }
}
