import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';

class DefaultDialogTextButton extends StatelessWidget {
  final Color bgColor;
  final Color textColor;
  final String text;
  final VoidCallback onTap;
  const DefaultDialogTextButton({
    super.key,
    this.bgColor = kPrimaryColor,
    this.textColor = Colors.white,
    required this.text,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
          child: Text(text, style: TextStyle(color: textColor)),
        ),
      ),
    );
  }
}
