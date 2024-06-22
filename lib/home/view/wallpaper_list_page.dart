import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:haven_app/home/home.dart';
import 'package:haven_app/shared/models/models.dart';
import 'package:haven_app/wallpaper/wallpaper.dart';

class WallpaperListPage extends StatelessWidget {
  const WallpaperListPage({
    required this.titleModel,
    required this.ctx,
    super.key,
  });

  final BuildContext ctx;
  final HomeSearchTitleModel titleModel;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    final cubit = ctx.read<HomeCubit>();

    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withAlpha(50),
              Theme.of(context).primaryColorLight.withAlpha(50),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            tileMode: TileMode.mirror,
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            bloc: cubit,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _backButton(context),
                  _title(length: state.wallpaperList.data.length),
                  _pageCounter(
                    currentPage: state.wallpaperList.meta.currentPage,
                    lastPage: state.wallpaperList.meta.lastPage,
                    onBackPressed: () async {
                      cubit.updateStatus(HomeStatus.loading);
                      await cubit.fetchWallpaper(
                        wallQuery: cubit.state.wallQuery.copyWith(
                          page: state.wallpaperList.meta.currentPage > 1
                              ? state.wallpaperList.meta.currentPage - 1
                              : state.wallpaperList.meta.currentPage,
                        ),
                      );
                    },
                    onForwardPressed: () async {
                      cubit.updateStatus(HomeStatus.loading);
                      await cubit.fetchWallpaper(
                        wallQuery: cubit.state.wallQuery.copyWith(
                          page: state.wallpaperList.meta.currentPage <
                                  state.wallpaperList.meta.lastPage
                              ? state.wallpaperList.meta.currentPage + 1
                              : state.wallpaperList.meta.currentPage,
                        ),
                      );
                    },
                  ),
                  switch (state.status) {
                    HomeStatus.initial => const Expanded(
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                    HomeStatus.loading => const Expanded(
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                    HomeStatus.success => _wallpaperList(
                        mediaSize: mediaSize,
                        data: state.wallpaperList.data,
                      ),
                    HomeStatus.failure =>
                      const Center(child: Text('Failed to load wallpapers'))
                  },
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 16),
        child: IconButton(
          icon: const Icon(CupertinoIcons.back),
          hoverColor: Colors.transparent,
          onPressed: () => Navigator.of(context).pop(),
        ),
      );

  Widget _title({required int length}) => Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  titleModel.icon,
                  color: titleModel.iconColor,
                  size: 36,
                ),
                const SizedBox(width: 10),
                Text(
                  titleModel.searchTitle,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              length > 0
                  ? '$length ${length > 1 ? 'wallpapers' : 'wallpaper'} available'
                  : 'No wallpaper available',
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
          ],
        ),
      );

  Widget _pageCounter({
    required int currentPage,
    required int lastPage,
    required VoidCallback onBackPressed,
    required VoidCallback onForwardPressed,
  }) =>
      Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentPage > 1) ...[
              IconButton(
                icon: const Icon(CupertinoIcons.chevron_left),
                hoverColor: Colors.transparent,
                onPressed: onBackPressed,
              ),
              const SizedBox(width: 10),
            ],
            Text('Page $currentPage of $lastPage'),
            if (currentPage < lastPage) ...[
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(CupertinoIcons.chevron_right),
                hoverColor: Colors.transparent,
                onPressed: onForwardPressed,
              ),
            ],
          ],
        ),
      );

  Widget _wallpaperList({
    required Size mediaSize,
    required List<Wallpaper> data,
  }) =>
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                width: mediaSize.width * 0.4,
                decoration: data[index].purity.contains('sketchy')
                    ? BoxDecoration(
                        border: Border.all(width: 3, color: Colors.yellow),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(18)),
                      )
                    : data[index].purity.contains('nsfw')
                        ? BoxDecoration(
                            border: Border.all(width: 3, color: Colors.red),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(18)),
                          )
                        : null,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: GestureDetector(
                    child: CachedNetworkImage(
                      imageUrl: data[index].thumbs.original,
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
                        builder: (_) =>
                            WallPage(id: data[index].id, url: data[index].path),
                      ),
                    ),
                  ),
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: mediaSize.height / 3.0,
            ),
          ),
        ),
      );
}
