// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper_search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WallpaperSearchModel _$WallpaperSearchModelFromJson(
        Map<String, dynamic> json) =>
    WallpaperSearchModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WallpaperSearchModelToJson(
        WallpaperSearchModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };
