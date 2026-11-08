import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mona_console/config.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_get_snackbar.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  final _auth = FirebaseAuth.instance;
  // final _db = FirebaseFirestore.instance;

  final _userEmail = ''.obs;
  final _userPW = ''.obs;
  String get userEmail => _userEmail.value;
  String get userPW => _userPW.value;

  FormGroup authForm = FormGroup({
    'email': FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    'password': FormControl<String>(
      validators: [
        Validators.required,
        // Validators.minLength(6),
      ],
    ),
  });

  //sign in
  Future signInWithEmailPassword(String email, String password) async {
    try {
      EasyLoading.show(status: 'ログイン中..');
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;
      if (user == null) {
        buildGetSnackbar('エラが発生しました', '入力情報をご確認ください');
        EasyLoading.dismiss();
      } else {
        Get.offAllNamed('/');
        EasyLoading.dismiss();
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      buildGetSnackbar(_loginErrorMsg(e.code), 'エラが発生しました');
    }
  }

  Future sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      await EasyLoading.showSuccess('メールを送信しました！');
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String _loginErrorMsg(String errorCode) {
    String errorMsg;

    if (errorCode == 'error-invalid-email') {
      errorMsg = '有効なメールアドレスを入力してください';
    } else if (errorCode == 'user-not-found') {
      // 入力されたメールアドレスが登録されていない場合
      errorMsg = 'メールアドレスかパスワードが間違っています';
    } else if (errorCode == 'wrong-password') {
      // 入力されたパスワードが間違っている場合
      errorMsg = 'メールアドレスかパスワードが間違っています';
    } else if (errorCode == 'user-disabled') {
      // メールアドレスかパスワードがEmpty or Nullの場合
      errorMsg = 'エラが発生しました';
    } else if (errorCode == 'error') {
      // メールアドレスかパスワードがEmpty or Nullの場合
      errorMsg = 'メールアドレスとパスワードを入力してください';
    } else {
      errorMsg = errorCode;
    }

    return errorMsg;
  }

  Future<void> launchTermsConditionURL() async {
    final url = Uri.parse(AppConfig.termsUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
