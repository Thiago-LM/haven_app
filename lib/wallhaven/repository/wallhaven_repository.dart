import 'dart:async';

import 'package:haven_app/shared/shared.dart';
import 'package:haven_app/wallhaven/api/wallhaven_api_client.dart';

class WallhavenRepository {
  WallhavenRepository({WallhavenApiClient? wallhavenApiClient})
      : _wallhavenApiClient = wallhavenApiClient ?? WallhavenApiClient();

  final WallhavenApiClient _wallhavenApiClient;

  Future<WallpaperList> getWallpaper({String? query, int? pageIndex}) async {
    final wallpaperList = await _wallhavenApiClient.wallpaperSearch(
      query: query,
      pageIndex: pageIndex ?? 1,
    );
    return wallpaperList;
  }

  Future<WallpaperInfo> getWallpaperInfo({required String id}) async {
    final wallpaper = await _wallhavenApiClient.wallpaperInfo(id: id);
    return wallpaper;
  }
}
