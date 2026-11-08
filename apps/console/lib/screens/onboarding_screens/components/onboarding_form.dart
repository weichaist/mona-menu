import 'package:flutter/material.dart';
import 'package:mona_console/controllers/onboarding_controller.dart';
import 'package:reactive_forms/reactive_forms.dart';

class OnboardingForm extends StatelessWidget {
  const OnboardingForm({super.key});

  @override
  Widget build(BuildContext context) {
    OnboardingController controller = OnboardingController.instance;
    return ReactiveForm(
      formGroup: controller.onboardingForm,
      child: Column(
        children: <Widget>[
          ReactiveTextField(
            formControlName: 'name',
            decoration: const InputDecoration(
              hintText: 'ご店名 ※',
              labelText: 'ご店名 ※',
            ),
            validationMessages: {
              ValidationMessage.required: (_) => 'ご店名を入力してください',
            },
          ),
          const SizedBox(height: 36),
          ReactiveTextField(
            formControlName: 'address',
            decoration: const InputDecoration(
              hintText: 'ご住所 ※',
              labelText: 'ご住所 ※',
            ),
            validationMessages: {
              ValidationMessage.required: (_) => 'ご住所を入力してください',
            },
          ),
          const SizedBox(height: 36),
          ReactiveTextField(
            formControlName: 'phoneNumber',
            decoration: const InputDecoration(
              hintText: '予約・問い合わせ用電話番号 ※',
              labelText: '予約・問い合わせ用電話番号 ※',
            ),
            validationMessages: {
              ValidationMessage.required: (_) => '電話番号を入力してください',
            },
          ),
          const SizedBox(height: 36),
          ReactiveTextField(
            formControlName: 'genre',
            decoration: const InputDecoration(
              hintText: 'ジャンル ※',
              labelText: 'ジャンル ※',
            ),
            validationMessages: {
              ValidationMessage.required: (_) => 'ジャンルを入力してください',
            },
            onSubmitted: (_) {
              controller.onboardingForm.unfocus();
            },
          ),
          const SizedBox(height: 36),
          ReactiveTextField(
            formControlName: 'lat',
            readOnly: true,
            decoration: const InputDecoration(
              hintText: '位置情報（例: 35.7075066,139.7582473）※',
              labelText: '位置情報（例: 35.7075066,139.7582473）※',
            ),
            validationMessages: {
              ValidationMessage.required: (_) => '位置情報は必須です',
            },
          ),
          const SizedBox(height: 36),
          ReactiveTextField(
            formControlName: 'lng',
            readOnly: true,
            decoration: const InputDecoration(
              hintText: '位置情報（例: 35.7075066,139.7582473）※',
              labelText: '位置情報（例: 35.7075066,139.7582473）※',
            ),
            validationMessages: {
              ValidationMessage.required: (_) => '位置情報は必須です',
            },
          ),
        ],
      ),
    );
  }
}
