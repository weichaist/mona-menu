import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';

class DefaultTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color bgColor;
  final FontWeight fontWeight;
  final double fontSize;
  const DefaultTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = kRestaurantColor,
    this.fontWeight = FontWeight.bold,
    this.fontSize = 18,
    this.bgColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: bgColor,
      ),
      child: Text(
        label,
        style: TextStyle(fontWeight: fontWeight, fontSize: fontSize),
      ),
    );
  }
}
