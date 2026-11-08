import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';

class LogoText extends StatelessWidget {
  const LogoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 48,
          height: 48,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: const [kDefaultShadow],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/images/mona_restaurant_logo.png'),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Mona Menu 管理コンソール',
          style: TextStyle(
            color: kRestaurantColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
