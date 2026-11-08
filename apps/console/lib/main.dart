import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mona_console/bindings/home_binding.dart';
import 'package:mona_console/bindings/initial_binding.dart';
import 'package:mona_console/bindings/setting_binding.dart';
import 'package:mona_console/middlewares/auth_middleware.dart';
import 'package:mona_console/screens/auth_screen/email_sign_in_screen.dart';
import 'package:mona_console/screens/customer_management_screen/customer_overview_screen.dart';
import 'package:mona_console/screens/home_screen/home_screen.dart';
import 'package:mona_console/screens/onboarding_screens/onboarding_screens.dart';
import 'package:mona_console/screens/order_history_screen/order_history_screen.dart';
import 'package:mona_console/screens/post_screen/post_screen.dart';
import 'package:mona_console/screens/setting_screen/setting_screen.dart';
import 'package:mona_console/screens/unknow_route_screen/unknow_route_screen.dart';
import 'package:mona_console/theme.dart';
import 'package:mona_console/top_level_components/utils/timeago_ja.dart';
import 'constants.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const MyApp());
    configEasyLoading();
  });
}

void configEasyLoading() {
  EasyLoading.instance
    ..maskType = EasyLoadingMaskType.custom
    ..maskColor = CupertinoColors.systemGrey.withValues(alpha: 0.3)
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.chasingDots
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 12.0
    ..boxShadow = [kDefaultShadow]
    ..progressColor = kRestaurantColor
    ..backgroundColor = Colors.white
    ..indicatorColor = kRestaurantColor
    ..textColor = kRestaurantColor
    ..indicatorSize = 45.0
    ..radius = 9.0
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('ja', JaShortMessages());
    return GetMaterialApp(
      title: 'Mona | Restaurant Console',
      debugShowCheckedModeBanner: false,
      theme: monaTheme(),
      builder: EasyLoading.init(builder: BotToastInit()),
      navigatorObservers: [BotToastNavigatorObserver()],
      initialBinding: InitialBinding(),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const HomeScreen(),
          binding: HomeBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(name: '/auth', page: () => const EmailSignInScreen()),
        GetPage(name: '/not-found', page: () => const UnKnowRouteScreen()),
        GetPage(name: '/onboarding', page: () => const OnboardingScreens()),
        GetPage(name: '/history', page: () => const OrderHistoryScreen()),
        GetPage(name: '/customers', page: () => const CustomerOverviewScreen()),
        GetPage(name: '/posts', page: () => const PostScreen()),
        GetPage(
          name: '/settings',
          binding: SettingBinding(),
          page: () => const SettingScreen(),
        ),
      ],
    );
  }
}
