import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/onboarding_controller.dart';
import 'package:mona_console/screens/onboarding_screens/components/default_search_underline_text_field.dart';
import 'package:mona_console/screens/onboarding_screens/components/onboarding_form.dart';
import 'package:mona_console/screens/onboarding_screens/components/onboarding_page.dart';
import 'package:mona_console/screens/onboarding_screens/components/onboarding_search_google_places_bottom_sheet.dart';
import 'package:mona_console/top_level_components/buttons/default_icon_button.dart';
import 'package:mona_console/top_level_components/snackbar_dialog_popup/build_get_snackbar.dart';

class BasicInfoPage extends StatelessWidget {
  const BasicInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    OnboardingController onboardingController = OnboardingController.instance;
    return OnboardingPage(
      childWidget: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ステップ1/2'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    'お店の基本情報を入力してくだい',
                    style: TextStyle(
                      color: kRestaurantColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 36),
                  child: Text(
                    '店名、住所、ジャンル、予約・問い合わせ用電話番号など',
                    style: TextStyle(color: kBodyTextColor),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showBarModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          const SearchGooglePlacesBottomSheet(),
                    );
                  },
                  child: DefaultSearchUnderlineTextField(
                    enabled: false,
                    onChanged: (val) {
                      debugPrint(val);
                    },
                    hintText: 'Google Mapsからお店の基本情報をインポート',
                  ),
                ),
                const SizedBox(height: 36),
                const OnboardingForm(),
              ],
            ),
          ),
        ),
      ),
      iconButton: DefaultIconButton(
        icon: Icons.arrow_forward,
        onTap: () {
          if (onboardingController.onboardingForm.valid) {
            FocusManager.instance.primaryFocus?.unfocus();
            onboardingController.pageController.jumpToPage(1);
            onboardingController.setCurrentPage(1);
          } else {
            buildGetSnackbar(
              '必須項目を入力してください',
              'All necessary fields are not completed',
            );
          }
        },
        backgroundColor: kRestaurantColor,
        iconColor: Colors.white,
      ),
    );
  }
}
