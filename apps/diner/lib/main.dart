import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mona_diner/bindings/auth_binding.dart';
import 'package:mona_diner/bindings/home_bindings.dart';
import 'package:mona_diner/bindings/initial_binding.dart';
import 'package:mona_diner/bindings/onboard_binding.dart';
import 'package:mona_diner/bindings/restaurant_binding.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/firebase_options.dart';
import 'package:mona_diner/middlewares/auth_middleware.dart';
import 'package:mona_diner/mona_theme.dart';
import 'package:mona_diner/screens/auth_screen/sign_in_screen.dart';
import 'package:mona_diner/screens/bottom_navigation_bar.dart';
import 'package:mona_diner/screens/onboarding_screen/onboarding_screen.dart';
import 'package:mona_diner/screens/restaurant_screen/restaurant_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Locale startLocale = const Locale('ja', 'JP');
  if (Platform.localeName.split('_')[0] != 'ja') {
    startLocale = const Locale('en', 'US');
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ja', 'JP')],
        path: 'assets/translations',
        fallbackLocale: const Locale('ja', 'JP'),
        startLocale: startLocale,
        child: const MyApp(),
      ),
    );
    configLoading();
  });
}

void configLoading() {
  EasyLoading.instance
    ..maskType = EasyLoadingMaskType.custom
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.chasingDots
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 12.0
    ..boxShadow = [kDefaultShadow]
    ..progressColor = kPrimaryColor
    ..backgroundColor = CupertinoColors.white
    ..indicatorColor = kPrimaryColor
    ..textColor = kPrimaryColor
    ..maskColor = CupertinoColors.systemGrey.withValues(alpha: 0.3)
    ..indicatorSize = 45.0
    ..radius = 9.0
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mona Menu',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: monaTheme(),
      builder: EasyLoading.init(),
      initialRoute: '/',
      initialBinding: InitialBinding(),
      getPages: [
        GetPage(
          name: '/',
          binding: HomeBinding(),
          page: () => const PersistentBottomNavigationBarWrapper(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/auth',
          binding: AuthBinding(),
          page: () => const SignInScreen(),
        ),
        GetPage(
          name: '/onboard',
          binding: OnboardBinding(),
          page: () => const OnboardingScreen(),
        ),
        GetPage(
          name: '/restaurant/:restaurantUid',
          binding: RestaurantBinding(),
          page: () => const RestaurantScreen(),
        ),
      ],
    );
  }
}
