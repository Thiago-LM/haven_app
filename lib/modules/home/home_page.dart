import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import 'package:haven_app/routes/app_pages.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: TextField(
              controller: controller.textController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Find Wallpaper...',
                hintStyle: const TextStyle(color: Colors.black87),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.black87),
                  onPressed: () async {
                    Get.focusScope!.unfocus();
                    controller.updateTitle();
                    await controller.fetchWallpaper(
                        query: controller.textController.text);
                  },
                ),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.fetchWallpaper,
              child: controller.obx(
                (state) => GridView.builder(
                  itemCount: state?.data.length,
                  shrinkWrap: true,
                  controller: controller.scrollController,
                  itemBuilder: (context, index) => ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: GestureDetector(
                      child: CachedNetworkImage(
                        imageUrl: state!.data[index].thumbs.original,
                        filterQuality: FilterQuality.high,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator.adaptive(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, color: Colors.red),
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        log('onTap url = ${state.data[index].path}',
                            name: 'HomePage');
                        Get.toNamed(Routes.wallpaper,
                            parameters: {'url': state.data[index].path});
                      },
                    ),
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: MediaQuery.of(context).size.height / 4.5,
                  ),
                ),
                onLoading:
                    const Center(child: CircularProgressIndicator.adaptive()),
                onEmpty: const Text('No data found'),
                onError: (error) =>
                    const Center(child: Text('Failed to load wallpaper')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
