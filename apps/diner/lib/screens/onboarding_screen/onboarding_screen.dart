import 'package:flutter/material.dart';
import 'package:mona_diner/controllers/onboard_controller.dart';
import 'package:mona_diner/screens/onboarding_screen/pages/name_bio_page.dart';
import 'package:mona_diner/screens/onboarding_screen/pages/profile_email_username_page.dart';
import 'package:mona_diner/screens/onboarding_screen/pages/profile_picture_page.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardController = OnboardController.instance;
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(vertical: 9, horizontal: 9),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: onboardController.pageController,
          children: const [
            EmailUsernamePage(),
            ProfilePicturePage(),
            NameBioPage(),
          ],
        ),
      ),
    );
  }
}
