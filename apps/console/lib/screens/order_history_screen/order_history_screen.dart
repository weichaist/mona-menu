import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/history_controller.dart';
import 'package:mona_console/screens/order_history_screen/components/body.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(HistoryController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('履歴', style: TextStyle(color: kBodyTextColor)),
      ),
      body: const SafeArea(child: Body()),
    );
  }
}
