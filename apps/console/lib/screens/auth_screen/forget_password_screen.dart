import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/auth_controller.dart';
import 'package:mona_console/size_config.dart';
import 'package:mona_console/top_level_components/buttons/primary_full_width_button.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_get_snackbar.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _authController = AuthController.instance;
  var email = '';
  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentScope = FocusScope.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kRestaurantColor,
        onPressed: () {
          currentScope.unfocus();
          Get.back();
        },
        child: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: double.infinity,
              width: getScreenWidth() / 2,
              margin: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [kDefaultShadow],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                        right: 18,
                        bottom: 18,
                        top: 72,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 36),
                            child: Text(
                              'パスワードを忘れた場合',
                              style: TextStyle(
                                color: kRestaurantColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'パスワードのリセット手順をメール送信します。',
                              style: TextStyle(color: kBodyTextColor),
                            ),
                          ),
                          TextField(
                            style: const TextStyle(color: kRestaurantColor),
                            decoration: const InputDecoration(
                              labelText: 'name@example.com',
                              labelStyle: TextStyle(color: kBodyTextColor),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 96),
                      child: PrimaryFullWidthButton(
                        backgroundColor: GetUtils.isEmail(email)
                            ? kRestaurantColor
                            : kAppBarColor,
                        centerWidget: const Text(
                          'メールを送信する',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        onTap: () async {
                          currentScope.unfocus();
                          if (GetUtils.isEmail(email)) {
                            await _authController.sendPasswordResetEmail(email);
                          } else {
                            buildGetSnackbar(
                              '有効なメールアドレスを入力してください',
                              'エラが発生しました',
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
