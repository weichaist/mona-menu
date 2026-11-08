import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/auth_controller.dart';
import 'package:mona_console/screens/auth_screen/components/forget_password_text_button.dart';
import 'package:mona_console/screens/auth_screen/components/sign_in_form.dart';
import 'package:mona_console/top_level_components/buttons/primary_full_width_button.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_get_snackbar.dart';

class EmailSignInScreenSection extends StatefulWidget {
  const EmailSignInScreenSection({super.key});

  @override
  State<EmailSignInScreenSection> createState() =>
      _EmailSignInScreenSectionState();
}

class _EmailSignInScreenSectionState extends State<EmailSignInScreenSection> {
  @override
  Widget build(BuildContext context) {
    AuthController authController = AuthController.instance;
    return Expanded(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    'サインイン',
                    style: TextStyle(color: kAppBarColor, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 96,
                      width: 96,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/mona_restaurant_logo.png',
                          ),
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Mona Menu ',
                            style: TextStyle(
                              color: kRestaurantColor,
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '管理コンソール',
                            style: TextStyle(
                              color: kRestaurantColor,
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '店舗用アプリ',
                      style: TextStyle(color: kAppBarColor, fontSize: 18),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 36, horizontal: 18),
                  child: SignInForm(),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18, bottom: 36),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [ForgetPasswordTextButton()],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    authController.launchTermsConditionURL();
                  },
                  child: const Text(
                    '先に進むことで、\nあなたは利用規約に同意したこととなります',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  child: PrimaryFullWidthButton(
                    centerWidget: const Text(
                      '次へ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () async {
                      if (authController.authForm.valid) {
                        await authController.signInWithEmailPassword(
                          authController.authForm.control('email').value,
                          authController.authForm.control('password').value,
                        );
                      } else {
                        buildGetSnackbar(
                          'エラーが発生しました',
                          'メールアドレスとパスワードを入力してください',
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
