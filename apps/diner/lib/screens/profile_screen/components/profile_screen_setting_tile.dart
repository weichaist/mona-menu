import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';

class ProfileScreenCustomTile extends StatelessWidget {
  final Widget leadingIcon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  const ProfileScreenCustomTile({
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
      minLeadingWidth: 18,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [leadingIcon],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [Icon(Icons.arrow_forward_ios_rounded, size: 15)],
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: kBodyTextColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
    );
  }
}
