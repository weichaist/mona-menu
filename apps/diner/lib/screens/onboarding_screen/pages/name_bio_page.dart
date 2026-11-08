import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/onboard_controller.dart';
import 'package:mona_diner/screens/top_level_components/buttons/primary_full_width_button.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_get_snackbar.dart';
import 'package:reactive_forms/reactive_forms.dart';

class NameBioPage extends StatelessWidget {
  const NameBioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardController = OnboardController.instance;
    return Unfocuser(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [kDefaultShadow],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 24,
                ),
                child: Text(
                  tr('3/3 Create profile'),
                  style: const TextStyle(color: kAppBarTextColor, fontSize: 18),
                ),
              ),
              const SizedBox(height: 36),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ReactiveForm(
                  formGroup: onboardController.onboardingForm,
                  child: Column(
                    children: <Widget>[
                      ReactiveTextField(
                        formControlName: 'firstName',
                        validationMessages: {
                          ValidationMessage.required: (_) =>
                              tr('Please enter your name'),
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[^\s-]')),
                        ],
                        decoration: InputDecoration(
                          hintText: tr('Name'),
                          labelText: tr('Name'),
                        ),
                        onSubmitted: (_) {
                          onboardController.onboardingForm.focus('lastName');
                        },
                      ),
                      const SizedBox(height: 36),
                      ReactiveTextField(
                        formControlName: 'lastName',
                        validationMessages: {
                          ValidationMessage.required: (_) =>
                              tr('Please enter your surname'),
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[^\s-]')),
                        ],
                        decoration: InputDecoration(
                          hintText: tr('Surname'),
                          labelText: tr('Surname'),
                        ),
                        onSubmitted: (_) {
                          onboardController.onboardingForm.focus('bio');
                        },
                      ),
                      const SizedBox(height: 36),
                      ReactiveTextField(
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
                      const SizedBox(height: 36),
                      ReactiveFormConsumer(
                        builder: (context, form, child) {
                          return PrimaryFullWidthButton(
                            centerWidget: const Text(
                              '完了',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () async {
                              if (form.valid) {
                                await onboardController.updatedUserProfile();
                              } else {
                                buildGetSnackbar(
                                  tr('Check the input information again.'),
                                  tr('Profile creation error'),
                                );
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
