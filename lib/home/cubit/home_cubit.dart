import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:haven_app/shared/shared.dart';
import 'package:haven_app/wallhaven/wallhaven.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'home_state.dart';

class HomeCubit extends HydratedCubit<HomeState> {
  HomeCubit(this._wallhavenRepository) : super(const HomeState());

  final WallhavenRepository _wallhavenRepository;

  Future<void> fetchWallpaper() async {
    if (state.status != HomeStatus.success) {
      emit(state.copyWith(status: HomeStatus.loading));

      try {
        final wallpaperList = await _wallhavenRepository.getWallpaper();

        emit(
          state.copyWith(
            status: HomeStatus.success,
            wallpaperList: wallpaperList,
          ),
        );
      } catch (e) {
        log('e = $e', name: 'HomeCubit');
        emit(state.copyWith(status: HomeStatus.failure));
      }
    }
  }

  void updateStatus(HomeStatus status) => emit(state.copyWith(status: status));

  @override
  HomeState fromJson(Map<String, dynamic> json) => HomeState.fromJson(json);

  @override
  Map<String, dynamic> toJson(HomeState state) => state.toJson();
}
