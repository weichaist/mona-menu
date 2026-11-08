import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/onboarding_controller.dart';
import 'package:mona_console/screens/onboarding_screens/pages/basic_info_page.dart';
import 'package:mona_console/screens/onboarding_screens/pages/profile_picture_page.dart';

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({super.key});

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final OnboardingController _onboardingController = Get.put(
    OnboardingController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウントの設定', style: TextStyle(color: kBodyTextColor)),
        automaticallyImplyLeading: true,
      ),
      body: PopScope(
        child: SafeArea(
          child: PageView(
            controller: _onboardingController.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [BasicInfoPage(), AccPictureScreen()],
          ),
        ),
      ),
    );
  }
}
