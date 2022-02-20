import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'wall_page.dart';
import 'widgets/custom_search_dialog.dart';
import 'package:haven_app/model/search/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Search> futureSearch;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    futureSearch = fetchBestOfTheMonth();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  style: BorderStyle.solid,
                  width: 2.0,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                controller: _textController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Find Wallpaper...',
                  hintStyle: const TextStyle(color: Colors.black87),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black87,
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) =>
                          CustomSearchDialog(mediaSize: mediaSize),
                    ),
                  ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
            const Text(
              'Best of the month',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            FutureBuilder<Search>(
              future: futureSearch,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: (mediaSize.height / 4.5) * 3.3,
                    child: GridView.builder(
                      itemCount: snapshot.data!.data!.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15.0)),
                          child: GestureDetector(
                            child: CachedNetworkImage(
                              imageUrl:
                                  snapshot.data!.data![index].thumbs!.original!,
                              filterQuality: FilterQuality.high,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                              fit: BoxFit.cover,
                            ),
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => WallPage(
                                        url: snapshot
                                            .data!.data![index].path!))),
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: mediaSize.height / 4.5,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Search> fetchBestOfTheMonth() async {
    final response = await http
        .get(Uri.parse('https://wallhaven.cc/api/v1/search?sorting=toplist'));

    log('response.statusCode = ${response.statusCode}');
    log('response.body = ${response.body}');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Search.fromMap(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load search');
    }
  }
}
