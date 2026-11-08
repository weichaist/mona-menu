import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';

class PrimaryFullWidthButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget centerWidget;
  final double height;
  final Color backgroundColor;
  const PrimaryFullWidthButton({
    super.key,
    required this.onTap,
    required this.centerWidget,
    this.height = 64,
    this.backgroundColor = kRestaurantColor,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(child: centerWidget),
        ),
      ),
    );
  }
}
