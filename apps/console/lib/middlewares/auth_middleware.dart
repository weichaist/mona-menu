import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  //   Get the auth service
  //   AuthController auth = AuthController.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  //   The default is 0 but you can update it to any number. Please ensure you match the priority based
  //   on the number of guards you have.
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Navigate to login if client is not authenticated other wise continue
    return auth.currentUser != null || route == '/auth'
        ? null
        : const RouteSettings(name: '/auth');
  }
}
