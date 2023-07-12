import 'dart:async';

import 'package:get/get.dart';

import 'package:haven_app/data/model/wallpaper_info.dart';
import 'package:haven_app/data/model/wallpaper_list.dart';

/// Exception thrown when wallpaperSearch fails.
class WallpaperSearchRequestFailure implements Exception {
  const WallpaperSearchRequestFailure(this.message);

  final String message;

  @override
  String toString() => 'WallpaperSearchRequestFailure(message: $message)';
}

/// Exception thrown when the provided wallpaper is not found.
class WallpaperNotFoundFailure implements Exception {
  const WallpaperNotFoundFailure(this.message);

  final String message;

  @override
  String toString() => 'WallpaperNotFoundFailure(message: $message)';
}

/// Exception thrown when the provided wallpaper id info is not found.
class WallpaperIdInfoNotFoundFailure implements Exception {
  const WallpaperIdInfoNotFoundFailure(this.message);

  final String message;

  @override
  String toString() => 'WallpaperIdInfoNotFoundFailure(message: $message)';
}

/// {@template wallhaven_api_client}
/// Dart API Client which wraps the [wallhaven](https://wallhaven.cc/).
/// {@endtemplate}
class WallhavenApiClient extends GetConnect {
  static const String _baseUrl = 'https://wallhaven.cc';

  /// Finds a [Wallpaper]. (Default: `/search?sorting=toplist`)
  Future<WallpaperList> wallpaperSearch({
    String? query,
    int pageIndex = 1,
  }) async {
    final response = await get(
      '$_baseUrl/api/v1/search',
      query: query == null
          ? {'sorting': 'toplist', 'page': '$pageIndex'}
          : {'q': query, 'page': '$pageIndex'},
    );

    if (response.statusCode != 200) {
      throw WallpaperSearchRequestFailure(
        'Request failed with status: ${response.statusCode}',
      );
    }

    final wallpaperListJson = response.body as Map<String, dynamic>;

    if (!wallpaperListJson.containsKey('data')) {
      throw const WallpaperNotFoundFailure(
        'Wallpaper not found. Please check your query.',
      );
    }

    return WallpaperList.fromJson(wallpaperListJson);
  }

  /// Get [Wallpaper] info by id.
  Future<WallpaperInfo> wallpaperInfo({required String id}) async {
    final response = await get('$_baseUrl/api/v1/w/$id');

    if (response.statusCode != 200) {
      throw WallpaperIdInfoNotFoundFailure(
        'Request failed with status: ${response.statusCode}',
      );
    }

    final wallpaperInfoJson = response.body as Map<String, dynamic>;

    return WallpaperInfo.fromJson(wallpaperInfoJson);
  }
}
