// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
      id: json['id'] as String?,
      url: json['url'] as String?,
      shortUrl: json['short_url'] as String?,
      views: json['views'] as int?,
      favorites: json['favorites'] as int?,
      source: json['source'] as String?,
      purity: json['purity'] as String?,
      category: json['category'] as String?,
      dimensionX: json['dimension_x'] as int?,
      dimensionY: json['dimension_y'] as int?,
      resolution: json['resolution'] as String?,
      ratio: json['ratio'] as String?,
      fileSize: json['file_size'] as int?,
      fileType: json['file_type'] as String?,
      createdAt: json['created_at'] as String?,
      colors:
          (json['colors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      path: json['path'] as String?,
      thumbs: json['thumbs'] == null
          ? null
          : Thumbs.fromJson(json['thumbs'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'short_url': instance.shortUrl,
      'views': instance.views,
      'favorites': instance.favorites,
      'source': instance.source,
      'purity': instance.purity,
      'category': instance.category,
      'dimension_x': instance.dimensionX,
      'dimension_y': instance.dimensionY,
      'resolution': instance.resolution,
      'ratio': instance.ratio,
      'file_size': instance.fileSize,
      'file_type': instance.fileType,
      'created_at': instance.createdAt,
      'colors': instance.colors,
      'path': instance.path,
      'thumbs': instance.thumbs,
    };
