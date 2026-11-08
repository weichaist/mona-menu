import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/size_config.dart';

class MutedEmptyListContainer extends StatelessWidget {
  const MutedEmptyListContainer({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      width: getScreenWidth(),
      margin: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9.0),
        boxShadow: const [kDefaultShadow],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              height: 24,
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
