import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/onboard_controller.dart';
import 'package:mona_diner/screens/onboarding_screen/components/onboarding_profile_container.dart';
import 'package:mona_diner/size_config.dart';
import 'package:mona_diner/utils/image_handler/pick_gallary_image.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_get_snackbar.dart';

class ProfilePicturePage extends StatelessWidget {
  const ProfilePicturePage({super.key});
  @override
  Widget build(BuildContext context) {
    final onboardController = OnboardController.instance;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [kDefaultShadow],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 24,
                ),
                child: Text(
                  tr('2/3 Create profile'),
                  style: const TextStyle(color: kAppBarTextColor, fontSize: 18),
                ),
              ),
              Obx(
                () => SizedBox(
                  height: getScreenHeight() / 2,
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () async {
                      File? image = await PickGalleryImage()
                          .getImageFromGallery(1, 1);
                      if (image != null) {
                        onboardController.profileImagePath.value = image.path;
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OnboardingProfileContainer(
                          radius: 96,
                          path: onboardController.profileImagePath.value,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            '${tr('Let\'s add a profile photo!')}\n${tr('Required')}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: kPrimaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: FloatingActionButton(
              onPressed: () async {
                if (onboardController.profileImagePath.isNotEmpty) {
                  onboardController.pageController.nextPage(
                    duration: kDefaultDuration,
                    curve: Curves.easeInCirc,
                  );
                  onboardController.onboardingForm.focus('firstName');
                } else {
                  buildGetSnackbar(
                    tr('Please add a profile photo.'),
                    tr('Profile photo error'),
                  );
                }
              },
              backgroundColor: kPrimaryColor,
              child: const Icon(Icons.arrow_forward_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
