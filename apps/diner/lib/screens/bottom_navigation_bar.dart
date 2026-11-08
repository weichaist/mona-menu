import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/home_controller.dart';
import 'package:mona_diner/controllers/payment_controller.dart';
import 'package:mona_diner/controllers/profile_controller.dart';
import 'package:mona_diner/screens/home_screen/home_screen.dart';
import 'package:mona_diner/screens/new_post_screen/new_post_screen.dart';
import 'package:mona_diner/screens/profile_screen/profile_screen.dart';
import 'package:mona_diner/size_config.dart';
import 'package:mona_diner/utils/time_ago_ja.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

class PersistentBottomNavigationBarWrapper extends StatefulWidget {
  const PersistentBottomNavigationBarWrapper({super.key});

  @override
  State<PersistentBottomNavigationBarWrapper> createState() =>
      _PersistentBottomNavigationBarWrapperState();
}

class _PersistentBottomNavigationBarWrapperState
    extends State<PersistentBottomNavigationBarWrapper> {
  final _homeController = HomeController.instance;
  final _profileController = ProfileController.instance;
  final _paymentController = PaymentController.instance;
  List<Widget> _buildScreens() {
    return [const HomeScreen(), const NewPostScreen(), const ProfileScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.star_circle),
        title: ('ホーム'),
        activeColorPrimary: CupertinoColors.systemPurple,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.add_circled),
        title: ('投稿'),
        activeColorPrimary: CupertinoColors.systemPurple,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.profile_circled),
        title: ('Me'),
        activeColorPrimary: CupertinoColors.systemPurple,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    timeago.setLocaleMessages('ja', JaShortMessages());
    _profileController.initProfile();
    _paymentController.initStripe();
    return PersistentTabView(
      context,
      controller: PersistentTabController(
        initialIndex: _homeController.initIndex.value,
      ),
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      // Move the screen up when the keyboard appears.
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(12),
        colorBehindNavBar: Colors.white,
        boxShadow: [kDefaultShadow],
      ),
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
      ),
      navBarStyle: NavBarStyle.style1,
    );
  }
}
