import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/setting_controller.dart';
import 'package:mona_console/size_config.dart';
import 'package:mona_console/top_level_components/buttons/default_icon_button.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_confirmation_dialog.dart';
import 'package:mona_console/top_level_components/utils/time_picker.dart';

class EditBusinessHourScreen extends StatelessWidget {
  const EditBusinessHourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingController = SettingController.instance;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await settingController.uploadBusinessHourList();
        },
        backgroundColor: kRestaurantColor,
        child: const Icon(CupertinoIcons.floppy_disk),
      ),
      appBar: AppBar(
        title: const Text('営業時間', style: TextStyle(color: kAppBarTextColor)),
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
      body: const Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: getScreenHeight(),
          width: getScreenWidth(),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 96),
            itemBuilder: (context, index) {
              return BusinessHourEditContainer(index: index);
            },
            itemCount: 7,
          ),
        ),
      ],
    );
  }
}

String convertWeekdayNumToString(int weekday) {
  switch (weekday) {
    case 1:
      return '月曜日';
    case 2:
      return '火曜日';
    case 3:
      return '水曜日';
    case 4:
      return '木曜日';
    case 5:
      return '金曜日';
    case 6:
      return '土曜日';
    case 7:
      return '日曜日';
    default:
      return '曜日';
  }
}

String timeIntToString(int timeInt) {
  if (timeInt < 10) {
    return '0$timeInt';
  } else {
    return '$timeInt';
  }
}

class BusinessHourEditContainer extends StatelessWidget {
  const BusinessHourEditContainer({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    final settingController = SettingController.instance;
    final businessHour = settingController.businessHourList[index];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [kDefaultShadow],
      ),
      child: Obx(
        () => Column(
          children: [
            Obx(
              () => SwitchListTile(
                title: Text(
                  convertWeekdayNumToString(businessHour.value.weekday!),
                ),
                subtitle: businessHour.value.isBusinessDay!
                    ? const Text('営業時間')
                    : const Text('営業時間外'),
                value: businessHour.value.isBusinessDay!,
                activeThumbColor: kRestaurantColor,
                onChanged: (bool val) async {
                  final res = await buildConfirmationDialog(
                    title: '編集状態を切り替えますか？',
                  );
                  if (res ?? false) {
                    if (!val) {
                      settingController.resetBusinessHour(index);
                    }
                    settingController.setIsBusinessDay(index, val);
                  }
                },
              ),
            ),
            if (businessHour.value.isBusinessDay!)
              const Divider(color: kRestaurantLightColor),
            if (businessHour.value.isBusinessDay!)
              SwitchListTile(
                title: const Text('ランチ営業'),
                activeThumbColor: kRestaurantColor,
                value: businessHour.value.lunchOpen!,
                onChanged: (bool val) {
                  settingController.setLunchOpen(index, val);
                },
              ),
            if (businessHour.value.isBusinessDay! &&
                businessHour.value.lunchOpen!)
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      onTap: () {
                        buildTimePicker(context, (time) {
                          settingController.setLunchOpenTime(index, time);
                        });
                      },
                      title: const Text('ランチ開始時間'),
                      subtitle: Text(
                        '${timeIntToString(businessHour.value.lunchStartHour!)}:${timeIntToString(businessHour.value.lunchStartMinute!)}',
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      onTap: () {
                        buildTimePicker(context, (time) {
                          settingController.setLunchFinishTime(index, time);
                        });
                      },
                      title: const Text('ランチ終了時間'),
                      subtitle: Text(
                        '${timeIntToString(businessHour.value.lunchFinishHour!)}:${timeIntToString(businessHour.value.lunchFinishMinute!)}',
                      ),
                    ),
                  ),
                ],
              ),
            if (businessHour.value.isBusinessDay!)
              const Divider(color: kRestaurantLightColor),
            if (businessHour.value.isBusinessDay!)
              SwitchListTile(
                title: const Text('ディナー営業'),
                activeThumbColor: kRestaurantColor,
                value: businessHour.value.dinnerOpen!,
                onChanged: (bool val) {
                  settingController.setDinnerOpen(index, val);
                },
              ),
            if (businessHour.value.isBusinessDay! &&
                businessHour.value.dinnerOpen!)
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      onTap: () {
                        buildTimePicker(context, (time) {
                          settingController.setDinnerOpenTime(index, time);
                        });
                      },
                      title: const Text('ディナー開始時間'),
                      subtitle: Text(
                        '${timeIntToString(businessHour.value.dinnerStartHour!)}:${timeIntToString(businessHour.value.dinnerStartMinute!)}',
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      onTap: () {
                        buildTimePicker(context, (time) {
                          settingController.setDinnerFinishTime(index, time);
                        });
                      },
                      title: const Text('ディナー終了時間'),
                      subtitle: Text(
                        '${timeIntToString(businessHour.value.dinnerFinishHour!)}:${timeIntToString(businessHour.value.dinnerFinishMinute!)}',
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
