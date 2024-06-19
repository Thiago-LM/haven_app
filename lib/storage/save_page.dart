import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

class SavePage extends StatelessWidget {
  const SavePage({super.key});

  Future<List<FileSystemEntity>> getImages() async {
    late Directory dir;

    switch (Platform.operatingSystem) {
      case 'android':
        dir = Directory('storage/emulated/0/Pictures/wallhaven/');
      case 'macos':
        final docDir = await getApplicationDocumentsDirectory();
        final listDirString = docDir.path.split('/');
        dir = Directory('/Users/${listDirString[2]}/Pictures/wallhaven/');
      default:
        dir = Directory('');
    }

    if (dir.existsSync()) {
      return dir.listSync();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    return FutureBuilder<List<FileSystemEntity>>(
      future: getImages(),
      builder: (context, snapshot) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                  'Saved',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (snapshot.hasData && snapshot.data!.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    snapshot.data!.length > 1
                        ? '${snapshot.data!.length} wallpapers that you saved'
                        : 'A wallpaper you saved',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: (mediaSize.height / 4.5) * 3.3,
                    child: GridView.builder(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          child: GestureDetector(
                            child: Image.file(
                              File(snapshot.data![index].path),
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.cover,
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
                ),
              ] else ...[
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Can't find any saved wallpaper",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
