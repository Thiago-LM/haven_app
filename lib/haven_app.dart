import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haven_app/tab_bar_navigation/tab_bar_navigation.dart';
import 'package:haven_app/wallhaven/wallhaven.dart';

class HavenApp extends StatelessWidget {
  const HavenApp({super.key, required this.wallhavenRepository});

  final WallhavenRepository wallhavenRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: wallhavenRepository,
      child: const HavenAppView(),
    );
  }
}

class HavenAppView extends StatelessWidget {
  const HavenAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const TabBarNavigationPage(),
    );
  }
}
