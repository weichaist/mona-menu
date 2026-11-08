import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';

class DefaultTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color bgColor;
  final FontWeight fontWeight;
  final double fontSize;
  final EdgeInsets padding;
  const DefaultTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = kPrimaryColor,
    this.fontWeight = FontWeight.bold,
    this.fontSize = 15,
    this.bgColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 9.0),
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: bgColor,
        padding: padding,
      ),
      child: Text(
        label,
        style: TextStyle(fontWeight: fontWeight, fontSize: fontSize),
      ),
    );
  }
}
