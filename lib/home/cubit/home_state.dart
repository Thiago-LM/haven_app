part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failure }

extension HomeStatusX on HomeStatus {
  bool get isInitial => this == HomeStatus.initial;
  bool get isLoading => this == HomeStatus.loading;
  bool get isSuccess => this == HomeStatus.success;
  bool get isFailure => this == HomeStatus.failure;
}

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.wallpaperList = WallpaperList.empty,
    this.colorsData = const {},
  });

  factory HomeState.fromJson(Map<String, dynamic> json) => HomeState(
        status: json['status'] == null
            ? HomeStatus.initial
            : HomeStatus.values[json['status'] as int],
        wallpaperList: json['wallpaperList'] == null
            ? WallpaperList.empty
            : WallpaperList.fromJson(
                json['wallpaperList'] as Map<String, dynamic>,
              ),
        colorsData: json['colorsData'] == null
            ? {}
            : Map<String, int>.from(json['colorsData'] as Map<String, dynamic>),
      );

  final HomeStatus status;
  final WallpaperList wallpaperList;
  final Map<String, int> colorsData;

  HomeState copyWith({
    HomeStatus? status,
    WallpaperList? wallpaperList,
    Map<String, int>? colorsData,
  }) {
    return HomeState(
      status: status ?? this.status,
      wallpaperList: wallpaperList ?? this.wallpaperList,
      colorsData: colorsData ?? this.colorsData,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status.index,
        'wallpaperList': wallpaperList.toJson(),
        'colorsData': colorsData,
      };

  @override
  List<Object?> get props => [status, wallpaperList, colorsData];
}
