import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:haven_app/home/view/home_page.dart';
import 'package:haven_app/storage/save_page.dart';

class NavigationBarPage extends StatelessWidget {
  const NavigationBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavigationBarView();
  }
}

class NavigationBarView extends StatefulWidget {
  const NavigationBarView({super.key});

  @override
  State<NavigationBarView> createState() => _NavigationBarViewState();
}

class _NavigationBarViewState extends State<NavigationBarView> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Theme.of(context).indicatorColor,
        selectedIndex: currentPageIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(
              CupertinoIcons.square_grid_2x2_fill,
              color: currentPageIndex == 0 ? Colors.blueAccent : Colors.grey,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.download,
              color: currentPageIndex == 1 ? Colors.blueAccent : Colors.grey,
            ),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline,
              color: currentPageIndex == 2 ? Colors.blueAccent : Colors.grey,
            ),
            label: 'User',
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withAlpha(50),
                Theme.of(context).primaryColorLight.withAlpha(50),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              tileMode: TileMode.mirror,
            ),
          ),
          child: <Widget>[
            const HomePage(),
            const SavePage(),
            const Center(child: Text('User')),
          ][currentPageIndex],
        ),
      ),
    );
  }
}
