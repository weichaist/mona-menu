import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/micro_data_controller.dart';
import 'package:mona_diner/screens/top_level_components/buttons/primary_full_width_button.dart';
import 'package:mona_diner/size_config.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_get_snackbar.dart';

Future<dynamic> buildReportContentBottomSheet(
  String contentCategory,
  String contentId,
) {
  return Get.bottomSheet(
    Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              tileColor: Colors.white,
              leading: const Icon(
                CupertinoIcons.flag_circle,
                color: CupertinoColors.systemRed,
              ),
              title: Text(
                tr('Report'),
                style: const TextStyle(
                  color: kBodyTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Get.back();
                buildReportDialog(contentCategory, contentId);
              },
            ),
            const Divider(height: 0),
            ListTile(
              tileColor: Colors.white,
              leading: const Icon(Icons.arrow_drop_down, color: kBodyTextColor),
              title: const Text(
                'Close',
                style: TextStyle(
                  color: kBodyTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Get.back();
              },
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    ),
  );
}

void buildReportDialog(String contentCategory, String contentId) async {
  final microController = MicroDataController.instance;
  String reason = '';
  Get.defaultDialog(
    title: tr('Please choose the reason to report'),
    content: ReasonToReportListContainer(
      onTap: (reason) {
        reason = reason;
      },
    ),
    confirm: PrimaryFullWidthButton(
      onTap: () async {
        if (reason.isNotEmpty) {
          await microController.sendContentReport({
            'category': contentCategory,
            'id': contentId,
            'reason': reason,
          });
          Get.back();
        } else {
          buildGetSnackbar(tr('Please choose the reason'), '🙅🏻‍♂️');
        }
      },
      centerWidget: Text(
        tr('Send'),
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}

class ReasonToReportListContainer extends StatefulWidget {
  const ReasonToReportListContainer({super.key, required this.onTap});
  final Function(String) onTap;
  @override
  State<ReasonToReportListContainer> createState() =>
      _ReasonToReportListContainerState();
}

class _ReasonToReportListContainerState
    extends State<ReasonToReportListContainer> {
  String reasonToReport = '';
  List<String> reasons = [
    tr('Spam'),
    tr('Sexual Harassment'),
    tr('Annoyance'),
    tr('Copyright Infringement'),
    tr('Others'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: getScreenHeight() / 2.1,
      width: getScreenWidth() / 1.2,
      child: ListView.builder(
        itemBuilder: (context, index) {
          final reason = reasons[index];
          return CheckboxListTile(
            checkColor: Colors.white,
            activeColor: kPrimaryColor,
            value: reasonToReport == reason,
            onChanged: (selected) {
              reasonToReport = reason;
              widget.onTap(reasonToReport);
              setState(() {});
            },
            title: Text(reason),
          );
        },
        itemCount: reasons.length,
      ),
    );
  }
}
