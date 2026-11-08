import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/home_controller.dart';
import 'package:mona_console/controllers/menu_controller.dart';
import 'package:mona_console/controllers/setting_controller.dart';
import 'package:mona_console/screens/home_screen/components/profile_image_container.dart';
import 'package:mona_console/screens/onboarding_screens/components/bg_image_container.dart';
import 'package:mona_console/size_config.dart';
import 'package:mona_console/top_level_components/buttons/default_icon_button.dart';
import 'package:mona_console/top_level_components/buttons/primary_full_width_button.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_confirmation_dialog.dart';
import 'package:mona_console/top_level_components/utils/pick_gallary_image.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditBasicInfoScreen extends StatelessWidget {
  const EditBasicInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingController = SettingController.instance;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await settingController.saveEditBasicInfoScreen();
        },
        backgroundColor: kRestaurantColor,
        child: const Icon(CupertinoIcons.floppy_disk),
      ),
      appBar: AppBar(
        title: const Text('基本情報を編集', style: TextStyle(color: kAppBarTextColor)),
        actions: const [SignOutActionButton()],
      ),
      body: const Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});
  @override
  Widget build(BuildContext context) {
    final settingController = SettingController.instance;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: getScreenHeight(),
          width: getScreenWidth() / 3 * 2,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const PictureSettingSection(),
                const SizedBox(height: 36),
                ReactiveForm(
                  formGroup: settingController.basicInfoForm,
                  child: Column(
                    children: <Widget>[
                      ReactiveTextField(
                        formControlName: 'name',
                        decoration: const InputDecoration(
                          hintText: 'ご店名 ※',
                          labelText: 'ご店名 ※',
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) => 'ご店名を入力してください',
                        },
                        onSubmitted: (_) {
                          settingController.basicInfoForm.unfocus();
                        },
                      ),
                      const SizedBox(height: 36),
                      ReactiveTextField(
                        formControlName: 'address',
                        decoration: const InputDecoration(
                          hintText: 'ご住所 ※',
                          labelText: 'ご住所 ※',
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) => 'ご住所を入力してください',
                        },
                        onSubmitted: (_) {
                          settingController.basicInfoForm.unfocus();
                        },
                      ),
                      const SizedBox(height: 36),
                      ReactiveTextField(
                        formControlName: 'phoneNumber',
                        decoration: const InputDecoration(
                          hintText: '予約・問い合わせ用電話番号 ※',
                          labelText: '予約・問い合わせ用電話番号 ※',
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) => '電話番号を入力してください',
                        },
                        onSubmitted: (_) {
                          settingController.basicInfoForm.unfocus();
                        },
                      ),
                      const SizedBox(height: 36),
                      ReactiveTextField(
                        formControlName: 'genre',
                        decoration: const InputDecoration(
                          hintText: 'ジャンル ※',
                          labelText: 'ジャンル ※',
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) => 'ジャンルを入力してください',
                        },
                        onSubmitted: (_) {
                          settingController.basicInfoForm.unfocus();
                        },
                      ),
                      const SizedBox(height: 36),
                      ReactiveTextField(
                        formControlName: 'lat',
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: '位置情報（例: 35.7075066,139.7582473）※',
                          labelText: '位置情報（例: 35.7075066,139.7582473）※',
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) => '位置情報は必須です',
                        },
                      ),
                      const SizedBox(height: 36),
                      ReactiveTextField(
                        formControlName: 'lng',
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: '位置情報（例: 35.7075066,139.7582473）※',
                          labelText: '位置情報（例: 35.7075066,139.7582473）※',
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) => '位置情報は必須です',
                        },
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PictureSettingSection extends StatelessWidget {
  const PictureSettingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final settingController = SettingController.instance;
    return Obx(
      () => Column(
        children: [
          GestureDetector(
            onTap: () async {
              File? image = await PickGalleryImage().getImageFromGallery(1, 1);
              if (image != null) {
                settingController.profilePictureUrl.value = image.path;
              }
            },
            child: ProfileImageContainer(
              radius: 84,
              imageUrl: settingController.profilePictureUrl.value,
            ),
          ),
          const SizedBox(height: 36),
          GestureDetector(
            onTap: () async {
              File? image = await PickGalleryImage().getImageFromGallery(
                21,
                10,
              );
              if (image != null) {
                settingController.bgPictureUrl.value = image.path;
              }
            },
            child: BgImageContainer(
              imageUrl: settingController.bgPictureUrl.value,
            ),
          ),
        ],
      ),
    );
  }
}

class SignOutActionButton extends StatelessWidget {
  const SignOutActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final settingController = SettingController.instance;
    final menuController = RestaurantMenuController.instance;
    final homeController = HomeController.instance;
    return DefaultIconButton(
      icon: Icons.more_horiz_rounded,
      onTap: () {
        Get.defaultDialog(
          title: 'Mona',
          content: SizedBox(
            width: getScreenWidth() / 3,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: PrimaryFullWidthButton(
                onTap: () async {
                  final res = await buildConfirmationDialog();
                  if (res ?? false) {
                    FirebaseAuth.instance.signOut();
                    Get.offAllNamed('/auth');
                    settingController.resetSettingVariables();
                    menuController.resetMenuController();
                    homeController.resetHomeController();
                  } else {
                    Get.back();
                  }
                },
                centerWidget: const Text(
                  'ログアウト',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
