import 'package:get/get.dart';

import 'save_controller.dart';

class SaveBinding implements Bindings {
  @override
  void dependencies() => Get.put<SaveController>(SaveController(), tag: 'save');
}
