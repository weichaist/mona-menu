import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';

class FullWidthIconTextButton extends StatelessWidget {
  const FullWidthIconTextButton({
    super.key,
    required this.icon,
    this.size = 13.5,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.iconColor = kPrimaryColor,
    this.labelColor = kBodyTextColor,
    required this.label,
    this.count,
  });
  final IconData icon;
  final double size;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color iconColor;
  final String label;
  final Color labelColor;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: onTap,
          splashColor: kPrimaryLightColor.withValues(alpha: 0.4),
          highlightColor: kPrimaryLightColor.withValues(alpha: 0.4),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: size * 1.2),
                Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Text(
                    label,
                    style: TextStyle(fontSize: size, color: labelColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
