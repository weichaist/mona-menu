import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/setting_controller.dart';
import 'package:mona_console/screens/setting_screen/components/build_table_number_bottom_sheet.dart';
import 'package:mona_console/size_config.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_confirmation_dialog.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_get_snackbar.dart';

class EditTableNumberScreen extends StatelessWidget {
  const EditTableNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingController = SettingController.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'テーブル番号を編集',
          style: TextStyle(color: kAppBarTextColor),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (settingController.tableNumbers.isNotEmpty) {
            await settingController.saveTableNumbers();
          } else {
            buildGetSnackbar('テーブル番号を追加してください', 'テーブル番号エラー');
          }
        },
        backgroundColor: kRestaurantColor,
        child: const Icon(CupertinoIcons.floppy_disk),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: getScreenHeight(),
            width: getScreenWidth() / 3 * 2,
            margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [kDefaultShadow],
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('テーブル番号を追加'),
                  leading: const Icon(
                    CupertinoIcons.pencil_circle,
                    color: kRestaurantColor,
                  ),
                  trailing: const Icon(
                    CupertinoIcons.add_circled,
                    color: kRestaurantColor,
                  ),
                  onTap: () async {
                    final res = await buildTableNumberBottomSheet(null);
                    if (res != null) {
                      settingController.tableNumbers.add(res);
                    }
                  },
                ),
                const Divider(color: kRestaurantColor, height: 0),
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                settingController.tableNumbers[index],
                              ),
                              trailing: const Icon(
                                CupertinoIcons.delete,
                                size: 18,
                              ),
                              onTap: () async {
                                final res = await buildConfirmationDialog();
                                if (res ?? false) {
                                  settingController.tableNumbers.remove(
                                    settingController.tableNumbers[index],
                                  );
                                }
                              },
                            ),
                            const Divider(height: 0),
                          ],
                        );
                      },
                      itemCount: settingController.tableNumbers.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
