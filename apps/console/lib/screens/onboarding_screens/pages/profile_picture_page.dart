import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/onboarding_controller.dart';
import 'package:mona_console/screens/home_screen/components/profile_image_container.dart';
import 'package:mona_console/screens/onboarding_screens/components/onboarding_page.dart';
import 'package:mona_console/top_level_components/buttons/default_icon_button.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_get_snackbar.dart';
import 'package:mona_console/top_level_components/utils/pick_gallary_image.dart';

class AccPictureScreen extends StatelessWidget {
  const AccPictureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OnboardingController onboardingController = OnboardingController.instance;
    return OnboardingPage(
      childWidget: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ステップ2/2'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    'お店の写真を選択してください',
                    style: TextStyle(
                      color: kRestaurantColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 36),
                  child: Text(
                    'プロフィール写真や、背景写真など',
                    style: TextStyle(color: kBodyTextColor),
                  ),
                ),
                Obx(
                  () => Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          File? image = await PickGalleryImage()
                              .getImageFromGallery(1, 1);
                          if (image != null) {
                            onboardingController.profilePicturePath.value =
                                image.path;
                          }
                        },
                        child: ProfileImageContainer(
                          radius: 84,
                          icon: Icons.add_a_photo_outlined,
                          imageUrl:
                              onboardingController.profilePicturePath.value,
                        ),
                      ),
                      const SizedBox(height: 36),
                      AspectRatio(
                        aspectRatio: 21 / 10,
                        child: GestureDetector(
                          onTap: () async {
                            File? image = await PickGalleryImage()
                                .getImageFromGallery(21, 10);
                            if (image != null) {
                              onboardingController.bgPicturePath.value =
                                  image.path;
                            }
                          },
                          child: onboardingController.bgPicturePath.isEmpty
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: kRestaurantLightColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 36,
                                      color: kRestaurantColor,
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: kRestaurantLightColor,
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: FileImage(
                                        File(
                                          onboardingController
                                              .bgPicturePath
                                              .value,
                                        ),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      iconButtonLeft: DefaultIconButton(
        icon: Icons.arrow_back,
        onTap: () {
          onboardingController.pageController.jumpToPage(0);
          onboardingController.setCurrentPage(0);
        },
        backgroundColor: kRestaurantColor,
        iconColor: Colors.white,
      ),
      iconButton: Obx(
        () => DefaultIconButton(
          icon: Icons.check,
          onTap: () async {
            if (onboardingController.profilePicturePath.isNotEmpty &&
                onboardingController.bgPicturePath.isNotEmpty &&
                onboardingController.onboardingForm.valid) {
              await onboardingController.completeOnboardingProcess();
            } else {
              buildGetSnackbar(
                '写真を選択してくだい',
                'Profile picture and background picture are necessary',
              );
            }
          },
          backgroundColor:
              onboardingController.profilePicturePath.isNotEmpty &&
                  onboardingController.bgPicturePath.isNotEmpty
              ? kRestaurantColor
              : Colors.black45,
          iconColor: Colors.white,
        ),
      ),
    );
  }
}
