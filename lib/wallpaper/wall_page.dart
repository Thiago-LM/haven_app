import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haven_app/wallpaper/widgets/rounded_square_button.dart';
import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';

class WallPage extends StatelessWidget {
  const WallPage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: url,
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
          const SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: BackButton(
                color: Colors.black,
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
                RoundedSquareButton(
                  name: 'Info',
                  icon: CupertinoIcons.info,
                  action: () {},
                ),
                RoundedSquareButton(
                  name: 'Save',
                  icon: Icons.download,
                  action: () async => downloadImage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> downloadImage() async {
    final dir = Directory('storage/emulated/0/Pictures/wallhaven/');
    if (!dir.existsSync()) {
      log('$dir doesnt exist');
      dir.createSync(recursive: true);
    }
    log('$dir exist');

    final file = File(dir.path + url.substring(url.lastIndexOf('/') + 1));
    log('file = ${file.path}');
    final fileBodyBytes = await http.readBytes(Uri.parse(url));
    file.writeAsBytesSync(fileBodyBytes);
  }

  // Calculate dominant color from ImageProvider
  Future<Color> getImagePalette(ImageProvider imageProvider) async {
    final paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor!.color;
  }
}
