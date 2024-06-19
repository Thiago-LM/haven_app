import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:haven_app/home/cubit/home_cubit.dart';
import 'package:haven_app/wallhaven/wallhaven.dart';
import 'package:haven_app/wallpaper/view/wall_page.dart';

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
  String searchTitle = 'Best of the month';

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
    final mediaSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _homeSearchBar(),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.diamond_outlined,
                color: Colors.purple,
              ),
              const SizedBox(width: 10),
              Text(
                searchTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          _homeWallpaperList(mediaSize: mediaSize),
          const SizedBox(height: 32),
          _homeCategoryListButtons(),
        ],
      ),
    );
  }

  Widget _homeSearchBar() => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.transparent),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: _textController.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.grey,
                            ),
                            onPressed: _textController.clear,
                          ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
              const VerticalDivider(),
              IconButton(
                icon: const Icon(CupertinoIcons.search),
                color: Colors.grey,
                onPressed: () async {
                  cubit.updateStatus(HomeStatus.loading);
                  await cubit.fetchWallpaper(
                    query: _textController.text,
                  );
                  setState(() => searchTitle = _textController.text);
                  _textController.clear();
                },
              ),
            ],
          ),
        ),
      );

  Widget _homeWallpaperList({required Size mediaSize}) => RefreshIndicator(
        onRefresh: () async {
          cubit.updateStatus(HomeStatus.loading);
          await cubit.fetchWallpaper();
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            switch (state.status) {
              case HomeStatus.initial:
              case HomeStatus.loading:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case HomeStatus.success:
                return SizedBox(
                  height: mediaSize.height * 0.3,
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: state.wallpaperList.data.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          width: mediaSize.width * 0.4,
                          padding: const EdgeInsets.only(top: 8, right: 16),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            child: GestureDetector(
                              child: CachedNetworkImage(
                                imageUrl: state
                                    .wallpaperList.data[index].thumbs.original,
                                filterQuality: FilterQuality.high,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator.adaptive(),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                                fit: BoxFit.cover,
                              ),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => WallPage(
                                    id: state.wallpaperList.data[index].id,
                                    url: state.wallpaperList.data[index].path,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              case HomeStatus.failure:
                return const Center(
                  child: Text('Failed to load wallpaper'),
                );
            }
          },
        ),
      );

  Widget _homeCategoryListButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              TextButton.icon(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Colors.purple,
                  backgroundColor: Colors.purple[50],
                ),
                icon: const Icon(Icons.diamond_outlined, size: 36),
                label: const Text(
                  'Toplist',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                  backgroundColor: Colors.green[50],
                ),
                icon: const Icon(Icons.schedule_outlined, size: 36),
                label: const Text(
                  'Latest',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          Column(
            children: [
              TextButton.icon(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.red[50],
                ),
                icon: const Icon(
                  Icons.local_fire_department_outlined,
                  size: 36,
                ),
                label: const Text(
                  'Hot',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Colors.orange,
                  backgroundColor: Colors.orange[50],
                ),
                icon: const Icon(
                  Icons.shuffle_outlined,
                  size: 36,
                ),
                label: const Text(
                  'Random',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      );
}
