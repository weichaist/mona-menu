import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_text_button.dart';
import 'package:url_launcher/url_launcher.dart';

Future<dynamic> buildVersionCheckDialog(String link) {
  return Get.defaultDialog(
    title: 'Mona Menu',
    content: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Text(tr('There is a new version')),
        ),
        const Icon(CupertinoIcons.app_badge, color: kPrimaryColor, size: 36),
      ],
    ),
    confirm: DefaultTextButton(
      label: tr('Update Soon'),
      onPressed: () {
        launchURL(link);
      },
    ),
  );
}

void launchURL(String link) async {
  final url = Uri.parse(link);
  await canLaunchUrl(url)
      ? await launchUrl(url)
      : throw 'Could not launch $link';
}
