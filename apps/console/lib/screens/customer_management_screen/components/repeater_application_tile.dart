import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/customer_controller.dart';
import 'package:mona_console/models/m_user_model.dart';
import 'package:mona_console/models/repeater_application_model.dart';
import 'package:mona_console/screens/home_screen/components/profile_image_container.dart';
import 'package:mona_console/top_level_components/buttons/default_text_button.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_confirmation_dialog.dart';

class RepeaterApplicationTile extends StatelessWidget {
  final MUser mUser;
  final RepeaterApplication application;
  const RepeaterApplicationTile({
    super.key,
    required this.mUser,
    required this.application,
  });

  @override
  Widget build(BuildContext context) {
    final customerOverViewController = CustomerController.instance;
    return Column(
      children: [
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 3,
          ),
          title: Text(
            mUser.displayName!,
            style: const TextStyle(color: kRestaurantColor),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${mUser.lastName!} ${mUser.firstName!}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: kBodyTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                mUser.bio!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: kBodyTextColor),
              ),
            ],
          ),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileImageContainer(
                imageUrl: mUser.profilePictureURL!,
                radius: 45,
              ),
            ],
          ),
          trailing: application.status == 'applied'
              ? DefaultTextButton(
                  label: '認定する',
                  fontSize: 15,
                  onPressed: () async {
                    final res = await buildConfirmationDialog(
                      title: 'リピーターとして認定しますか？',
                    );
                    if (res ?? false) {
                      await customerOverViewController.setRepeaterStatus(
                        mUser.uid!,
                        'approved',
                        '認定しました',
                      );
                      await customerOverViewController
                          .initFetchingRepeaterApplications();
                      await customerOverViewController
                          .initFetchingCertifiedCustomers();
                    }
                  },
                )
              : DefaultTextButton(
                  label: '解除する',
                  fontSize: 15,
                  onPressed: () async {
                    final res = await buildConfirmationDialog(
                      title: 'リピーターを解除しますか？',
                    );
                    if (res ?? false) {
                      await customerOverViewController.setRepeaterStatus(
                        mUser.uid!,
                        '',
                        '解除しました',
                      );
                      await customerOverViewController
                          .initFetchingRepeaterApplications();
                      await customerOverViewController
                          .initFetchingCertifiedCustomers();
                    }
                  },
                ),
        ),
        const Divider(height: 0, thickness: 0.3, color: kRestaurantLightColor),
      ],
    );
  }
}
