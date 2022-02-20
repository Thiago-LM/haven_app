import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haven_app/ui/widgets/custom_search_dialog.dart';
import 'package:http/http.dart' as http;

import 'package:haven_app/model/search/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Future<Search> futureSearch;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    futureSearch = fetchSearch();
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(style: BorderStyle.none),
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextField(
                    controller: _textController,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      hintText: 'Find Wallpaper...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.grey[400],
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
                              child: Image.network(
                                snapshot.data!.data![index].thumbs!.original!,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_grid_2x2_fill),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.download),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_outlined),
              label: 'User',
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue[800],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  Future<Search> fetchSearch() async {
    final response =
        await http.get(Uri.parse('https://wallhaven.cc/api/v1/search'));

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
