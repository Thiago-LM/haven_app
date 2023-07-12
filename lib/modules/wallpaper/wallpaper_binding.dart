import 'package:get/get.dart';

import 'package:haven_app/data/provider/wallhaven_api_client.dart';
import 'package:haven_app/data/repository/wallpaper_repository.dart';

import 'wallpaper_controller.dart';

class WallpaperBinding implements Bindings {
  @override
  void dependencies() => Get.put<WallpaperController>(
      WallpaperController(WallpaperRepository(WallhavenApiClient())));
}
