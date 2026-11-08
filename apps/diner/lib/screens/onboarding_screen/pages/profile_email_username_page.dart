import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/onboard_controller.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_get_snackbar.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EmailUsernamePage extends StatelessWidget {
  const EmailUsernamePage({super.key});
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
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 24,
                  ),
                  child: Text(
                    tr('1/3 Create profile'),
                    style: const TextStyle(
                      color: kAppBarTextColor,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 12.0,
                  ),
                  child: ReactiveForm(
                    formGroup: onboardController.onboardingForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: Text(
                            tr('Add an email address'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: kAppBarTextColor,
                            ),
                          ),
                        ),
                        ReactiveTextField(
                          formControlName: 'email',
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: tr('Email address'),
                          ),
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                                tr('Enter the Email address'),
                            ValidationMessage.email: (_) =>
                                tr('Please enter the Email address correctly'),
                          },
                          onSubmitted: (_) => onboardController.onboardingForm
                              .focus('displayName'),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          tr('Create username'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: kAppBarTextColor,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 9),
                          child: Text(
                            '${tr('Personal characters, numbers, _ (underscore), (dots))')}\n${tr('are available (5 or more characters, 20 characters)')}',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 12,
                              color: kAppBarTextColor,
                            ),
                          ),
                        ),
                        ReactiveTextField(
                          formControlName: 'displayName',
                          decoration: InputDecoration(hintText: tr('Username')),
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
                          onSubmitted: (_) async {
                            if (onboardController.onboardingForm
                                .control('displayName')
                                .valid) {
                              final duplicated = await onboardController
                                  .checkDuplicateUserName(
                                    onboardController.onboardingForm
                                        .control('displayName')
                                        .value,
                                  );
                              if (duplicated) {
                                buildGetSnackbar(
                                  tr('The username already exists.'),
                                  tr('User name error'),
                                );
                                onboardController.onboardingForm
                                    .control('displayName')
                                    .reset();
                              } else {
                                onboardController.onboardingForm
                                    .control('displayName')
                                    .unfocus();
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 96),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: FloatingActionButton(
              onPressed: () async {
                if (onboardController.onboardingForm
                        .control('displayName')
                        .valid &&
                    onboardController.onboardingForm.control('email').valid) {
                  final duplicated = await onboardController
                      .checkDuplicateUserName(
                        onboardController.onboardingForm
                            .control('displayName')
                            .value,
                      );
                  if (duplicated) {
                    buildGetSnackbar(
                      tr('The username already exists.'),
                      tr('User name error'),
                    );
                    onboardController.onboardingForm
                        .control('displayName')
                        .reset();
                  } else {
                    onboardController.onboardingForm
                        .control('displayName')
                        .unfocus();
                    onboardController.pageController.nextPage(
                      duration: kDefaultDuration,
                      curve: Curves.easeInCirc,
                    );
                    onboardController.onboardingForm.focus('firstName');
                  }
                } else {
                  buildGetSnackbar(
                    tr('Check the input information again.'),
                    tr('Profile creation error'),
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
