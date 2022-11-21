import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'datum.dart';
import 'meta.dart';

part 'wallpaper_search_model.g.dart';

@JsonSerializable()
class WallpaperSearchModel extends Equatable {
  final List<Datum>? data;
  final Meta? meta;

  const WallpaperSearchModel({this.data, this.meta});

  factory WallpaperSearchModel.fromJson(Map<String, dynamic> json) {
    return _$WallpaperSearchModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$WallpaperSearchModelToJson(this);

  @override
  List<Object?> get props => [data, meta];
}
