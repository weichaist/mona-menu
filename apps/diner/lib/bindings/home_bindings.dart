import 'package:get/get.dart';
import 'package:mona_diner/controllers/cart_controller.dart';
import 'package:mona_diner/controllers/creator_in_restaurant_controller.dart';
import 'package:mona_diner/controllers/home_controller.dart';
import 'package:mona_diner/controllers/micro_data_user_post_controller.dart';
import 'package:mona_diner/controllers/micro_select_order_to_post_data_future.dart';
import 'package:mona_diner/controllers/payment_controller.dart';
import 'package:mona_diner/controllers/profile_controller.dart';
import 'package:mona_diner/controllers/restaurant_controller.dart';
import 'package:mona_diner/controllers/user_post_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(UserPostController());
    Get.lazyPut(() => MicroDataUserPostController());
    Get.lazyPut(() => MicroSelectOrderToPostDataController());
    Get.put(ProfileController());
    Get.put(RestaurantController());
    Get.lazyPut(() => CreatorInRestaurantController());
    Get.put(CartController());
    Get.put(PaymentController());
  }
}
