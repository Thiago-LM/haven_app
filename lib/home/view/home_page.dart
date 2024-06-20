import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:haven_app/home/home.dart';
import 'package:haven_app/wallhaven/wallhaven.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(context.read<WallhavenRepository>()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeCubit get cubit => context.read<HomeCubit>();

  final _textController = TextEditingController();

  HomeSearchTitleModel searchTitleModel = const HomeSearchTitleModel(
    icon: Icons.diamond_outlined,
    iconColor: Colors.purple,
    searchTitle: 'Best of the month',
  );

  @override
  void initState() {
    cubit.fetchWallpaper();
    _textController.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSearchBar(
            textController: _textController,
            onPressed: () async {
              setState(
                () => searchTitleModel =
                    HomeSearchTitleModel.search(_textController.text),
              );
              cubit.updateStatus(HomeStatus.loading);
              await cubit.fetchWallpaper(query: _textController.text);
            },
          ),
          const SizedBox(height: 16),
          HomeSearchTitle(model: searchTitleModel),
          HomeWallpaperList(
            onRefresh: () async {
              cubit.updateStatus(HomeStatus.loading);
              await cubit.fetchWallpaper();
            },
          ),
          const SizedBox(height: 32),
          HomeCategoryListButtons(
            toplistOnPressed: () async {
              _textController.clear();
              setState(
                () => searchTitleModel = const HomeSearchTitleModel.toplist(),
              );
              cubit.updateStatus(HomeStatus.loading);
              await cubit.fetchWallpaper();
            },
            latestOnPressed: () async {
              _textController.clear();
              setState(
                () => searchTitleModel = const HomeSearchTitleModel.latest(),
              );
              cubit.updateStatus(HomeStatus.loading);
              await cubit.fetchWallpaper(sorting: WallpaperSorting.latest);
            },
            hotOnPressed: () async {
              _textController.clear();
              setState(
                () => searchTitleModel = const HomeSearchTitleModel.hot(),
              );
              cubit.updateStatus(HomeStatus.loading);
              await cubit.fetchWallpaper(sorting: WallpaperSorting.hot);
            },
            randomOnPressed: () async {
              _textController.clear();
              setState(
                () => searchTitleModel = const HomeSearchTitleModel.random(),
              );
              cubit.updateStatus(HomeStatus.loading);
              await cubit.fetchWallpaper(sorting: WallpaperSorting.random);
            },
          ),
        ],
      ),
    );
  }
}
