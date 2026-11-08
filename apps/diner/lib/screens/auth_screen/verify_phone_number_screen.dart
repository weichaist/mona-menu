import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/auth_controller.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_text_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyPhoneNumberScreen extends StatelessWidget {
  const VerifyPhoneNumberScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('Login'))),
      body: const Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});
  @override
  Widget build(BuildContext context) {
    AuthController authController = AuthController.instance;
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                '${tr('Please enter the')}\n${tr('code sent to your mobile phone')}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 48, top: 18),
              child: Text(
                authController.userPhoneNumber.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: MaterialPinField(
                length: 6,
                keyboardType: TextInputType.number,
                theme: MaterialPinTheme(
                  shape: MaterialPinShape.outlined,
                  cellSize: const Size(36, 36),
                  borderRadius: BorderRadius.circular(18),
                  fillColor: Colors.white,
                  focusedFillColor: Colors.white,
                  filledFillColor: Colors.transparent,
                  borderColor: kPrimaryLightColor,
                  focusedBorderColor: kPrimaryLightColor,
                  filledBorderColor: kPrimaryColor,
                  entryAnimation: MaterialPinAnimation.fade,
                  animationDuration: const Duration(milliseconds: 300),
                ),
                onChanged: (val) {
                  authController.smsCode.value = val;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: GestureDetector(
                onTap: () async {
                  await authController.sendPhoneVerificationCode();
                },
                child: Text(
                  tr('Reactivate the code'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            DefaultTextButton(
              label: tr('Login'),
              fontSize: 18,
              bgColor: kPrimaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 9),
              color: Colors.white,
              onPressed: () async {
                FocusManager.instance.primaryFocus!.unfocus();
                await authController.phoneSignIn();
              },
            ),
          ],
        ),
      ),
    );
  }
}
