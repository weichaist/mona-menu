import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CustomSettingTileWithToggleSwitch extends StatelessWidget {
  final int initLabelIndex;
  final List<String> labels;
  final void Function(int? index) onToggle;
  final String title;
  const CustomSettingTileWithToggleSwitch({
    super.key,
    required this.initLabelIndex,
    required this.labels,
    required this.onToggle,
    required this.title,
  });
  @override
  Widget build(BuildContext context) {
    return SettingTileWithToggleSwitch(
      title: title,
      toggleSwitch: ToggleSwitch(
        minWidth: 90.0,
        cornerRadius: 18.0,
        activeBgColors: const [
          [kRestaurantColor],
          [CupertinoColors.systemGrey],
        ],
        activeFgColor: Colors.white,
        inactiveBgColor: CupertinoColors.systemGrey3,
        inactiveFgColor: Colors.white,
        initialLabelIndex: initLabelIndex,
        totalSwitches: 2,
        labels: labels,
        radiusStyle: true,
        onToggle: onToggle,
      ),
    );
  }
}

class SettingTileWithToggleSwitch extends StatelessWidget {
  final Widget toggleSwitch;
  final String title;
  const SettingTileWithToggleSwitch({
    super.key,
    required this.title,
    required this.toggleSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [toggleSwitch],
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: kBodyTextColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
