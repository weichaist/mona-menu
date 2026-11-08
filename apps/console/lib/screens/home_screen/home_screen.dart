import 'package:flutter/material.dart';
import 'package:mona_console/controllers/home_controller.dart';
import 'package:mona_console/screens/home_screen/components/side_menu_drawer.dart';
import 'package:mona_console/screens/home_screen/sections/display_order_details.dart';
import 'package:mona_console/screens/home_screen/sections/home_order_list_tab_view.dart';
import 'package:mona_console/size_config.dart';
import 'package:mona_console/screens/home_screen/components/build_primary_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final HomeController homeController = HomeController.instance;
    homeController.initBindingTodayOrders();
    return Scaffold(
      key: homeController.scaffoldKey,
      drawer: const SideMenuDrawer(),
      appBar: buildPrimaryAppBar(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(flex: 10, child: HomeOrderListTabView()),
            VerticalDivider(width: 0),
            Expanded(flex: 6, child: DisplayOrderDetails()),
          ],
        ),
      ),
    );
  }
}
