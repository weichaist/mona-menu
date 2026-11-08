import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';

class ProfileImageContainer extends StatelessWidget {
  final double radius;
  final String imageUrl;
  final IconData icon;
  const ProfileImageContainer({
    super.key,
    this.radius = 36,
    required this.imageUrl,
    this.icon = CupertinoIcons.person,
  });
  @override
  Widget build(BuildContext context) {
    return imageUrl.isEmpty
        ? Container(
            height: radius,
            width: radius,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kRestaurantColor,
            ),
            child: Center(
              child: Icon(icon, size: 15 / 36 * radius, color: Colors.white),
            ),
          )
        : Container(
            height: radius,
            width: radius,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kRestaurantColor,
              image: imageUrl.startsWith('https://')
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
