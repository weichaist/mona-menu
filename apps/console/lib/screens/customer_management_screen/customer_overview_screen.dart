import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/customer_controller.dart';
import 'package:mona_console/screens/customer_management_screen/components/body.dart';

class CustomerOverviewScreen extends StatelessWidget {
  const CustomerOverviewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put<CustomerController>(CustomerController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('顧客管理', style: TextStyle(color: kBodyTextColor)),
      ),
      body: const SafeArea(child: Body()),
    );
  }
}
