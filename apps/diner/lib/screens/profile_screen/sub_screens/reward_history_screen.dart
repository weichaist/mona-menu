import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/micro_data_controller.dart';
import 'package:mona_diner/controllers/profile_controller.dart';
import 'package:mona_diner/models/mona_order_in_cart_model.dart';
import 'package:mona_diner/models/mona_user_model.dart';
import 'package:mona_diner/screens/top_level_components/avatar/profile_avatar_container.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_icon_button.dart';
import 'package:mona_diner/screens/top_level_components/list/paginated_list_view.dart';
import 'package:mona_diner/screens/top_level_components/money/jpy_text.dart';
import 'package:timeago/timeago.dart' as timeago;

class RewardHistoryScreen extends StatelessWidget {
  const RewardHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = ProfileController.instance;
    profileController.initFetchingCurrentUserPostPurchasedHistory();
    final microDataController = MicroDataController.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('Reward History'),
          style: const TextStyle(color: kAppBarTextColor),
        ),
        actions: [
          DefaultIconButton(
            icon: CupertinoIcons.question_circle,
            onTap: () {
              Get.defaultDialog(
                title: tr('About posting'),
                content: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '👉🏻 ${tr('Please register your account information to receive the reward')}',
                        style: const TextStyle(color: CupertinoColors.label),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '👉🏻 ${tr('Rewards will be added at the end of the month')}',
                        style: const TextStyle(color: CupertinoColors.label),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '👉🏻 ${tr('If the result reward is 10,000 yen or more, you will be able to transfer.')}',
                        style: const TextStyle(color: CupertinoColors.label),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (profileController.currentUserPostPurchasedHistory.isNotEmpty) {
          return PaginatedListView(
            query: profileController.rewardHistoryQuery(),
            pageSize: 15,
            build: (context, data) {
              final order = MonaOrderInCart.fromFirestore(data);
              return FutureBuilder<MUser?>(
                future: microDataController.fetchAccountUserData(
                  order.orderedBy!,
                ),
                builder: (context, snapshot) {
                  var mUser = snapshot.data;
                  return mUser != null
                      ? RewardHistoryTile(mUser: mUser, monaOrder: order)
                      : RewardHistoryTile(
                          mUser: microDataController.mUser.value,
                          monaOrder: order,
                        );
                },
              );
            },
          );
        } else {
          return Center(
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              height: 36,
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
          );
        }
      }),
    );
  }
}

class RewardHistoryTile extends StatelessWidget {
  const RewardHistoryTile({
    super.key,
    required this.mUser,
    required this.monaOrder,
  });
  final MUser mUser;
  final MonaOrderInCart monaOrder;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          subtitle: Text(
            '${timeago.format(monaOrder.orderTimeStamp!, locale: 'ja')} ${mUser.displayName}のご注文 ',
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: const TextStyle(color: kBodyTextColor, fontSize: 12),
          ),
          title: Text(
            monaOrder.menuItemTitle!,
            // overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 13.5,
            ),
          ),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileAvatarContainer(
                imageUrl: mUser.profilePictureURL!,
                radius: 45,
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 72,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    JPYText(price: (monaOrder.totalPrice! * 0.01).toInt()),
                    const Icon(
                      CupertinoIcons.arrow_up_right,
                      color: CupertinoColors.activeGreen,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 0, thickness: 0.9, color: kPrimaryLightColor),
      ],
    );
  }
}
