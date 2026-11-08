import 'package:get/get.dart';
import 'package:mona_diner/controllers/micro_data_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MicroDataController());
  }
}
