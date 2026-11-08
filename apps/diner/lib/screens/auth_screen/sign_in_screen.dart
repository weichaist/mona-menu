import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/auth_controller.dart';
import 'package:mona_diner/screens/auth_screen/components/sign_in_form.dart';
import 'package:mona_diner/screens/auth_screen/verify_phone_number_screen.dart';
import 'package:mona_diner/screens/home_screen/components/build_term_condition_url.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_text_button.dart';
import 'package:mona_diner/size_config.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_get_snackbar.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    AuthController authController = AuthController.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mona Menu ${tr('Log in to')}',
          style: const TextStyle(color: kAppBarTextColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: getScreenWidth() / 3.6,
                    width: getScreenWidth() / 3.6,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/mona_menu_logo_s.png'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      tr('Unprecedented order experience, appearance'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: 24,
                top: 24,
                bottom: 24,
              ),
              child: SignInForm(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextButton(
                  label: tr('Next'),
                  fontSize: 18,
                  bgColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 9,
                  ),
                  color: Colors.white,
                  onPressed: () async {
                    FocusManager.instance.primaryFocus!.unfocus();
                    if (authController.userPhoneNumber.isNotEmpty) {
                      await authController.sendPhoneVerificationCode();
                      Get.to(() => const VerifyPhoneNumberScreen());
                    } else {
                      buildGetSnackbar(
                        tr('Please enter your phone number'),
                        '${tr('Phone number error')}..',
                      );
                    }
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: GestureDetector(
                onTap: () {
                  launchTermsConditionURL();
                },
                child: Text(
                  '${tr('By proceeding,')}\n${tr('You agree to the terms of use')}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kAppBarTextColor,
                    fontSize: getProportionateScreenHeight(12),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
