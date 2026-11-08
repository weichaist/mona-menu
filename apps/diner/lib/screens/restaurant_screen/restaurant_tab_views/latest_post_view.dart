import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/models/mona_menu_post_model.dart';
import 'package:mona_diner/screens/restaurant_screen/components/future_build_post_list_view_card.dart';
import 'package:mona_diner/screens/restaurant_screen/components/post_filter_chips.dart';
import 'package:mona_diner/screens/top_level_components/list/paginated_filter_list_view.dart';
import 'package:mona_diner/size_config.dart';

class LatestPostView extends StatelessWidget {
  const LatestPostView({super.key});
  @override
  Widget build(BuildContext context) {
    final restaurantController = RestaurantController.instance;
    restaurantController.initLatestMonaPostView(
      restaurantController.latestFilterCategory.value,
    );
    return Obx(() {
      if (restaurantController.latestPostList.isNotEmpty) {
        return PaginatedFilterListView(
          pageSize: 15,
          query: restaurantController.latestPostQuery(
            restaurantController.latestFilterCategory.value,
          ),
          filterWidget: Container(
            height: 54,
            width: getScreenWidth(),
            margin: const EdgeInsets.symmetric(horizontal: 9),
            decoration: BoxDecoration(
              color: kPrimaryLightColor.withValues(alpha: 0.84),
              borderRadius: BorderRadius.circular(12),
            ),
            child: PostFilterChips(
              filterCategory: restaurantController.latestFilterCategory.value,
              onTap: (filter) {
                restaurantController.latestFilterCategory.value = filter;
                restaurantController.initLatestMonaPostView(
                  restaurantController.latestFilterCategory.value,
                );
              },
              categories: restaurantController.menuCategories,
            ),
          ),
          build: (context, data) {
            final post = MonaMenuPost.fromFirestore(data);
            return FutureBuildPostListViewCard(post: post);
          },
        );
      } else {
        return SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              PostFilterChips(
                filterCategory: restaurantController.latestFilterCategory.value,
                onTap: (filter) {
                  restaurantController.latestFilterCategory.value = filter;
                  restaurantController.initLatestMonaPostView(
                    restaurantController.latestFilterCategory.value,
                  );
                },
                categories: restaurantController.menuCategories,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18, top: 108),
                child: Text(
                  tr('Let\'s post to Mona Menu!'),
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
