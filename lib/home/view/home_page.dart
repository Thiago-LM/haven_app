import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haven_app/home/cubit/home_cubit.dart';
import 'package:haven_app/home/widgets/custom_search_dialog.dart';
import 'package:haven_app/wallhaven/wallhaven.dart';
import 'package:haven_app/wallpaper/wall_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(context.read<WallhavenRepository>()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeCubit get cubit => context.read<HomeCubit>();
  late TextEditingController _textController;

  @override
  void initState() {
    cubit.fetchWallpaper();
    _textController = TextEditingController();

    super.initState();
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(vertical: 10),
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
                    onPressed: () => showDialog<void>(
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                switch (state.status) {
                  case HomeStatus.initial:
                  case HomeStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  case HomeStatus.success:
                    return SizedBox(
                      height: (mediaSize.height / 4.5) * 3.3,
                      child: GridView.builder(
                        itemCount: state.wallpaperList.data.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            child: GestureDetector(
                              child: CachedNetworkImage(
                                imageUrl: state
                                    .wallpaperList.data[index].thumbs.original,
                                filterQuality: FilterQuality.high,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                                fit: BoxFit.cover,
                              ),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => WallPage(
                                    url: state.wallpaperList.data[index].path,
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
                          mainAxisExtent: mediaSize.height / 4.5,
                        ),
                      ),
                    );
                  case HomeStatus.failure:
                    return const Center(
                      child: Text('Failed to load wallpaper'),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
