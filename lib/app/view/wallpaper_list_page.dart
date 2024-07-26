import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:haven_app/app/app.dart';
import 'package:haven_app/shared/models/models.dart';

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
    final cubit = ctx.read<WallpaperCubit>();

    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.pink.shade50,
            Colors.cyan.shade100,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          forceMaterialTransparency: true,
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                titleModel.icon,
                color: titleModel.iconColor,
                size: 32,
              ),
              const SizedBox(width: 8),
              Text(
                titleModel.searchTitle,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
        ),
        body: BlocBuilder<WallpaperCubit, WallpaperState>(
          bloc: cubit,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _subTitle(length: state.wallpaperList.meta.total),
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
                switch (state.homeStatus) {
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
                  // HomeStatus.success => _wallpaperList2(
                  //     context: context,
                  //     mediaSize: mediaSize,
                  //     data: state.wallpaperList.data,
                  //   ),
                  HomeStatus.failure =>
                    const Center(child: Text('Failed to load wallpapers'))
                },
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _subTitle({required int length}) => Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            length > 0
                ? '$length ${length > 1 ? 'wallpapers' : 'wallpaper'} available'
                : 'No wallpaper available',
            style: const TextStyle(fontSize: 20, color: Colors.grey),
          ),
        ),
      );

  Widget _pageCounter({
    required int currentPage,
    required int lastPage,
    required VoidCallback onBackPressed,
    required VoidCallback onForwardPressed,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(CupertinoIcons.chevron_left),
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            disabledColor: Colors.transparent,
            color: currentPage > 1 ? null : Colors.transparent,
            onPressed: currentPage > 1 ? onBackPressed : null,
          ),
          const SizedBox(width: 8),
          Text('Page $currentPage of $lastPage'),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(CupertinoIcons.chevron_right),
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            disabledColor: Colors.transparent,
            color: currentPage < lastPage ? null : Colors.transparent,
            onPressed: currentPage < lastPage ? onForwardPressed : null,
          ),
        ],
      );

  Widget _wallpaperList({
    required Size mediaSize,
    required List<Wallpaper> data,
  }) =>
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: GridView.builder(
            itemCount: data.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
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
                        builder: (_) => WallpaperDetailsPage(
                          id: data[index].id,
                          url: data[index].path,
                        ),
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

  // Widget _wallpaperList2({
  //   required BuildContext context,
  //   required Size mediaSize,
  //   required List<Wallpaper> data,
  // }) =>
  //     Expanded(
  //       child: SingleChildScrollView(
  //         child: SizedBox(
  //           height: (data
  //                       .map((wallpaper) => wallpaper.dimensionY / 10)
  //                       .reduce((a, b) => a + b) /
  //                   2) +
  //               16 * data.length,
  //           child: CustomMultiChildLayout(
  //             delegate: YourLayoutDelegate(
  //               position: Offset.zero,
  //               data: data,
  //             ),
  //             children: data
  //                 .map(
  //                   (wallpaper) => LayoutId(
  //                     id: data.indexOf(wallpaper),
  //                     child: Container(
  //                       height: wallpaper.dimensionY / 10,
  //                       width: (mediaSize.width / 2) - 24,
  //                       decoration: wallpaper.purity.contains('sketchy')
  //                           ? BoxDecoration(
  //                               border:
  //                                   Border.all(width: 3, color: Colors.yellow),
  //                               borderRadius:
  //                                   const BorderRadius.all(Radius.circular(18)),
  //                             )
  //                           : wallpaper.purity.contains('nsfw')
  //                               ? BoxDecoration(
  //                                   border:
  //                                       Border.all(width: 3, color: Colors.red),
  //                                   borderRadius: const BorderRadius.all(
  //                                     Radius.circular(18),
  //                                   ),
  //                                 )
  //                               : null,
  //                       child: ClipRRect(
  //                         borderRadius:
  //                             const BorderRadius.all(Radius.circular(15)),
  //                         child: GestureDetector(
  //                           child: CachedNetworkImage(
  //                             imageUrl: wallpaper.thumbs.original,
  //                             filterQuality: FilterQuality.high,
  //                             placeholder: (context, url) =>
  //                                 const CircularProgressIndicator.adaptive(),
  //                             errorWidget: (context, url, error) => const Icon(
  //                               Icons.error,
  //                               color: Colors.red,
  //                             ),
  //                             fit: BoxFit.cover,
  //                           ),
  //                           onTap: () => Navigator.of(context).push(
  //                             MaterialPageRoute<void>(
  //                               builder: (_) => WallpaperDetailsPage(
  //                                 id: wallpaper.id,
  //                                 url: wallpaper.path,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //                 .toList(),
  //           ),
  //         ),
  //       ),
  //     );
}

// class YourLayoutDelegate extends MultiChildLayoutDelegate {
//   YourLayoutDelegate({required this.position, required this.data});

//   final Offset position;
//   final List<Wallpaper> data;

//   @override
//   void performLayout(Size size) {
//     var lastHeightEven = 0.0;
//     var lastHeightOdd = 0.0;

//     for (final wallpaper in data) {
//       final childId = data.indexOf(wallpaper);

//       final childOffset = Offset(
//         16 + (childId.isEven ? 0 : (size.width / 2) - 8),
//         (childId + 1).isOdd
//             ? childId == 0
//                 ? 0
//                 : lastHeightEven + (data[childId - 2].dimensionY / 10) + 16
//             : childId == 1
//                 ? 0
//                 : lastHeightOdd + (data[childId - 2].dimensionY / 10) + 16,
//       );

//       if ((childId + 1).isOdd) {
//         lastHeightEven = childOffset.dy;
//       } else {
//         lastHeightOdd = childOffset.dy;
//       }

//       if (hasChild(childId)) {
//         layoutChild(childId, BoxConstraints.loose(size));
//         positionChild(childId, childOffset);
//       }
//     }
//   }

//   @override
//   bool shouldRelayout(YourLayoutDelegate oldDelegate) {
//     return oldDelegate.position != position;
//   }
// }
