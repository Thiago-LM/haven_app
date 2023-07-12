import 'package:get/get.dart';

import 'package:haven_app/data/provider/wallhaven_api_client.dart';
import 'package:haven_app/data/repository/home_repository.dart';

import 'home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(
      HomeController(HomeRepository(WallhavenApiClient())),
      permanent: true,
    );
  }
}
