import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mona_diner/controllers/auth_controller.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});
  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'JP';
  PhoneNumber number = PhoneNumber(isoCode: 'JP');
  @override
  Widget build(BuildContext context) {
    AuthController authController = AuthController.instance;
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber value) {
        if (value.phoneNumber != null) {
          authController.userPhoneNumber.value = value.phoneNumber!;
        }
      },
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.DROPDOWN,
      ),
      initialValue: number,
      textFieldController: controller,
      formatInput: false,
      keyboardType: TextInputType.phone,
      hintText: tr('Phone Number'),
    );
  }
}
