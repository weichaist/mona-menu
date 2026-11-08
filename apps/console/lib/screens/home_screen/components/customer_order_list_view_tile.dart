import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/models/customer_order_model.dart';
import 'package:mona_console/models/m_user_model.dart';
import 'package:mona_console/screens/home_screen/components/profile_image_container.dart';
import 'package:timeago/timeago.dart' as timeago;

class LiveOrderCustomTile extends StatelessWidget {
  final MUser mUser;
  final CustomerOrder customerOrder;
  final VoidCallback onTap;
  final bool? isSelected;
  final bool? isCompleted;
  const LiveOrderCustomTile({
    super.key,
    required this.mUser,
    required this.customerOrder,
    required this.onTap,
    this.isSelected = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          selected: isSelected!,
          selectedTileColor: kRestaurantLightColor.withValues(alpha: 0.45),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 9,
            horizontal: 18,
          ),
          title: Text(
            '${timeago.format(customerOrder.orderTimeStamp!, locale: 'ja')} ${mUser.displayName}のご注文 (ID: ${customerOrder.orderId!.substring(0, 4)})',
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: TextStyle(
              color: isCompleted! ? kSuccessColor : kBodyTextColor,
            ),
          ),
          subtitle: Text(
            customerOrder.menuItemTitles!.join('、'),
            style: const TextStyle(
              color: kRestaurantColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          minLeadingWidth: 18.0,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileImageContainer(
                imageUrl: mUser.profilePictureURL!,
                radius: 45,
              ),
            ],
          ),
          trailing: Text(
            customerOrder.tableId!,
            style: const TextStyle(color: kBodyTextColor),
          ),
        ),
        Divider(
          height: 0,
          thickness: 0.6,
          color: kRestaurantColor.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}
