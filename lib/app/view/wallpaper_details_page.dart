import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haven_app/app/app.dart';

class WallpaperDetailsPage extends StatefulWidget {
  const WallpaperDetailsPage({required this.id, required this.url, super.key});

  final String id;
  final String url;

  @override
  State<WallpaperDetailsPage> createState() => _WallpaperDetailsPageState();
}

class _WallpaperDetailsPageState extends State<WallpaperDetailsPage> {
  WallpaperCubit get cubit => context.read<WallpaperCubit>();

  BoxFit fit = BoxFit.cover;

  @override
  void initState() {
    super.initState();
    cubit.getWallpaperInfo(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: widget.url,
            filterQuality: FilterQuality.high,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator.adaptive()),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, color: Colors.red),
            height: double.maxFinite,
            width: double.maxFinite,
            fit: fit,
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
            top: 48,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.aspect_ratio_outlined),
              color: Colors.white,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white24),
              ),
              onPressed: () => setState(
                () => fit = fit == BoxFit.cover ? BoxFit.contain : BoxFit.cover,
              ),
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
                            InfoDialog(wallpaper: state.wallpaperInfo!.data),
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
                    builder: (BuildContext ctx) {
                      final navigator = Navigator.of(ctx);

                      return ShareDialog(
                        onPressedFile: () => cubit
                            .shareWallpaper(url: widget.url, isFile: true)
                            .then((value) => navigator.pop()),
                        onPressedLink: () => cubit
                            .shareWallpaper(url: widget.url, isFile: false)
                            .then((value) => navigator.pop()),
                      );
                    },
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
