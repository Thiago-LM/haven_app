import 'dart:convert';

import 'package:collection/collection.dart';

import 'thumbs.dart';

class Datum {
  String? id;
  String? url;
  String? shortUrl;
  int? views;
  int? favorites;
  String? source;
  String? purity;
  String? category;
  int? dimensionX;
  int? dimensionY;
  String? resolution;
  String? ratio;
  int? fileSize;
  String? fileType;
  String? createdAt;
  List<String>? colors;
  String? path;
  Thumbs? thumbs;

  Datum({
    this.id,
    this.url,
    this.shortUrl,
    this.views,
    this.favorites,
    this.source,
    this.purity,
    this.category,
    this.dimensionX,
    this.dimensionY,
    this.resolution,
    this.ratio,
    this.fileSize,
    this.fileType,
    this.createdAt,
    this.colors,
    this.path,
    this.thumbs,
  });

  @override
  String toString() {
    return 'Datum(id: $id, url: $url, shortUrl: $shortUrl, views: $views, favorites: $favorites, source: $source, purity: $purity, category: $category, dimensionX: $dimensionX, dimensionY: $dimensionY, resolution: $resolution, ratio: $ratio, fileSize: $fileSize, fileType: $fileType, createdAt: $createdAt, colors: $colors, path: $path, thumbs: $thumbs)';
  }

  factory Datum.fromMap(Map<String, dynamic> data) => Datum(
        id: data['id'] as String?,
        url: data['url'] as String?,
        shortUrl: data['short_url'] as String?,
        views: data['views'] as int?,
        favorites: data['favorites'] as int?,
        source: data['source'] as String?,
        purity: data['purity'] as String?,
        category: data['category'] as String?,
        dimensionX: data['dimension_x'] as int?,
        dimensionY: data['dimension_y'] as int?,
        resolution: data['resolution'] as String?,
        ratio: data['ratio'] as String?,
        fileSize: data['file_size'] as int?,
        fileType: data['file_type'] as String?,
        createdAt: data['created_at'] as String?,
        colors: (data['colors'] as List).map((item) => item as String).toList(),
        path: data['path'] as String?,
        thumbs: data['thumbs'] == null
            ? null
            : Thumbs.fromMap(data['thumbs'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'url': url,
        'short_url': shortUrl,
        'views': views,
        'favorites': favorites,
        'source': source,
        'purity': purity,
        'category': category,
        'dimension_x': dimensionX,
        'dimension_y': dimensionY,
        'resolution': resolution,
        'ratio': ratio,
        'file_size': fileSize,
        'file_type': fileType,
        'created_at': createdAt,
        'colors': colors,
        'path': path,
        'thumbs': thumbs?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Datum].
  factory Datum.fromJson(String data) {
    return Datum.fromMap(jsonDecode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Datum] to a JSON string.
  String toJson() => jsonEncode(toMap());

  Datum copyWith({
    String? id,
    String? url,
    String? shortUrl,
    int? views,
    int? favorites,
    String? source,
    String? purity,
    String? category,
    int? dimensionX,
    int? dimensionY,
    String? resolution,
    String? ratio,
    int? fileSize,
    String? fileType,
    String? createdAt,
    List<String>? colors,
    String? path,
    Thumbs? thumbs,
  }) {
    return Datum(
      id: id ?? this.id,
      url: url ?? this.url,
      shortUrl: shortUrl ?? this.shortUrl,
      views: views ?? this.views,
      favorites: favorites ?? this.favorites,
      source: source ?? this.source,
      purity: purity ?? this.purity,
      category: category ?? this.category,
      dimensionX: dimensionX ?? this.dimensionX,
      dimensionY: dimensionY ?? this.dimensionY,
      resolution: resolution ?? this.resolution,
      ratio: ratio ?? this.ratio,
      fileSize: fileSize ?? this.fileSize,
      fileType: fileType ?? this.fileType,
      createdAt: createdAt ?? this.createdAt,
      colors: colors ?? this.colors,
      path: path ?? this.path,
      thumbs: thumbs ?? this.thumbs,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Datum) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      url.hashCode ^
      shortUrl.hashCode ^
      views.hashCode ^
      favorites.hashCode ^
      source.hashCode ^
      purity.hashCode ^
      category.hashCode ^
      dimensionX.hashCode ^
      dimensionY.hashCode ^
      resolution.hashCode ^
      ratio.hashCode ^
      fileSize.hashCode ^
      fileType.hashCode ^
      createdAt.hashCode ^
      colors.hashCode ^
      path.hashCode ^
      thumbs.hashCode;
}
