import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'modules/tab_bar_navigation/tab_bar_navigation_binding.dart';
import 'routes/app_pages.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Haven App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      getPages: AppPages.pages,
      initialRoute: Routes.initial,
      initialBinding: TabBarNavigationBinding(),
    );
  }
}
