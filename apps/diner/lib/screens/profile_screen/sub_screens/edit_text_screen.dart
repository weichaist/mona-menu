import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/profile_controller.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_text_button.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditTextScreen extends StatelessWidget {
  const EditTextScreen({
    super.key,
    required this.appBarTitle,
    required this.textField,
    this.explainText,
    required this.onComplete,
  });
  final String appBarTitle;
  final ReactiveTextField textField;
  final String? explainText;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final profileController = ProfileController.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: const TextStyle(color: kAppBarTextColor),
        ),
        actions: [
          DefaultTextButton(label: tr('Completion'), onPressed: onComplete),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ReactiveForm(
                formGroup: profileController.profileForm,
                child: textField,
              ),
            ),
            if (explainText != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        explainText!,
                        style: const TextStyle(
                          fontSize: 12.6,
                          color: kBodyTextColor,
                        ),
                      ),
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
