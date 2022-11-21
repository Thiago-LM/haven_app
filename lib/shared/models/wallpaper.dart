import 'package:equatable/equatable.dart';
import 'package:haven_app/shared/models/thumbs.dart';

class Wallpaper extends Equatable {
  const Wallpaper({
    required this.id,
    required this.url,
    required this.shortUrl,
    required this.views,
    required this.favorites,
    required this.source,
    required this.purity,
    required this.category,
    required this.dimensionX,
    required this.dimensionY,
    required this.resolution,
    required this.ratio,
    required this.fileSize,
    required this.fileType,
    required this.createdAt,
    required this.colors,
    required this.path,
    required this.thumbs,
  });

  factory Wallpaper.fromJson(Map<String, dynamic> json) => Wallpaper(
        id: json['id'] == null ? '' : json['id'] as String,
        url: json['url'] == null ? '' : json['url'] as String,
        shortUrl: json['short_url'] == null ? '' : json['short_url'] as String,
        views: json['views'] == null ? 0 : json['views'] as int,
        favorites: json['favorites'] == null ? 0 : json['favorites'] as int,
        source: json['source'] == null ? '' : json['source'] as String,
        purity: json['purity'] == null ? '' : json['purity'] as String,
        category: json['category'] == null ? '' : json['category'] as String,
        dimensionX:
            json['dimension_x'] == null ? 0 : json['dimension_x'] as int,
        dimensionY:
            json['dimension_y'] == null ? 0 : json['dimension_y'] as int,
        resolution:
            json['resolution'] == null ? '' : json['resolution'] as String,
        ratio: json['ratio'] == null ? '' : json['ratio'] as String,
        fileSize: json['file_size'] == null ? 0 : json['file_size'] as int,
        fileType: json['file_type'] == null ? '' : json['file_type'] as String,
        createdAt:
            json['created_at'] == null ? '' : json['created_at'] as String,
        colors: json['colors'] == null
            ? []
            : (json['colors'] as List<dynamic>)
                .map((dynamic e) => e as String)
                .toList(),
        path: json['path'] == null ? '' : json['path'] as String,
        thumbs: json['thumbs'] == null
            ? Thumbs.empty
            : Thumbs.fromJson(json['thumbs'] as Map<String, dynamic>),
      );

  final String id;
  final String url;
  final String shortUrl;
  final int views;
  final int favorites;
  final String source;
  final String purity;
  final String category;
  final int dimensionX;
  final int dimensionY;
  final String resolution;
  final String ratio;
  final int fileSize;
  final String fileType;
  final String createdAt;
  final List<String> colors;
  final String path;
  final Thumbs thumbs;

  Map<String, dynamic> toJson() => {
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
        'thumbs': thumbs.toJson(),
      };

  @override
  List<Object?> get props {
    return [
      id,
      url,
      shortUrl,
      views,
      favorites,
      source,
      purity,
      category,
      dimensionX,
      dimensionY,
      resolution,
      ratio,
      fileSize,
      fileType,
      createdAt,
      colors,
      path,
      thumbs,
    ];
  }
}
