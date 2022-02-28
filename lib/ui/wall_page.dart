import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class WallPage extends StatelessWidget {
  const WallPage({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: url,
              filterQuality: FilterQuality.high,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                color: Colors.red,
              ),
              height: double.maxFinite,
              width: double.maxFinite,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 30.0,
              left: 5.0,
              right: 5.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  customButton(
                    context: context,
                    name: 'Info',
                    icon: CupertinoIcons.info,
                    action: () {},
                  ),
                  customButton(
                    context: context,
                    name: 'Save',
                    icon: Icons.download,
                    action: () async => await downloadImage(),
                  ),
                  customButton(
                    context: context,
                    name: 'Apply',
                    icon: CupertinoIcons.paintbrush,
                    action: () async => await applyImage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customButton({
    required BuildContext context,
    required String name,
    required IconData icon,
    required void Function()? action,
  }) {
    return Column(
      children: [
        ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.white24,
            elevation: 0.0,
            fixedSize: Size(
              MediaQuery.of(context).size.height / 11,
              MediaQuery.of(context).size.height / 11,
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
          ),
          onPressed: action,
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
              size: 30.0,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Future<void> downloadImage() async {
    Directory dir = Directory('storage/emulated/0/Pictures/wallhaven/');
    if (!(await dir.exists())) {
      log('$dir doesnt exist');
      await dir.create();
    }
    log('$dir exist');

    File file = File(dir.path + url.substring(url.lastIndexOf('/') + 1));
    log('file = ${file.path}');
    file.writeAsBytesSync((await http.get(Uri.parse(url))).bodyBytes);
  }

  static const platform = MethodChannel('br.com.odawara/wallpaper');

  Future<void> setWallpaper({required String path}) async {
    try {
      await platform.invokeMethod('setWallpaper', {'path': path});
    } catch (e) {
      log('Failed to set Wallpaper: $e');
    }
  }

  Future<void> applyImage() async {
    Directory tempDir = Directory(
        (await getApplicationDocumentsDirectory()).path + '/wallhaven/');
    if (!(await tempDir.exists())) {
      log('$tempDir doesnt exist');
      await tempDir.create();
    }
    log('$tempDir exist');

    File file = File(tempDir.path + url.substring(url.lastIndexOf('/') + 1));
    log('file = ${file.path}');
    file.writeAsBytesSync((await http.get(Uri.parse(url))).bodyBytes);

    await setWallpaper(path: file.path);
  }
}
