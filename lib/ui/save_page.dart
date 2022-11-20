import 'dart:io';

import 'package:flutter/material.dart';

class SavePage extends StatefulWidget {
  const SavePage({super.key});

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  var imageFiles = <FileSystemEntity>[];

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
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: Text(
              'Saved',
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              imageFiles.length > 1
                  ? '${imageFiles.length} wallpapers that you saved'
                  : 'A wallpaper you saved',
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: (mediaSize.height / 4.5) * 3.3,
              child: GridView.builder(
                itemCount: imageFiles.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                    child: GestureDetector(
                      onTap: null,
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
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
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
