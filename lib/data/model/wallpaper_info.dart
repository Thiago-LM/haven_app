import 'package:equatable/equatable.dart';

import 'package:haven_app/data/model/wallpaper.dart';

class WallpaperInfo extends Equatable {
  const WallpaperInfo({required this.data});

  factory WallpaperInfo.fromJson(Map<String, dynamic> json) => WallpaperInfo(
      data: Wallpaper.fromJson(json['data'] as Map<String, dynamic>));

  final Wallpaper data;

  static const empty = WallpaperInfo(data: Wallpaper.empty);

  Map<String, dynamic> toJson() => {'data': data.toJson()};

  @override
  List<Object?> get props => [data];

  @override
  String toString() => 'WallpaperInfo(data: $data)';
}
