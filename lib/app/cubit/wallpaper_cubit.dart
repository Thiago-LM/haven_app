import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:haven_app/app/models/models.dart';
import 'package:haven_app/shared/shared.dart';
import 'package:haven_app/wallhaven/wallhaven.dart';

part 'wallpaper_state.dart';

class WallpaperCubit extends HydratedCubit<WallpaperState> {
  WallpaperCubit(this._wallhavenRepository) : super(const WallpaperState());

  final WallhavenRepository _wallhavenRepository;

  Future<void> fetchWallpaper({WallpaperQuery? wallQuery}) async {
    if (state.homeStatus != HomeStatus.success) {
      emit(state.copyWith(homeStatus: HomeStatus.loading));

      try {
        final wallpaperList =
            await _wallhavenRepository.getWallpaper(wallQuery: wallQuery);

        emit(
          state.copyWith(
            homeStatus: HomeStatus.success,
            wallpaperList: wallpaperList,
            colorsData: getColorsData(wallpaperList.data),
            wallQuery: wallQuery,
          ),
        );
      } catch (e) {
        log('e = $e', name: 'WallpaperCubit');
        emit(state.copyWith(homeStatus: HomeStatus.failure));
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

  Future<void> validateApikey({required String apikey}) async {
    emit(state.copyWith(userStatus: UserStatus.loading));

    try {
      await _wallhavenRepository.apikeyValidation(apikey: apikey);

      emit(state.copyWith(userStatus: UserStatus.success));
    } catch (e) {
      log('e = $e', name: 'WallpaperCubit');
      emit(state.copyWith(userStatus: UserStatus.failure));
    }
  }

  void updateStatus(HomeStatus status) =>
      emit(state.copyWith(homeStatus: status));

  void updateWallpaperQuery(WallpaperQuery wallQuery) =>
      emit(state.copyWith(wallQuery: wallQuery));

  void updateHomeSearchTitleModel(HomeSearchTitleModel titleModel) =>
      emit(state.copyWith(homeSearchTitleModel: titleModel));

  @override
  WallpaperState fromJson(Map<String, dynamic> json) =>
      WallpaperState.fromJson(json);

  @override
  Map<String, dynamic> toJson(WallpaperState state) => state.toJson();
}
