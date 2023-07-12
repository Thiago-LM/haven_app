import 'package:get/get.dart';

import 'like_controller.dart';

class LikeBinding implements Bindings {
  @override
  void dependencies() => Get.put<LikeController>(LikeController(), tag: 'like');
}
