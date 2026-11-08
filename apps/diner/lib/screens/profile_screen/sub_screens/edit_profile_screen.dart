import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/profile_controller.dart';
import 'package:mona_diner/screens/profile_screen/components/sign_out_account_list_tile.dart';
import 'package:mona_diner/screens/profile_screen/sub_screens/edit_privacy_info_screen.dart';
import 'package:mona_diner/screens/profile_screen/sub_screens/edit_text_screen.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_text_button.dart';
import 'package:mona_diner/utils/image_handler/pick_gallary_image.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_get_snackbar.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    ProfileController profileController = ProfileController.instance;
    profileController.initProfileEditingProcess();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('Edit Profile'),
          style: const TextStyle(color: kAppBarTextColor),
        ),
        actions: [
          DefaultTextButton(
            label: tr('Completion'),
            onPressed: () async {
              if (!profileController.profilePictureUrl.startsWith('https://')) {
                await profileController.updatedUserProfilePicture(
                  profileController.profilePictureUrl.value,
                );
                await profileController.setProfile();
                Get.back();
              } else {
                Get.back();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Obx(
                () => GestureDetector(
                  onTap: () async {
                    File? image = await PickGalleryImage().getImageFromGallery(
                      1,
                      1,
                    );
                    if (image != null) {
                      profileController.profilePictureUrl.value = image.path;
                      profileController.mUser.refresh();
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ProfileAvatarContainer(
                        radius: 84,
                        imageUrl: profileController.profilePictureUrl.value,
                      ),
                      Text(
                        tr('Change profile photo'),
                        style: const TextStyle(
                          fontSize: 12,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 9.0, right: 9.0, top: 9.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [kDefaultShadow],
                borderRadius: BorderRadius.circular(9),
              ),
              child: Column(
                children: [
                  Obx(
                    () => ListTile(
                      leading: SizedBox(
                        width: 108,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text(tr('Username |'))],
                        ),
                      ),
                      trailing: const Icon(CupertinoIcons.pencil_circle),
                      title: Text(profileController.mUser.value.displayName!),
                      onTap: () async {
                        Get.to(
                          () => EditTextScreen(
                            appBarTitle: tr('Username'),
                            textField: ReactiveTextField(
                              formControlName: 'displayName',
                              decoration: InputDecoration(
                                hintText: tr('Username'),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9a-z_.]'),
                                ),
                              ],
                              validationMessages: {
                                ValidationMessage.required: (_) =>
                                    tr('Please enter the username'),
                                ValidationMessage.minLength: (_) =>
                                    tr('5 Please enter more than 5 characters'),
                                ValidationMessage.maxLength: (_) =>
                                    tr('Please enter within 20 characters'),
                              },
                            ),
                            onComplete: () async {
                              if (profileController.profileForm
                                  .control('displayName')
                                  .valid) {
                                final editedDisplayName = profileController
                                    .profileForm
                                    .control('displayName')
                                    .value;
                                if (editedDisplayName !=
                                    profileController.mUser.value.displayName) {
                                  final duplicated = await profileController
                                      .checkDuplicateUserName(
                                        editedDisplayName,
                                      );
                                  if (duplicated) {
                                    buildGetSnackbar(
                                      tr('The username already exists.'),
                                      tr('User name error.'),
                                    );
                                    profileController.profileForm
                                        .control('displayName')
                                        .reset();
                                  } else {
                                    Get.back();
                                    await profileController
                                        .updatedUserProfile();
                                    await profileController.setProfile();
                                  }
                                } else {
                                  Get.back();
                                }
                              } else {
                                buildGetSnackbar(
                                  tr('Please check the user name you entered'),
                                  tr('User name error.'),
                                );
                              }
                            },
                            explainText:
                                '${tr('Personal characters, numbers, _ (underscore), (dots))')}\n${tr('are available (5 or more characters, 20 characters)')}',
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: SizedBox(
                      width: 108,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [Text('${tr('Name')} |')],
                      ),
                    ),
                    trailing: const Icon(CupertinoIcons.pencil_circle),
                    title: Obx(
                      () => Text(profileController.mUser.value.firstName!),
                    ),
                    onTap: () {
                      Get.to(
                        () => EditTextScreen(
                          appBarTitle: tr('Name'),
                          textField: ReactiveTextField(
                            formControlName: 'firstName',
                            validationMessages: {
                              ValidationMessage.required: (_) =>
                                  tr('Please enter your name'),
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[^\s-]'),
                              ),
                            ],
                            decoration: InputDecoration(
                              hintText: tr('Name'),
                              labelText: tr('Name'),
                            ),
                          ),
                          onComplete: () async {
                            if (profileController.profileForm
                                .control('firstName')
                                .valid) {
                              final editFirstName = profileController
                                  .profileForm
                                  .control('firstName')
                                  .value;
                              if (editFirstName !=
                                  profileController.mUser.value.firstName) {
                                await profileController.updatedUserProfile();
                                await profileController.setProfile();
                                Get.back();
                              } else {
                                Get.back();
                              }
                            } else {
                              buildGetSnackbar(
                                tr(
                                  'Please review information that you have entered',
                                ),
                                tr('Name error'),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                  const Divider(height: 0),
                  Obx(
                    () => ListTile(
                      leading: SizedBox(
                        width: 108,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text('${tr('Surname')} |')],
                        ),
                      ),
                      trailing: const Icon(CupertinoIcons.pencil_circle),
                      title: Text(profileController.mUser.value.lastName!),
                      onTap: () async {
                        Get.to(
                          () => EditTextScreen(
                            appBarTitle: tr('Surname'),
                            textField: ReactiveTextField(
                              formControlName: 'lastName',
                              validationMessages: {
                                ValidationMessage.required: (_) =>
                                    tr('Please enter your surname'),
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[^\s-]'),
                                ),
                              ],
                              decoration: InputDecoration(
                                hintText: tr('Surname'),
                                labelText: tr('Surname'),
                              ),
                            ),
                            onComplete: () async {
                              if (profileController.profileForm
                                  .control('lastName')
                                  .valid) {
                                final editLastName = profileController
                                    .profileForm
                                    .control('lastName')
                                    .value;
                                if (editLastName !=
                                    profileController.mUser.value.lastName) {
                                  await profileController.updatedUserProfile();
                                  await profileController.setProfile();
                                  Get.back();
                                } else {
                                  Get.back();
                                }
                              } else {
                                buildGetSnackbar(
                                  tr(
                                    'Please review information that you have entered',
                                  ),
                                  tr('Surname error'),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 0),
                  Obx(
                    () => ListTile(
                      leading: SizedBox(
                        width: 108,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text('${tr('Self-introduction')} |')],
                        ),
                      ),
                      trailing: const Icon(CupertinoIcons.pencil_circle),
                      title: Text(profileController.mUser.value.bio!),
                      onTap: () async {
                        Get.to(
                          () => EditTextScreen(
                            appBarTitle: tr('Self-introduction'),
                            textField: ReactiveTextField(
                              formControlName: 'bio',
                              validationMessages: {
                                ValidationMessage.required: (_) =>
                                    tr('Self-introduction'),
                              },
                              maxLength: 120,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: tr('Self-introduction'),
                                labelText: tr('Self-introduction'),
                              ),
                              onSubmitted: (_) {},
                            ),
                            onComplete: () async {
                              if (profileController.profileForm
                                  .control('bio')
                                  .valid) {
                                final editBio = profileController.profileForm
                                    .control('bio')
                                    .value;
                                if (editBio !=
                                    profileController.mUser.value.bio) {
                                  await profileController.updatedUserProfile();
                                  await profileController.setProfile();
                                  Get.back();
                                } else {
                                  Get.back();
                                }
                              } else {
                                buildGetSnackbar(
                                  tr(
                                    'Please review information that you have entered',
                                  ),
                                  tr('Self-introduction error'),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 9.0,
                vertical: 18.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9.0),
                boxShadow: const [kDefaultShadow],
                color: CupertinoColors.white,
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(tr('Personal information settings')),
                    trailing: const Icon(CupertinoIcons.pencil_circle),
                    onTap: () {
                      Get.to(() => const EditPrivacyInfoScreen());
                    },
                  ),
                  const Divider(height: 0),
                  const SignOutAccountListTile(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
