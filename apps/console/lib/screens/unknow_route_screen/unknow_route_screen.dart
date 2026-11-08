import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/top_level_components/buttons/default_icon_button.dart';

class UnKnowRouteScreen extends StatelessWidget {
  const UnKnowRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'エラーが発生しました..',
          style: TextStyle(color: kAppBarTextColor, fontSize: 18),
        ),
        actions: [
          DefaultIconButton(
            onTap: () {
              Get.offAllNamed('/');
            },
            icon: CupertinoIcons.refresh_bold,
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 360,
          height: 360,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/error-404.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
