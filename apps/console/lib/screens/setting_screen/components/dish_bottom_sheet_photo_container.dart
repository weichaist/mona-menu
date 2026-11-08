import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/size_config.dart';
import 'package:mona_console/top_level_components/buttons/default_icon_button.dart';

class DishBottomSheetPhotoContainer extends StatelessWidget {
  final String imageUrl;
  const DishBottomSheetPhotoContainer({super.key, required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: getScreenWidth() / 3,
      height: getScreenWidth() / 3 / 3 * 2,
      decoration: BoxDecoration(
        color: kRestaurantColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: imageUrl.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.all(9.0),
                  child: Icon(Icons.add_a_photo_outlined, color: Colors.white),
                ),
                Text(
                  '料理の写真を追加してください',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            )
          : Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: !imageUrl.startsWith('https://')
                        ? DecorationImage(
                            image: FileImage(File(imageUrl)),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: DefaultIconButton(
                    icon: CupertinoIcons.camera_on_rectangle,
                    size: 18,
                    onTap: () {},
                  ),
                ),
              ],
            ),
    );
  }
}
