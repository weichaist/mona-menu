import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';

class BgImageContainer extends StatelessWidget {
  const BgImageContainer({super.key, required this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 21 / 10,
      child: imageUrl.isEmpty
          ? Container(
              decoration: BoxDecoration(
                color: kRestaurantLightColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 36,
                  color: kRestaurantColor,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: kRestaurantLightColor,
                borderRadius: BorderRadius.circular(12),
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
            ),
    );
  }
}
