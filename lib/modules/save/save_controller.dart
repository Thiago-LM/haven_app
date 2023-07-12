import 'dart:io';

import 'package:get/get.dart';

class SaveController extends GetxController {
  List<FileSystemEntity> imageFiles = [];

  @override
  void onInit() {
    if (Platform.isAndroid) {
      imageFiles = getImages();
    }
    super.onInit();
  }

  List<FileSystemEntity> getImages() {
    final dir = Directory('storage/emulated/0/Pictures/wallhaven/')
      ..createSync(recursive: true);

    return dir.listSync();
  }
}
