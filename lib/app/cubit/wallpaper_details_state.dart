part of 'wallpaper_details_cubit.dart';

class WallpaperDetailsState extends Equatable {
  const WallpaperDetailsState({this.wallpaper});

  factory WallpaperDetailsState.fromJson(Map<String, dynamic> json) =>
      WallpaperDetailsState(
        wallpaper: json['wallpaper'] == null
            ? null
            : WallpaperInfo.fromJson(json['wallpaper'] as Map<String, dynamic>),
      );

  final WallpaperInfo? wallpaper;

  WallpaperDetailsState copyWith({WallpaperInfo? wallpaper}) =>
      WallpaperDetailsState(wallpaper: wallpaper ?? this.wallpaper);

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'wallpaper': wallpaper?.toJson()};

  @override
  List<Object?> get props => [wallpaper];
}
