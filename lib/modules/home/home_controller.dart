import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:haven_app/data/model/wallpaper_list.dart';
import 'package:haven_app/data/repository/home_repository.dart';
import 'package:haven_app/modules/tab_bar_navigation/tab_bar_navigation_controller.dart';

class HomeController extends GetxController with StateMixin<WallpaperList> {
  final HomeRepository repository;

  HomeController(this.repository);

  final textController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void onInit() {
    fetchWallpaper();
    /*scrollController.addListener(() async {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          state!.data.length < state!.meta.total &&
          !status.isLoading) {
        change(WallpaperList.empty, status: RxStatus.loading());
        await fetchWallpaper(
          query: searchTitle.value,
          pageIndex: state!.meta.currentPage + 1,
        );
      }
    });*/
    super.onInit();
  }

  Future<void> fetchWallpaper({String? query, int? pageIndex}) async {
    if (status != RxStatus.success()) {
      change(WallpaperList.empty, status: RxStatus.loading());

      try {
        final wallpaperList = await repository.getWallpaper(
            query: query, pageIndex: pageIndex ?? 1);

        change(wallpaperList, status: RxStatus.success());
      } catch (e) {
        log('fetchWallpaper e = $e', name: 'HomeController');
        change(WallpaperList.empty, status: RxStatus.error(e.toString()));
      }
    }

    textController.clear();
  }

  void updateTitle() =>
      Get.find<TabBarNavigationController>().changeTitle(textController.text);

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
