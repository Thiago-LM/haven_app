import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:haven_app/modules/home/home_binding.dart';
import 'package:haven_app/modules/home/home_page.dart';
import 'package:haven_app/modules/like/like_binding.dart';
import 'package:haven_app/modules/like/like_controller.dart';
import 'package:haven_app/modules/like/like_page.dart';
import 'package:haven_app/modules/save/save_binding.dart';
import 'package:haven_app/modules/save/save_controller.dart';
import 'package:haven_app/modules/save/save_page.dart';

class TabBarNavigationController extends GetxController {
  final title = 'Best of the month'.obs;
  final pages = <String>['/home', '/like', '/save'];

  void changeTitle(String title) => this.title.value = title;

  void changePage(int index) => Get.toNamed(pages[index], id: 1);

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name != '/like' &&
        Get.isRegistered<LikeController>(tag: 'like')) {
      Get.delete<LikeController>(tag: 'like');
    }

    if (settings.name != '/save' &&
        Get.isRegistered<SaveController>(tag: 'save')) {
      Get.delete<SaveController>(tag: 'save');
    }

    if (settings.name == '/home') {
      return GetPageRoute(
        settings: settings,
        page: () => const HomePage(),
        binding: HomeBinding(),
        transition: Transition.native,
      );
    }

    if (settings.name == '/like') {
      return GetPageRoute(
        settings: settings,
        page: () => const LikePage(),
        binding: LikeBinding(),
        transition: Transition.native,
      );
    }

    if (settings.name == '/save') {
      return GetPageRoute(
        settings: settings,
        page: () => const SavePage(),
        binding: SaveBinding(),
        transition: Transition.native,
      );
    }

    return null;
  }
}
