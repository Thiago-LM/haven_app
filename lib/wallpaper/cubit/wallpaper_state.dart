part of 'wallpaper_cubit.dart';

class WallpaperState extends Equatable {
  const WallpaperState({this.wallpaper});

  factory WallpaperState.fromJson(Map<String, dynamic> json) => WallpaperState(
        wallpaper: json['wallpaper'] == null
            ? null
            : WallpaperInfo.fromJson(json['wallpaper'] as Map<String, dynamic>),
      );

  final WallpaperInfo? wallpaper;

  WallpaperState copyWith({WallpaperInfo? wallpaper}) =>
      WallpaperState(wallpaper: wallpaper ?? this.wallpaper);

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'wallpaper': wallpaper?.toJson()};

  @override
  List<Object?> get props => [wallpaper];
}
