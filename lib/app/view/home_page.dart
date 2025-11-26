import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haven_app/app/app.dart';
import 'package:haven_app/shared/models/models.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WallpaperCubit get cubit => context.read<WallpaperCubit>();

  final _textController = TextEditingController();

  HomeSearchTitleModel searchTitleModel = const HomeSearchTitleModel.toplist();

  void unfocus() => FocusScope.of(context).unfocus();

  @override
  void initState() {
    cubit.fetchWallpaper();
    searchTitleModel = cubit.state.homeSearchTitleModel;
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 64, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeSearchBar(
                textController: _textController,
                onFilterPressed: () => showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext _) {
                    return CustomSearchDialog(ctx: context);
                  },
                ),
                onSearchPressed: () async {
                  unfocus();
                  setState(
                    () => searchTitleModel = _textController.text.isEmpty
                        ? switch (cubit.state.wallQuery.sorting) {
                            WallpaperSorting.toplist =>
                              const HomeSearchTitleModel.toplist(),
                            WallpaperSorting.hot =>
                              const HomeSearchTitleModel.hot(),
                            WallpaperSorting.latest =>
                              const HomeSearchTitleModel.latest(),
                            WallpaperSorting.random =>
                              const HomeSearchTitleModel.random(),
                            _ => HomeSearchTitleModel.search(
                              cubit.state.wallQuery.sorting!.name,
                            ),
                          }
                        : HomeSearchTitleModel.search(_textController.text),
                  );
                  cubit.updateStatus(HomeStatus.loading);
                  await cubit.fetchWallpaper(
                    wallQuery: cubit.state.wallQuery.copyWith(
                      query: _textController.text,
                      page: 1,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              HomeSearchTitle(
                model: searchTitleModel,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => WallpaperListPage(
                      ctx: context,
                      titleModel: searchTitleModel,
                    ),
                  ),
                ),
              ),
              HomeWallpaperList(
                onRefresh: () async {
                  unfocus();
                  cubit.updateStatus(HomeStatus.loading);
                  await cubit.fetchWallpaper();
                },
              ),
              const SizedBox(height: 32),
              const HomeColorsToneList(),
              const SizedBox(height: 32),
              HomeCategoryListButtons(
                toplistOnPressed: () async {
                  unfocus();
                  _textController.clear();
                  setState(
                    () =>
                        searchTitleModel = const HomeSearchTitleModel.toplist(),
                  );
                  cubit
                    ..updateStatus(HomeStatus.loading)
                    ..updateHomeSearchTitleModel(
                      const HomeSearchTitleModel.toplist(),
                    );
                  await cubit.fetchWallpaper(
                    wallQuery: WallpaperQuery(
                      category: null,
                      purity: null,
                      order: null,
                      topRange: null,
                      apikey: cubit.state.wallQuery.apikey,
                    ),
                  );
                },
                latestOnPressed: () async {
                  unfocus();
                  _textController.clear();
                  setState(
                    () =>
                        searchTitleModel = const HomeSearchTitleModel.latest(),
                  );
                  cubit
                    ..updateStatus(HomeStatus.loading)
                    ..updateHomeSearchTitleModel(
                      const HomeSearchTitleModel.latest(),
                    );
                  await cubit.fetchWallpaper(
                    wallQuery: WallpaperQuery(
                      category: null,
                      purity: null,
                      sorting: WallpaperSorting.latest,
                      order: null,
                      apikey: cubit.state.wallQuery.apikey,
                    ),
                  );
                },
                hotOnPressed: () async {
                  unfocus();
                  _textController.clear();
                  setState(
                    () => searchTitleModel = const HomeSearchTitleModel.hot(),
                  );
                  cubit
                    ..updateStatus(HomeStatus.loading)
                    ..updateHomeSearchTitleModel(
                      const HomeSearchTitleModel.hot(),
                    );
                  await cubit.fetchWallpaper(
                    wallQuery: WallpaperQuery(
                      category: null,
                      purity: null,
                      sorting: WallpaperSorting.hot,
                      order: null,
                      apikey: cubit.state.wallQuery.apikey,
                    ),
                  );
                },
                randomOnPressed: () async {
                  unfocus();
                  _textController.clear();
                  setState(
                    () =>
                        searchTitleModel = const HomeSearchTitleModel.random(),
                  );
                  cubit
                    ..updateStatus(HomeStatus.loading)
                    ..updateHomeSearchTitleModel(
                      const HomeSearchTitleModel.random(),
                    );
                  await cubit.fetchWallpaper(
                    wallQuery: WallpaperQuery(
                      category: null,
                      purity: null,
                      sorting: WallpaperSorting.random,
                      order: null,
                      apikey: cubit.state.wallQuery.apikey,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
