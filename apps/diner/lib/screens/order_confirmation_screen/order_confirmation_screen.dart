import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/screens/order_confirmation_screen/components/body.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantMenuController = RestaurantController.instance;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfileAvatarContainer(
              imageUrl: restaurantMenuController
                  .restaurantData
                  .value
                  .profileImageUrl!,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  restaurantMenuController.restaurantData.value.name!,
                  style: const TextStyle(color: kAppBarTextColor),
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ],
        ),
        // actions: [
        //   DefaultIconButton(icon: CupertinoIcons.info_circle, onTap: () {}),
        // ],
      ),
      body: const Body(),
    );
  }
}
