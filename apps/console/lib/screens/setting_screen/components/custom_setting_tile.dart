import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';

class CustomSettingTile extends StatelessWidget {
  final Widget leadingIcon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  const CustomSettingTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [leadingIcon],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [Icon(Icons.arrow_forward_ios, size: 18)],
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: kBodyTextColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
    );
  }
}
