import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/menu_controller.dart';
import 'package:mona_console/screens/setting_screen/components/lunch_menu_body.dart';

class EditLunchMenuScreen extends StatelessWidget {
  const EditLunchMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuController = RestaurantMenuController.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ランチメニュー', style: TextStyle(color: kAppBarTextColor)),
        elevation: 1.5,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await menuController.saveMenuSettings();
        },
        backgroundColor: kRestaurantColor,
        child: const Icon(CupertinoIcons.floppy_disk),
      ),
      body: const LunchBody(),
    );
  }
}
