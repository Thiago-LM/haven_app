import 'package:flutter/material.dart';
import 'package:haven_app/ui/custom_bottom_navigation_bar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallhaven Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CustomBottomNavigationBar(),
    );
  }
}
