import 'package:get/get.dart';

import 'tab_bar_navigation_controller.dart';

class TabBarNavigationBinding implements Bindings {
  @override
  void dependencies() =>
      Get.put<TabBarNavigationController>(TabBarNavigationController());
}
