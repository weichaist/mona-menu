import 'package:flutter/material.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/home_controller.dart';
import 'package:mona_diner/screens/home_screen/components/body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final homeController = HomeController.instance;
    homeController.initHomeController();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.0),
                    child: Text(
                      'Mona Menu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: const Body(),
    );
  }
}
