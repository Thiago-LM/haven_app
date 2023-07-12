import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import 'wallpaper_controller.dart';
import 'widgets/info_dialog.dart';
import 'widgets/rounded_square_button.dart';

class WallpaperPage extends GetView<WallpaperController> {
  const WallpaperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: controller.url,
            filterQuality: FilterQuality.high,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator.adaptive()),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, color: Colors.red),
            height: double.maxFinite,
            width: double.maxFinite,
            fit: BoxFit.fitWidth,
          ),
          Positioned(
            bottom: 30,
            left: 5,
            right: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundedSquareButton(
                  name: 'Back',
                  icon: CupertinoIcons.back,
                  action: () => Get.back(),
                ),
                RoundedSquareButton(
                  name: 'Info',
                  icon: CupertinoIcons.info,
                  action: () => showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext context) =>
                        InfoDialog(wallpaper: controller.state!.data),
                  ),
                ),
                Obx(
                  () => RoundedSquareButton(
                    name: 'Like',
                    icon: controller.didLike.value
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart,
                    action: () async => await controller.likeImage(),
                  ),
                ),
                RoundedSquareButton(
                  name: 'Save',
                  icon: CupertinoIcons.cloud_download,
                  action: () async => await controller.downloadImage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
