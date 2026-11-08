import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';

class DefaultIconButton extends StatelessWidget {
  const DefaultIconButton({
    super.key,
    required this.icon,
    this.size = 27,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.iconColor = kRestaurantColor,
  });
  final IconData icon;
  final double size;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: onTap,
          splashColor: kRestaurantLightColor.withValues(alpha: 0.4),
          highlightColor: kRestaurantLightColor.withValues(alpha: 0.4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Icon(icon, color: iconColor, size: size),
          ),
        ),
      ),
    );
  }
}
