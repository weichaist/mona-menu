import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/screens/auth_screen/forget_password_screen.dart';

class ForgetPasswordTextButton extends StatelessWidget {
  const ForgetPasswordTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const ForgetPasswordScreen());
      },
      child: const Text(
        'パスワードをお忘れですか？',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: kRestaurantColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
