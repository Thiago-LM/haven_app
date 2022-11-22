import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haven_app/home/view/home_page.dart';
import 'package:haven_app/storage/save_page.dart';

class TabBarNavigationPage extends StatelessWidget {
  const TabBarNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBarNavigationView();
  }
}

class TabBarNavigationView extends StatelessWidget {
  const TabBarNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Haven'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  CupertinoIcons.square_grid_2x2_fill,
                  color: Colors.black,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.download,
                  color: Colors.black,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.supervised_user_circle_outlined,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: const TabBarView(
          children: <Widget>[
            HomePage(),
            SavePage(),
            Center(
              child: Text('User'),
            ),
          ],
        ),
      ),
    );
  }
}
