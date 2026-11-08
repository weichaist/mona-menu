import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';

class OverviewCard extends StatelessWidget {
  final Widget topWidget;
  final Widget bottomWidget;
  const OverviewCard({
    super.key,
    required this.topWidget,
    required this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [kDefaultShadow],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [topWidget, bottomWidget],
      ),
    );
  }
}
