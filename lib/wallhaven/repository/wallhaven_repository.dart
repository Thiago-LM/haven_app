import 'dart:async';

import 'package:haven_app/shared/shared.dart';
import 'package:haven_app/wallhaven/api/wallhaven_api_client.dart';

class WallhavenRepository {
  WallhavenRepository({WallhavenApiClient? wallhavenApiClient})
      : _wallhavenApiClient = wallhavenApiClient ?? WallhavenApiClient();

  final WallhavenApiClient _wallhavenApiClient;

  Future<WallpaperList> getWallpaper() async {
    final wallpaperList = await _wallhavenApiClient.wallpaperSearch();
    return wallpaperList;
  }
}
