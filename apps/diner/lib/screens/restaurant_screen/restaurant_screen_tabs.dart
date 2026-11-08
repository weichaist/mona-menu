import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mona_diner/screens/restaurant_screen/restaurant_tab_views/classic_menu_view.dart';
import 'package:mona_diner/screens/restaurant_screen/restaurant_tab_views/following_user_post_view.dart';
import 'package:mona_diner/screens/restaurant_screen/restaurant_tab_views/latest_post_view.dart';
import 'package:mona_diner/screens/restaurant_screen/restaurant_tab_views/repeater_post_view.dart';

class RestaurantScreenTabs {
  static final List<Tab> tabs = <Tab>[
    Tab(text: '${tr('In-store menu')}🥢'),
    Tab(text: '${tr('Latest Post')}🆕'),
    Tab(text: '${tr('Recommended for repeaters')}✨'),
    Tab(text: '${tr('Follow user Choices')}👈🏻'),
    // const Tab(
    //   text: '定番🔥',
    // ),
  ];

  static final List<Widget> tabViews = <Widget>[
    const ClassicMenuView(),
    const LatestPostView(),
    const RepeaterPostView(),
    const FollowingUserPostView(),
    // MustEatMenuListView(),
    // FollowingUserMenuListView(),
    // RepeaterMenuListView(),
    // RestaurantMenuListView(),
    // LatestPostedMenuListView(),
  ];
}
