import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class LikeController extends GetxController {
  final imageFiles = <FileSystemEntity>[].obs;

  @override
  void onInit() async {
    await getImages();
    super.onInit();
  }

  Future<void> getImages() async {
    final dir = await getApplicationDocumentsDirectory();

    imageFiles.clear();
    imageFiles.addAll(dir.listSync(followLinks: false, recursive: false));
    log('imageFiles = $imageFiles', name: 'LikeController');

    imageFiles.removeWhere((element) => !element.path.contains('wallhaven'));

    for (var file in imageFiles) {
      log('file = $file / ${file.statSync()}', name: 'LikeController');
    }
  }
}
