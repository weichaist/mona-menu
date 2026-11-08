import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/profile_controller.dart';
import 'package:mona_diner/models/bank_accout_model.dart';
import 'package:mona_diner/screens/profile_screen/components/select_account_type_chips.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_text_button.dart';
import 'package:mona_diner/screens/top_level_components/buttons/full_width_icon_text_button.dart';
import 'package:mona_diner/size_config.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditBankAccountScreen extends StatelessWidget {
  const EditBankAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = ProfileController.instance;
    profileController.initFetchAccountPrivacyData();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('Reward Receipt'),
          style: const TextStyle(color: kAppBarTextColor),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              child: Column(
                children: [
                  Text(
                    tr(
                      'Please register your account information to receive the reward',
                    ),
                    style: const TextStyle(
                      color: kAppBarTextColor,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '* ${tr('If the result reward is 10,000 yen or more, it will be possible to transfer.')}',
                    style: const TextStyle(
                      color: kAppBarTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (profileController.userBankAccount.value.accNumber == null) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  child: FullWidthIconTextButton(
                    icon: Icons.account_balance_outlined,
                    label: tr('Register a bank account'),
                    backgroundColor: kPrimaryColor,
                    labelColor: Colors.white,
                    iconColor: Colors.white,
                    onTap: () {
                      buildBankAccountBottomSheet();
                    },
                  ),
                );
              } else {
                return Column(
                  children: [
                    const Divider(color: kPrimaryColor, height: 0),
                    ListTile(
                      leading: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.account_balance_outlined,
                            color: kPrimaryColor,
                          ),
                        ],
                      ),
                      title: Text(
                        profileController.userBankAccount.value.bankName!,
                      ),
                      subtitle: Text(
                        '${profileController.userBankAccount.value.branch!} ${profileController.userBankAccount.value.accNumber!}',
                      ),
                      trailing: const Icon(CupertinoIcons.pencil_circle),
                      onTap: () {
                        buildBankAccountBottomSheet(
                          bankAccount: profileController.userBankAccount.value,
                        );
                      },
                    ),
                    const Divider(color: kPrimaryColor, height: 0),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Future<dynamic> buildBankAccountBottomSheet({UserBankAccount? bankAccount}) {
    final profileController = ProfileController.instance;
    if (bankAccount != null) {
      profileController.bankInfoForm.value = bankAccount.toMap();
    }
    return Get.bottomSheet(
      SafeArea(
        bottom: false,
        minimum: const EdgeInsets.only(top: 48),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
          ),
          height: getScreenHeight() * 0.72,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(CupertinoIcons.clear_circled),
                  trailing: DefaultTextButton(
                    label: tr('Completion'),
                    onPressed: () async {
                      if (profileController.bankInfoForm.valid) {
                        profileController.userBankAccount.value =
                            UserBankAccount.fromFirestore(
                              profileController.bankInfoForm.value,
                            );
                        await profileController.updateUserPrivacyData({
                          'bankInfo': profileController.bankInfoForm.value,
                        });
                        Get.back();
                        profileController.bankInfoForm.reset();
                      }
                    },
                  ),
                  onTap: () {
                    Get.back();
                    profileController.bankInfoForm.reset();
                  },
                ),
                ReactiveForm(
                  formGroup: profileController.bankInfoForm,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Column(
                      children: <Widget>[
                        ReactiveTextField(
                          formControlName: 'bankName',
                          validationMessages: {
                            ValidationMessage.required: (_) => tr(
                              'Please enter the financial institution name',
                            ),
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[^\s-]'),
                            ),
                          ],
                          decoration: InputDecoration(
                            hintText: tr('Financial institution name ※'),
                            labelText: tr('Financial institution name ※'),
                          ),
                          onSubmitted: (_) {
                            profileController.bankInfoForm.focus('branch');
                          },
                        ),
                        const SizedBox(height: 18),
                        ReactiveTextField(
                          formControlName: 'branch',
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                                tr('Please enter the branch name'),
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[^\s-]'),
                            ),
                          ],
                          decoration: InputDecoration(
                            hintText: tr('Branch name ※'),
                            labelText: tr('Branch name ※'),
                          ),
                          onSubmitted: (_) {
                            profileController.bankInfoForm.unfocus;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: SelectAccountTypeChips(
                            type: profileController.bankInfoForm
                                .control('accType')
                                .value,
                            accountType: (String val) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              profileController.bankInfoForm
                                      .control('accType')
                                      .value =
                                  val;
                              profileController.bankInfoForm.focus('accNumber');
                            },
                          ),
                        ),
                        ReactiveTextField(
                          formControlName: 'accNumber',
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                                tr('Please enter your account number'),
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[^\s-]'),
                            ),
                          ],
                          decoration: InputDecoration(
                            hintText: tr('Account Number ※'),
                            labelText: tr('Account Number ※'),
                          ),
                          onSubmitted: (_) {
                            profileController.bankInfoForm.focus('');
                          },
                        ),
                        const SizedBox(height: 18),
                        ReactiveTextField(
                          formControlName: 'accName',
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                                tr('Please enter the account name (Kana)'),
                          },
                          decoration: InputDecoration(
                            hintText: tr('Account holder name (Kana)'),
                            labelText: tr('Account holder name (Kana)'),
                          ),
                          onSubmitted: (_) {
                            profileController.bankInfoForm.unfocus();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
