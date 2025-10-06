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
        indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
        backgroundColor: Colors.blueGrey[400],
        selectedIndex: currentPageIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(
              currentPageIndex == 0
                  ? CupertinoIcons.square_grid_2x2_fill
                  : CupertinoIcons.square_grid_2x2,
              color: currentPageIndex == 0 ? Colors.blueAccent : Colors.black,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              currentPageIndex == 1 ? Icons.download : Icons.download_outlined,
              color: currentPageIndex == 1 ? Colors.blueAccent : Colors.black,
            ),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(
              currentPageIndex == 2 ? Icons.person : Icons.person_outline,
              color: currentPageIndex == 2 ? Colors.blueAccent : Colors.black,
            ),
            label: 'User',
          ),
        ],
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade50, Colors.cyan.shade100],
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
