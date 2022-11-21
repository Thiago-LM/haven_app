import 'dart:io';

import 'package:flutter/material.dart';

class SavePage extends StatefulWidget {
  const SavePage({super.key});

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  List<FileSystemEntity> imageFiles = <FileSystemEntity>[];

  @override
  void initState() {
    imageFiles = Directory('storage/emulated/0/Pictures/wallhaven/').listSync();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
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
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              imageFiles.length > 1
                  ? '${imageFiles.length} wallpapers that you saved'
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
                itemCount: imageFiles.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: GestureDetector(
                      child: Image.file(
                        File(imageFiles[index].path),
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
        ],
      ),
    );
  }
}
