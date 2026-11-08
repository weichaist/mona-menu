import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mona_diner/controllers/cart_controller.dart';
import 'package:mona_diner/controllers/payment_controller.dart';
import 'package:mona_diner/controllers/profile_controller.dart';
import 'package:mona_diner/controllers/user_post_controller.dart';
import 'package:mona_diner/screens/top_level_components/snackbar_dialog_bottomsheet/build_confirmation_dialog.dart';

class SignOutAccountListTile extends StatelessWidget {
  const SignOutAccountListTile({super.key});
  @override
  Widget build(BuildContext context) {
    final profileController = ProfileController.instance;
    final paymentController = PaymentController.instance;
    final userPostController = UserPostController.instance;
    final cartController = CartController.instance;
    return ListTile(
      title: Text(tr('Log out')),
      trailing: const Icon(Icons.exit_to_app_rounded, color: Colors.red),
      onTap: () async {
        final res = await buildConfirmationDialog();
        if (res ?? false) {
          profileController.signOutAcc();
          paymentController.resetPaymentController();
          userPostController.resetController();
          cartController.resetController();
        } else {
          debugPrint('cancel');
        }
      },
    );
  }
}
