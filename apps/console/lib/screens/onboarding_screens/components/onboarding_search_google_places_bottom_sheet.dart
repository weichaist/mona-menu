import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mona_console/APIs/google_places_services.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/onboarding_controller.dart';
import 'package:mona_console/screens/onboarding_screens/components/default_search_underline_text_field.dart';
import 'package:mona_console/top_level_components/buttons/default_text_button.dart';

class SearchGooglePlacesBottomSheet extends StatefulWidget {
  const SearchGooglePlacesBottomSheet({super.key});

  @override
  State<SearchGooglePlacesBottomSheet> createState() =>
      _SearchGooglePlacesBottomSheetState();
}

class _SearchGooglePlacesBottomSheetState
    extends State<SearchGooglePlacesBottomSheet> {
  List<PlaceSearchResult> places = [];
  int _selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    OnboardingController onboardingController = OnboardingController.instance;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DefaultTextButton(
                color: _selectedIndex > -1 ? kRestaurantColor : Colors.black45,
                label: 'インポート',
                onPressed: () {
                  onboardingController.importSearchResult();
                },
              ),
            ],
          ),
          DefaultSearchUnderlineTextField(
            onChanged: (String val) async {
              if (val.isNotEmpty) {
                var results = await PlacesAutoCompleteService().getResponse(
                  val,
                  'ja',
                  'JP',
                );
                if (results != null) {
                  setState(() {
                    places = results;
                    _selectedIndex = -1;
                  });
                }
              } else {
                setState(() {
                  places = [];
                  _selectedIndex = -1;
                });
              }
            },
            hintText: 'ご店名、またはご店名とご住所で検索',
            autofocus: true,
          ),
          places.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          setState(() {
                            _selectedIndex = index;
                          });
                          FocusManager.instance.primaryFocus?.unfocus();
                          EasyLoading.show(status: '読み込み中..');
                          await onboardingController.setSearchResult(
                            places[index],
                          );
                          EasyLoading.dismiss();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tileColor: _selectedIndex == index
                            ? kRestaurantLightColor.withValues(alpha: 0.4)
                            : Colors.white,
                        title: Text(
                          places[index].name != null ? places[index].name! : '',
                          style: const TextStyle(
                            color: kRestaurantColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          places[index].formattedAddress != null
                              ? places[index].formattedAddress!
                              : '',
                          style: const TextStyle(
                            color: kBodyTextColor,
                            fontSize: 15,
                          ),
                        ),
                      );
                    },
                    itemCount: places.length,
                  ),
                )
              : Expanded(
                  child: Center(
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 21,
                        color: kRestaurantColor,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            '検索して',
                            speed: const Duration(milliseconds: 120),
                          ),
                          TypewriterAnimatedText(
                            'あなたのお店を選びましょう！',
                            speed: const Duration(milliseconds: 120),
                          ),
                        ],
                        isRepeatingAnimation: true,
                        onTap: () {},
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
