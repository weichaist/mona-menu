import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/profile_controller.dart';
import 'package:mona_diner/screens/profile_screen/sub_screens/edit_text_screen.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_text_button.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_get_snackbar.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditPrivacyInfoScreen extends StatelessWidget {
  const EditPrivacyInfoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    ProfileController profileController = ProfileController.instance;
    profileController.initFetchAccountPrivacyData();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('Edit Personal Information'),
          style: const TextStyle(color: kAppBarTextColor),
        ),
        actions: [
          DefaultTextButton(
            label: tr('Completion'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      tr(
                        'This information is not displayed in the public profile.',
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        color: kBodyTextColor,
                      ),
                    ),
                  ),
                ],
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
                        width: 84,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text('${tr('Phone Number')} |')],
                        ),
                      ),
                      trailing: const Icon(CupertinoIcons.lock),
                      title: Text(profileController.phoneNumber.value),
                      onTap: () {},
                    ),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: GestureDetector(
                      onTap: () {},
                      child: Obx(
                        () => Icon(
                          CupertinoIcons.checkmark_seal_fill,
                          color: profileController.emailVerified.value
                              ? Colors.green
                              : kAppBarTextColor,
                        ),
                      ),
                    ),
                    trailing: const Icon(CupertinoIcons.pencil_circle),
                    title: Obx(() => Text(profileController.email.value)),
                    onTap: () {
                      profileController.profileForm.value = {
                        'email': profileController.email.value,
                      };
                      Get.to(
                        () => EditTextScreen(
                          appBarTitle: tr('Email address'),
                          textField: ReactiveTextField(
                            formControlName: 'email',
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: tr('Email address'),
                            ),
                            validationMessages: {
                              ValidationMessage.required: (_) =>
                                  tr('Enter the Email address'),
                              ValidationMessage.email: (_) => tr(
                                'Please enter the Email address correctly',
                              ),
                            },
                          ),
                          onComplete: () async {
                            if (profileController.profileForm
                                .control('email')
                                .valid) {
                              final editEmail = profileController.profileForm
                                  .control('email')
                                  .value;
                              if (editEmail != profileController.email.value) {
                                await profileController.updateUserPrivacyData({
                                  'email': editEmail,
                                });
                                await profileController
                                    .initFetchAccountPrivacyData();
                                Get.back();
                              } else {
                                Get.back();
                              }
                            } else {
                              buildGetSnackbar(
                                tr(
                                  'Please review information that you have entered',
                                ),
                                tr('Email address error'),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
