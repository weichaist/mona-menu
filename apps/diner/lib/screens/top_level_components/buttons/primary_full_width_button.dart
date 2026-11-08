import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';

class PrimaryFullWidthButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget centerWidget;
  final double height;
  final Color backgroundColor;
  const PrimaryFullWidthButton({
    super.key,
    required this.onTap,
    required this.centerWidget,
    this.height = 48,
    this.backgroundColor = kPrimaryColor,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 24),
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
