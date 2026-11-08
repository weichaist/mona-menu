import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/models/m_user_model.dart';
import 'package:mona_console/screens/home_screen/components/profile_image_container.dart';

class ProfileDisplayNameTile extends StatelessWidget {
  final MUser mUser;

  const ProfileDisplayNameTile({super.key, required this.mUser});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 9,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
      title: Text(
        mUser.displayName!,
        style: const TextStyle(color: kBodyTextColor),
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProfileImageContainer(imageUrl: mUser.profilePictureURL!, radius: 36),
        ],
      ),
    );
  }
}
