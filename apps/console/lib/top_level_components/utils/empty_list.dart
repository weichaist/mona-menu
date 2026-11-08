import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mona_console/constants.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({super.key, required this.assetPath, required this.label});
  final String assetPath;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetPath,
            colorFilter: const ColorFilter.mode(
              kRestaurantColor,
              BlendMode.srcIn,
            ),
            height: 99,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              label,
              style: const TextStyle(color: kRestaurantColor, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
