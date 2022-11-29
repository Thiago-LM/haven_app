import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:haven_app/shared/shared.dart';
import 'package:haven_app/wallhaven/wallhaven.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'wallpaper_state.dart';

class WallpaperCubit extends HydratedCubit<WallpaperState> {
  WallpaperCubit(this._wallhavenRepository) : super(const WallpaperState());

  final WallhavenRepository _wallhavenRepository;

  Future<void> downloadImage({required String url}) async {
    final dir = Directory('storage/emulated/0/Pictures/wallhaven/');
    if (!dir.existsSync()) {
      log('$dir doesnt exist');
      dir.createSync(recursive: true);
    }
    log('$dir exist');

    final file = File(dir.path + url.substring(url.lastIndexOf('/') + 1));
    log('file = ${file.path}');
    final fileBodyBytes = await http.readBytes(Uri.parse(url));
    file.writeAsBytesSync(fileBodyBytes);
  }

  Future<void> getWallpaperInfo({required String id}) async {
    try {
      final wallpaper = await _wallhavenRepository.getWallpaperInfo(id: id);
      emit(state.copyWith(wallpaper: wallpaper));
    } on Exception catch (e) {
      log('e = $e', name: 'WallpaperCubit');
    }
  }

  @override
  WallpaperState fromJson(Map<String, dynamic> json) =>
      WallpaperState.fromJson(json);

  @override
  Map<String, dynamic> toJson(WallpaperState state) => state.toJson();
}
