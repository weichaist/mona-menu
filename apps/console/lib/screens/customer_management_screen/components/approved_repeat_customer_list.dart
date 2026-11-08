import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/customer_controller.dart';
import 'package:mona_console/controllers/micro_data_controller.dart';
import 'package:mona_console/models/m_user_model.dart';
import 'package:mona_console/models/repeater_application_model.dart';
import 'package:mona_console/screens/customer_management_screen/components/repeater_application_tile.dart';
import 'package:mona_console/top_level_components/custom_list/paginated_list_view.dart';

class PaginatedApprovedRepeatCustomerList extends StatelessWidget {
  const PaginatedApprovedRepeatCustomerList({super.key});

  @override
  Widget build(BuildContext context) {
    MicroDataController microDataController = MicroDataController.instance;
    CustomerController customerOverViewController = CustomerController.instance;
    customerOverViewController.initFetchingCertifiedCustomers();
    return Obx(() {
      if (customerOverViewController.approvedRepeaters.isNotEmpty) {
        return PaginatedListView(
          query: customerOverViewController.repeaterApplicationsQuery(),
          pageSize: 15,
          build: (context, data) {
            final application = RepeaterApplication.fromFirestore(data);
            return FutureBuilder<MUser?>(
              future: microDataController.fetchAccountUserData(
                application.appliedBy!,
              ),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return GestureDetector(
                    onTap: () {
                      // widget.onTapProfile(_mUser);
                    },
                    child: RepeaterApplicationTile(
                      mUser: snapshot.data!,
                      application: application,
                    ),
                  );
                } else {
                  return RepeaterApplicationTile(
                    mUser: microDataController.mUser.value,
                    application: application,
                  );
                }
              },
            );
          },
        );
      } else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/trust.svg',
                colorFilter: const ColorFilter.mode(
                  kRestaurantColor,
                  BlendMode.srcIn,
                ),
                height: 99,
              ),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  'お客さんに声をかけてみましょう！',
                  style: TextStyle(color: kRestaurantColor, fontSize: 18),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
