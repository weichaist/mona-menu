import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';

class IconTextButtonWithCounter extends StatelessWidget {
  const IconTextButtonWithCounter({
    super.key,
    required this.icon,
    this.size = 15,
    this.onTap,
    this.backgroundColor = Colors.white,
    this.iconColor = kRestaurantColor,
    required this.label,
    this.count,
  });
  final IconData icon;
  final double size;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color iconColor;
  final String label;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: size * 1.5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Text(
                    count != null
                        ? '$label (${count.toString()})'
                        : '$label (--)',
                    style: TextStyle(fontSize: size, color: kBodyTextColor),
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
