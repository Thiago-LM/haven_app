import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:haven_app/shared/shared.dart';
import 'package:haven_app/wallhaven/wallhaven.dart';

part 'home_state.dart';

class HomeCubit extends HydratedCubit<HomeState> {
  HomeCubit(this._wallhavenRepository) : super(const HomeState());

  final WallhavenRepository _wallhavenRepository;

  Future<void> fetchWallpaper({
    String? query,
    int? pageIndex,
    WallpaperSorting? sorting,
  }) async {
    if (state.status != HomeStatus.success) {
      emit(state.copyWith(status: HomeStatus.loading));

      try {
        final wallpaperList = await _wallhavenRepository.getWallpaper(
          query: query,
          pageIndex: pageIndex ?? 1,
          sorting: sorting ?? WallpaperSorting.toplist,
        );

        emit(
          state.copyWith(
            status: HomeStatus.success,
            wallpaperList: wallpaperList,
            colorsData: getColorsData(wallpaperList.data),
          ),
        );
      } catch (e) {
        log('e = $e', name: 'HomeCubit');
        emit(state.copyWith(status: HomeStatus.failure));
      }
    }
  }

  Map<String, int> getColorsData(List<Wallpaper> data) {
    final colorsMap = <String, int>{};

    for (final wallpaper in data) {
      for (final color in wallpaper.colors) {
        colorsMap[color] = (colorsMap[color] ?? 0) + 1;
      }
    }

    return colorsMap;
  }

  void updateStatus(HomeStatus status) => emit(state.copyWith(status: status));

  @override
  HomeState fromJson(Map<String, dynamic> json) => HomeState.fromJson(json);

  @override
  Map<String, dynamic> toJson(HomeState state) => state.toJson();
}
