import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:haven_app/home/home.dart';
import 'package:haven_app/wallpaper/wallpaper.dart';

class HomeWallpaperList extends StatelessWidget {
  const HomeWallpaperList({required this.onRefresh, super.key});

  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    return RefreshIndicator(
      onRefresh: onRefresh,
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
                              errorWidget: (context, url, error) => const Icon(
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
  }
}
