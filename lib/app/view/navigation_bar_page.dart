import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:haven_app/app/app.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink.shade50,
              Colors.cyan.shade100,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: <Widget>[
          const SingleChildScrollView(child: HomePage()),
          const SavePage(),
          const UserPage(),
        ][currentPageIndex],
      ),
    );
  }
}
