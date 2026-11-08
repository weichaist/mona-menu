import 'package:get/get.dart';
import 'package:mona_console/controllers/setting_controller.dart';

class SettingBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SettingController());
  }
}
