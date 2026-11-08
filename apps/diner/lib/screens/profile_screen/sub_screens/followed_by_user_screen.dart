import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/micro_data_controller.dart';
import 'package:mona_diner/controllers/profile_controller.dart';
import 'package:mona_diner/models/mona_user_model.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_icon_button.dart';
import 'package:mona_diner/screens/top_level_components/list/paginated_list_view.dart';
import 'package:mona_diner/screens/top_level_components/snackbar_dialog_bottomsheet/build_report_content_bottom_sheet.dart';

class FollowedByUserScreen extends StatelessWidget {
  const FollowedByUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = ProfileController.instance;
    final microDataController = MicroDataController.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('Follower'), style: TextStyle(color: kAppBarTextColor)),
      ),
      body: Obx(() {
        if (profileController.userFollowedByCount > 0) {
          return PaginatedListView(
            query: profileController.userFollowedByQuery(),
            pageSize: 15,
            build: (context, data) {
              final uid = data['uid'];
              return FutureBuilder<MUser?>(
                future: microDataController.fetchAccountUserData(uid),
                builder: (context, snapshot) {
                  var mUser = snapshot.data;
                  return mUser != null
                      ? Column(
                          children: [
                            ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ProfileAvatarContainer(
                                    imageUrl: mUser.profilePictureURL!,
                                    radius: 48,
                                  ),
                                ],
                              ),
                              title: Text(
                                mUser.displayName!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${mUser.lastName!} ${mUser.firstName!}',
                              ),
                              trailing: DefaultIconButton(
                                icon: Icons.more_horiz_outlined,
                                onTap: () {
                                  buildReportContentBottomSheet(
                                    'user',
                                    mUser.uid!,
                                  );
                                },
                              ),
                            ),
                            const Divider(height: 0),
                          ],
                        )
                      : ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ProfileAvatarContainer(
                                imageUrl: microDataController
                                    .mUser
                                    .value
                                    .profilePictureURL!,
                                radius: 36,
                              ),
                            ],
                          ),
                          title: Text(
                            microDataController.mUser.value.displayName!,
                          ),
                          trailing: DefaultIconButton(
                            icon: Icons.more_horiz_outlined,
                            onTap: () {},
                          ),
                        );
                },
              );
            },
          );
        } else {
          return Center(
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              height: 36,
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
          );
        }
      }),
    );
  }
}
