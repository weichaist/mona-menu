import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/models/m_user_model.dart';
import 'package:mona_console/screens/home_screen/components/profile_image_container.dart';

class MonaMenuCardProfileTile extends StatelessWidget {
  final MUser mUser;
  final List<String> badges;

  const MonaMenuCardProfileTile({
    super.key,
    required this.mUser,
    required this.badges,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
      minLeadingWidth: 9,
      contentPadding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      title: Text(
        '${mUser.displayName!} (${mUser.lastName}様)',
        style: const TextStyle(color: kBodyTextColor),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mUser.bio!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: kBodyTextColor),
          ),
          if (badges.isNotEmpty)
            SizedBox(
              height: 30,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 3),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Chip(
                    visualDensity: const VisualDensity(vertical: -4),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 3),
                    label: Text(
                      badges[index],
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: kPrimaryLightColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 3);
                },
                itemCount: badges.length,
              ),
            ),
        ],
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProfileImageContainer(imageUrl: mUser.profilePictureURL!, radius: 45),
        ],
      ),
    );
  }
}
