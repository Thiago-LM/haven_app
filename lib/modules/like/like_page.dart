import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'like_controller.dart';

class LikePage extends StatelessWidget {
  const LikePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    final controller = Get.find<LikeController>(tag: 'like');

    return SingleChildScrollView(
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text(
                'Liked',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                '${controller.imageFiles.length > 1 ? '${controller.imageFiles.length} wallpapers that ' : 'A wallpaper '}'
                'you liked',
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
            controller.imageFiles.isEmpty
                ? const Center(child: CircularProgressIndicator.adaptive())
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: (mediaSize.height / 4.5) * 3.3,
                      child: GridView.builder(
                        itemCount: controller.imageFiles.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          child: GestureDetector(
                            child: Image.file(
                              File(controller.imageFiles[index].path),
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: mediaSize.height / 3.0,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
