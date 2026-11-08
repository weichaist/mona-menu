import 'package:flutter/material.dart';
import 'package:mona_console/screens/auth_screen/sections/email_sign_in_screen_main_section.dart';
import 'package:mona_console/screens/auth_screen/sections/sign_in_screen_decoration_section.dart';
import 'package:mona_console/size_config.dart';

class EmailSignInScreen extends StatelessWidget {
  const EmailSignInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SignInScreenDecorationSection(),
          EmailSignInScreenSection(),
        ],
      ),
    );
  }
}
