import 'package:flutter/material.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/models/customer_order_model.dart';
import 'package:mona_console/models/m_user_model.dart';
import 'package:intl/intl.dart';
import 'package:mona_console/screens/home_screen/components/profile_image_container.dart';
import 'package:mona_console/top_level_components/currency_time_phone/convert_text_to_currency.dart';

class OrderHistoryCustomTile extends StatelessWidget {
  final MUser mUser;
  final CustomerOrder customerOrder;
  final VoidCallback onTap;
  const OrderHistoryCustomTile({
    super.key,
    required this.mUser,
    required this.customerOrder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          splashColor: kRestaurantLightColor.withValues(alpha: 0.3),
          highlightColor: kRestaurantLightColor.withValues(alpha: 0.3),
          child: ListTile(
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${mUser.displayName} (${mUser.lastName} 様)のご注文',
                  style: const TextStyle(color: kBodyTextColor),
                ),
                Text(
                  'ID: ${customerOrder.orderId!}',
                  style: const TextStyle(color: kBodyTextColor),
                ),
                Text(
                  DateFormat(
                    'yyyy-MM-dd HH:mm:ss',
                  ).format(customerOrder.orderTimeStamp!),
                ),
              ],
            ),
            title: Text(
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
            trailing: SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ConvertTextToCurrency(
                    price: customerOrder.totalPrice!.toInt(),
                  ),
                  Chip(
                    backgroundColor: kRestaurantColor,
                    label: Text(
                      customerOrder.status!.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
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
