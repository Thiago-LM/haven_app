import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:haven_app/data/model/wallpaper_info.dart';
import 'package:haven_app/data/repository/wallpaper_repository.dart';

class WallpaperController extends GetxController
    with StateMixin<WallpaperInfo> {
  final WallpaperRepository repository;

  WallpaperController(this.repository);

  final didLike = false.obs;

  String get url => Get.parameters['url']!;
  String get id =>
      url.substring(url.lastIndexOf('-') + 1, url.lastIndexOf('.'));

  @override
  void onInit() {
    log('Get.parameters[url] = ${Get.parameters['url']} / url = $url / id = $id',
        name: 'WallpaperController');
    getWallpaperInfo();
    super.onInit();
  }

  Future<void> getWallpaperInfo() async {
    try {
      final wallpaper = await repository.getWallpaperInfo(id: id);
      change(wallpaper, status: RxStatus.success());
    } on Exception catch (e) {
      log('e = $e', name: 'WallpaperController');
      change(WallpaperInfo.empty, status: RxStatus.error());
    }
  }

  Future<void> likeImage() async {
    final directory = await getApplicationDocumentsDirectory();
    log('directory = $directory', name: 'WallpaperController');

    final file =
        File('${directory.path}/${url.substring(url.lastIndexOf('/') + 1)}');
    log('file = $file', name: 'WallpaperController');

    if (didLike.isFalse) {
      final fileBodyBytes = await http.readBytes(Uri.parse(url));
      file.writeAsBytesSync(fileBodyBytes);
    } else {
      file.deleteSync();
    }

    didLike.toggle();
  }

  Future<void> downloadImage() async {
    final dir = Directory('storage/emulated/0/Pictures/wallhaven/');
    if (!dir.existsSync()) {
      log('$dir doesnt exist');
      dir.createSync(recursive: true);
    }
    log('$dir exist');

    final file = File(dir.path + url.substring(url.lastIndexOf('/') + 1));
    log('file = ${file.path}');
    final fileBodyBytes = await http.readBytes(Uri.parse(url));
    file.writeAsBytesSync(fileBodyBytes);
  }
}
