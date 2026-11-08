import 'package:get/get.dart';
import 'package:mona_console/controllers/auth_controller.dart';
import 'package:mona_console/controllers/micro_data_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
    Get.lazyPut(() => MicroDataController());
  }
}
