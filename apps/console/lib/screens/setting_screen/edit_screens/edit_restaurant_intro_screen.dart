import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/setting_controller.dart';
import 'package:mona_console/size_config.dart';
import 'package:mona_console/top_level_components/buttons/default_icon_button.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_confirmation_dialog.dart';

class EditRestaurantIntroScreen extends StatelessWidget {
  const EditRestaurantIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingController = SettingController.instance;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusManager.instance.primaryFocus!.unfocus();
          if (settingController.readyToUpload()) {
            settingController.uploadIntro();
          } else {
            EasyLoading.showError('自分のお店のこだわりをお客様に伝えましょう！');
          }
        },
        backgroundColor: kRestaurantColor,
        child: const Icon(CupertinoIcons.floppy_disk),
      ),
      appBar: AppBar(
        title: const Text('店舗紹介', style: TextStyle(color: kAppBarTextColor)),
        automaticallyImplyLeading: false,
        leading: DefaultIconButton(
          icon: Icons.arrow_back_ios,
          onTap: () async {
            final res = await buildConfirmationDialog(title: 'このページから移動しますか？');
            if (res ?? false) {
              Get.back();
            }
          },
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // height: getScreenHeight(),
            width: getScreenWidth() / 3 * 2,
            margin: const EdgeInsets.symmetric(vertical: 18),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [kDefaultShadow],
            ),
            child: TextField(
              controller: settingController.introController,
              maxLines: 9,
              // autofocus: true,
              decoration: const InputDecoration(hintText: '店舗について'),
            ),
          ),
        ],
      ),
    );
  }
}
