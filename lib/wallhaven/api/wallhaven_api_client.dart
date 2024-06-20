import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:haven_app/shared/shared.dart';

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

enum WallpaperSorting {
  toplist,
  latest,
  hot,
  random;

  String get value =>
      this == latest ? 'date_added' : toString().split('.').last;
}

/// {@template wallhaven_api_client}
/// Dart API Client which wraps the [wallhaven](https://wallhaven.cc/).
/// {@endtemplate}
class WallhavenApiClient {
  /// {@macro open_meteo_api_client}
  WallhavenApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'wallhaven.cc';

  final http.Client _httpClient;

  /// Finds a [Wallpaper]. (Default: `/search?sorting=toplist`)
  Future<WallpaperList> wallpaperSearch({
    String? query,
    int pageIndex = 1,
    WallpaperSorting sorting = WallpaperSorting.toplist,
  }) async {
    final request = Uri.https(
      _baseUrl,
      '/api/v1/search',
      query == null
          ? {'sorting': sorting.value, 'page': '$pageIndex'}
          : {'q': query, 'page': '$pageIndex'},
    );

    final response = await _httpClient.get(request);

    if (response.statusCode != 200) {
      throw WallpaperSearchRequestFailure(
        'Request failed with status: ${response.statusCode}',
      );
    }

    final wallpaperListJson = jsonDecode(response.body) as Map<String, dynamic>;

    if (!wallpaperListJson.containsKey('data')) {
      throw const WallpaperNotFoundFailure(
        'Wallpaper not found. Please check your query.',
      );
    }

    return WallpaperList.fromJson(wallpaperListJson);
  }

  /// Get [Wallpaper] info by id.
  Future<WallpaperInfo> wallpaperInfo({required String id}) async {
    final request = Uri.https(_baseUrl, '/api/v1/w/$id');

    final response = await _httpClient.get(request);

    if (response.statusCode != 200) {
      throw WallpaperIdInfoNotFoundFailure(
        'Request failed with status: ${response.statusCode}',
      );
    }

    final wallpaperInfoJson = jsonDecode(response.body) as Map<String, dynamic>;

    return WallpaperInfo.fromJson(wallpaperInfoJson);
  }
}
