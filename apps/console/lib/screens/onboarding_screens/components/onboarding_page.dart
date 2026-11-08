import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/size_config.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.childWidget,
    required this.iconButton,
    this.iconButtonLeft,
  });
  final Widget childWidget;
  final Widget iconButton;
  final Widget? iconButtonLeft;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: getScreenHeight(),
                  width: getScreenWidth() / 3 * 2,
                  margin: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [kDefaultShadow],
                  ),
                  child: childWidget,
                ),
              ],
            ),
          ],
        ),
        Positioned(bottom: 18, right: 36, child: iconButton),
        if (iconButtonLeft != null)
          Positioned(bottom: 18, left: 36, child: iconButtonLeft!),
      ],
    );
  }
}
