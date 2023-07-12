import 'package:haven_app/data/model/wallpaper_list.dart';
import 'package:haven_app/data/provider/wallhaven_api_client.dart';

class HomeRepository {
  final WallhavenApiClient api;

  HomeRepository(this.api);

  Future<WallpaperList> getWallpaper({String? query, int? pageIndex}) async {
    final wallpaperList = await api.wallpaperSearch(
      query: query,
      pageIndex: pageIndex ?? 1,
    );
    return wallpaperList;
  }
}
