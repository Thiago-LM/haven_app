import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'tab_bar_navigation_controller.dart';

class TabBarNavigationPage extends GetView<TabBarNavigationController> {
  const TabBarNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(controller.title.value)),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: const <Widget>[
              Tab(icon: Icon(CupertinoIcons.square_grid_2x2_fill)),
              Tab(icon: Icon(CupertinoIcons.heart_fill)),
              Tab(icon: Icon(Icons.download)),
            ],
            onTap: controller.changePage,
          ),
        ),
        body: SafeArea(
          child: Navigator(
            key: Get.nestedKey(1),
            initialRoute: '/home',
            onGenerateRoute: controller.onGenerateRoute,
          ),
        ),
      ),
    );
  }
}
