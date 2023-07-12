import 'package:get/get.dart';

import 'package:haven_app/modules/tab_bar_navigation/tab_bar_navigation_binding.dart';
import 'package:haven_app/modules/tab_bar_navigation/tab_bar_navigation_page.dart';
import 'package:haven_app/modules/wallpaper/wallpaper_binding.dart';
import 'package:haven_app/modules/wallpaper/wallpaper_page.dart';

part 'app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.initial,
      page: () => const TabBarNavigationPage(),
      binding: TabBarNavigationBinding(),
      transition: Transition.native,
    ),
    GetPage(
      name: Routes.wallpaper,
      page: () => const WallpaperPage(),
      binding: WallpaperBinding(),
      transition: Transition.native,
    ),
  ];
}
