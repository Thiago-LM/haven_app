import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:haven_app/wallhaven/repository/wallhaven_repository.dart';
import 'package:haven_app/wallpaper/wallpaper.dart';

class WallPage extends StatelessWidget {
  const WallPage({required this.id, required this.url, super.key});

  final String id;
  final String url;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WallpaperCubit(context.read<WallhavenRepository>()),
      child: WallView(id: id, url: url),
    );
  }
}

class WallView extends StatefulWidget {
  const WallView({required this.id, required this.url, super.key});

  final String id;
  final String url;

  @override
  State<WallView> createState() => _WallViewState();
}

class _WallViewState extends State<WallView> {
  WallpaperCubit get cubit => context.read<WallpaperCubit>();

  @override
  void initState() {
    super.initState();
    cubit.getWallpaperInfo(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: widget.url,
            filterQuality: FilterQuality.high,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator.adaptive()),
            errorWidget: (context, url, error) => const Icon(
              Icons.error,
              color: Colors.red,
            ),
            height: double.maxFinite,
            width: double.maxFinite,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 48,
            left: 16,
            child: IconButton(
              icon: const Icon(CupertinoIcons.back),
              color: Colors.white,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white24),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 5,
            right: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BlocBuilder<WallpaperCubit, WallpaperState>(
                  builder: (context, state) {
                    return RoundedSquareButton(
                      name: 'Info',
                      icon: CupertinoIcons.info,
                      action: () => showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) =>
                            InfoDialog(wallpaper: state.wallpaper!.data),
                      ),
                    );
                  },
                ),
                RoundedSquareButton(
                  name: 'Save',
                  icon: Icons.download,
                  action: () => showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext context) => SaveDialog(
                      stream: cubit.downloadImageStream(url: widget.url),
                    ),
                  ),
                ),
                RoundedSquareButton(
                  name: 'Share',
                  icon: CupertinoIcons.share,
                  action: () => showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext context) => ShareDialog(
                      onPressedFile: () => cubit
                          .shareWallpaper(url: widget.url, isFile: true)
                          .then((value) => Navigator.of(context).pop()),
                      onPressedLink: () => cubit
                          .shareWallpaper(url: widget.url, isFile: false)
                          .then((value) => Navigator.of(context).pop()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
