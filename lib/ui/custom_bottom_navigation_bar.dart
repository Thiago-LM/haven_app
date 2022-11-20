import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haven_app/ui/home_page.dart';
import 'package:haven_app/ui/save_page.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SavePage(),
    Text('User'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_grid_2x2_fill),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.download),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_outlined),
              label: 'User',
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}
