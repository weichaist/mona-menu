import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/screens/restaurant_screen/components/future_build_post_list_view_card.dart';
import 'package:mona_diner/screens/restaurant_screen/components/post_filter_chips.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_text_button.dart';

class RepeaterPostView extends StatelessWidget {
  const RepeaterPostView({super.key});
  @override
  Widget build(BuildContext context) {
    final restaurantController = RestaurantController.instance;
    restaurantController.initRepeaterMonaPostView(
      restaurantController.repeaterFilterCategory.value,
      restaurantController.restaurantUid.value,
    );
    return Obx(() {
      if (restaurantController.repeaterPostList.isNotEmpty) {
        return RefreshIndicator(
          color: kPrimaryColor,
          onRefresh: () async {
            restaurantController.repeaterFilterCategory.value = '';
            await restaurantController.initRepeaterMonaPostView(
              restaurantController.repeaterFilterCategory.value,
              restaurantController.restaurantUid.value,
            );
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                PostFilterChips(
                  filterCategory:
                      restaurantController.repeaterFilterCategory.value,
                  onTap: (filter) async {
                    restaurantController.repeaterFilterCategory.value = filter;
                    await restaurantController.initFilteredRepeaterMonaPostView(
                      filter,
                      restaurantController.restaurantUid.value,
                    );
                  },
                  categories: restaurantController.menuCategories,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12);
                  },
                  itemBuilder: (context, index) {
                    if (index < restaurantController.repeaterPostList.length) {
                      final post = restaurantController.repeaterPostList[index];
                      return FutureBuildPostListViewCard(post: post);
                    } else {
                      return Obx(() {
                        if (restaurantController
                            .repeaterPostListLastPage
                            .value) {
                          return const SizedBox(
                            width: double.infinity,
                            height: 100,
                            child: Center(
                              child: Icon(
                                CupertinoIcons.arrow_up_to_line_alt,
                                color: kPrimaryColor,
                              ),
                            ),
                          );
                        } else {
                          return SizedBox(
                            width: double.infinity,
                            height: 100,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: DefaultTextButton(
                                      label: 'More',
                                      onPressed: () async {
                                        await restaurantController
                                            .repeaterListNextPage(
                                              restaurantController
                                                  .repeaterFilterCategory
                                                  .value,
                                              restaurantController
                                                  .restaurantUid
                                                  .value,
                                            );
                                      },
                                    ),
                                  ),
                                  if (restaurantController
                                      .repeaterListLoading
                                      .value)
                                    const CupertinoActivityIndicator(),
                                ],
                              ),
                            ),
                          );
                        }
                      });
                    }
                  },
                  itemCount: restaurantController.repeaterPostList.length + 1,
                ),
              ],
            ),
          ),
        );
      } else {
        return SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              PostFilterChips(
                filterCategory:
                    restaurantController.repeaterFilterCategory.value,
                onTap: (filter) async {
                  restaurantController.repeaterFilterCategory.value = filter;
                  await restaurantController.initFilteredRepeaterMonaPostView(
                    filter,
                    restaurantController.restaurantUid.value,
                  );
                },
                categories: restaurantController.menuCategories,
              ),
              !restaurantController.repeaterListLoading.value
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                        right: 18,
                        top: 108,
                      ),
                      child: Text(
                        tr('Let\'s post to Mona Menu!'),
                        style: const TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: 180,
                      child: Center(child: CupertinoActivityIndicator()),
                    ),
            ],
          ),
        );
      }
    });
  }
}
