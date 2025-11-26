import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:haven_app/app/app.dart';

class HomeWallpaperList extends StatelessWidget {
  const HomeWallpaperList({required this.onRefresh, super.key});

  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: BlocBuilder<WallpaperCubit, WallpaperState>(
        builder: (context, state) {
          switch (state.homeStatus) {
            case HomeStatus.initial:
            case HomeStatus.loading:
              return const Center(child: CircularProgressIndicator.adaptive());
            case HomeStatus.success:
              return SizedBox(
                height: mediaSize.height * 0.3,
                child: ListView.builder(
                  itemCount: state.wallpaperList.data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      width: mediaSize.width > 1200
                          ? mediaSize.width * 0.15
                          : mediaSize.width > 800
                          ? mediaSize.width * 0.25
                          : mediaSize.width * 0.4,
                      margin: const EdgeInsets.only(top: 8, right: 16),
                      decoration:
                          state.wallpaperList.data[index].purity.contains(
                            'sketchy',
                          )
                          ? BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: Colors.yellow,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(18),
                              ),
                            )
                          : state.wallpaperList.data[index].purity.contains(
                              'nsfw',
                            )
                          ? BoxDecoration(
                              border: Border.all(width: 3, color: Colors.red),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(18),
                              ),
                            )
                          : null,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        child: GestureDetector(
                          child: CachedNetworkImage(
                            imageUrl:
                                state.wallpaperList.data[index].thumbs.original,
                            filterQuality: FilterQuality.high,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator.adaptive(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error, color: Colors.red),
                            fit: BoxFit.cover,
                          ),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => WallpaperDetailsPage(
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
              );
            case HomeStatus.failure:
              return const Center(child: Text('Failed to load wallpaper'));
          }
        },
      ),
    );
  }
}
