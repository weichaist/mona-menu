import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_icon_button.dart';

Future<dynamic> buildNetworkErrorDialog({VoidCallback? callback}) async {
  return Get.defaultDialog(
    title: 'Mona Menu',
    cancel: DefaultIconButton(
      icon: CupertinoIcons.clear_circled,
      onTap: () {
        if (callback != null) {
          callback();
        } else {
          Get.back();
        }
      },
    ),
    content: Column(
      children: [
        Container(
          width: 240,
          height: 240,
          margin: const EdgeInsets.all(36),
          child: SvgPicture.asset(
            'assets/images/no-wifi.svg',
            colorFilter: const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
            height: 180,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Text(
            tr('Please check the status of the network connection'),
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
