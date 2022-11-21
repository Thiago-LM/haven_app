import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haven_app/custom_bottom_navigation/custom_bottom_navigation.dart';
import 'package:haven_app/home/view/home_page.dart';
import 'package:haven_app/storage/save_page.dart';

class CustomBottomNavigationPage extends StatelessWidget {
  const CustomBottomNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomBottomNavigationCubit(),
      child: const CustomBottomNavigationView(),
    );
  }
}

class CustomBottomNavigationView extends StatelessWidget {
  const CustomBottomNavigationView({super.key});

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SavePage(),
    Text('User'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
          BlocBuilder<CustomBottomNavigationCubit, CustomBottomNavigationState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: _widgetOptions.elementAt(state.selectedTabIndex),
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
              currentIndex: state.selectedTabIndex,
              selectedItemColor: Colors.black,
              onTap: context
                  .read<CustomBottomNavigationCubit>()
                  .updateSelectedTabIndex,
            ),
          );
        },
      ),
    );
  }
}
