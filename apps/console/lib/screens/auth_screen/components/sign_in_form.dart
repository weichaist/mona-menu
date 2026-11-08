import 'package:flutter/material.dart';
import 'package:mona_console/controllers/auth_controller.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = AuthController.instance;
    return ReactiveForm(
      formGroup: authController.authForm,
      child: Column(
        children: <Widget>[
          ReactiveTextField(
            formControlName: 'email',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'メールアドレス',
              labelText: 'メールアドレス',
            ),
            validationMessages: {
              ValidationMessage.required: (_) => 'Emailアドレスを入力してください',
              ValidationMessage.email: (_) => '正しくEmailアドレスを入力してください',
            },
            onSubmitted: (_) => authController.authForm.focus('password'),
          ),
          const SizedBox(height: 36),
          ReactiveTextField(
            formControlName: 'password',
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'パスワード',
              labelText: 'パスワード',
            ),
            validationMessages: {
              ValidationMessage.required: (_) => 'パスワードを入力してください',
              // ValidationMessage.minLength: (_) => '6文字以上のパスワードを入力してください',
            },
            onSubmitted: (_) => authController.authForm.unfocus(),
          ),
        ],
      ),
    );
  }
}
