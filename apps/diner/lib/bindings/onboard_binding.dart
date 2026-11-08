import 'package:get/get.dart';
import 'package:mona_diner/controllers/onboard_controller.dart';

class OnboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(OnboardController());
  }
}
