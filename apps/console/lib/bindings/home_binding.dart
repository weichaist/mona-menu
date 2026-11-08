import 'package:get/get.dart';
import 'package:mona_console/controllers/home_controller.dart';
import 'package:mona_console/controllers/menu_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.put<RestaurantMenuController>(RestaurantMenuController());
  }
}
