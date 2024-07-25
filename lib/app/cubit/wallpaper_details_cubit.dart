import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import 'package:haven_app/shared/shared.dart';
import 'package:haven_app/wallhaven/wallhaven.dart';

part 'wallpaper_details_state.dart';

class WallpaperDetailsCubit extends HydratedCubit<WallpaperDetailsState> {
  WallpaperDetailsCubit(this._wallhavenRepository)
      : super(const WallpaperDetailsState());

  final WallhavenRepository _wallhavenRepository;

  Stream<String> downloadImageStream({required String url}) {
    if (Platform.isIOS) {
      return Stream.error('Please use the Share button!');
    } else if (!Platform.isAndroid &&
        !Platform.isMacOS &&
        !Platform.isWindows &&
        !Platform.isLinux) {
      return Stream.error('Operating system not supported!');
    }

    try {
      late final StreamController<String> controller;

      controller = StreamController<String>(
        onListen: () async {
          late Directory dir;
          controller.add('Getting pictures folder...');

          if (Platform.isAndroid) {
            await verifyPermission();
          }

          switch (Platform.operatingSystem) {
            case 'android':
              dir = Directory('storage/emulated/0/Pictures/wallhaven/');
            case 'macos':
              final docDir = await getApplicationDocumentsDirectory();
              final listDirString = docDir.path.split('/');
              dir = Directory('/Users/${listDirString[2]}/Pictures/wallhaven/');
            case 'windows':
              final docDir = await getApplicationDocumentsDirectory();
              final listDirString = docDir.path.split(r'\');
              dir =
                  Directory('C:/Users/${listDirString[2]}/Pictures/wallhaven/');
            case 'linux':
              final docDir = await getApplicationDocumentsDirectory();
              dir = Directory(
                docDir.path.replaceRange(
                  docDir.path.lastIndexOf('/'),
                  null,
                  '/Pictures/wallhaven/',
                ),
              );
          }

          if (!dir.existsSync()) {
            controller.add('Creating wallhaven folder...');
            dir.createSync(recursive: true);
          }

          final file = File(dir.path + url.substring(url.lastIndexOf('/') + 1));
          controller.add('Downloading image...');

          final fileBodyBytes = await http.readBytes(Uri.parse(url));
          file.writeAsBytesSync(fileBodyBytes);

          controller.add('Image downloaded at Pictures/wallhaven/');
          await controller.close();
        },
      );

      return controller.stream;
    } catch (e) {
      return Stream.error('Error on download image!');
    }
  }

  Future<void> verifyPermission() async {
    final deviceInfo = DeviceInfoPlugin();

    switch (Platform.operatingSystem) {
      case 'android':
        final androidInfo = await deviceInfo.androidInfo;
        if (androidInfo.version.sdkInt < 33) {
          await Permission.storage.request();
        } else {
          await Permission.photos.request();
        }
    }
  }

  Future<void> shareWallpaper({
    required String url,
    required bool isFile,
  }) async {
    try {
      if (isFile && !Platform.isLinux) {
        final dir = await getTemporaryDirectory();

        final file =
            File('${dir.path}/${url.substring(url.lastIndexOf('/') + 1)}');
        final fileBodyBytes = await http.readBytes(Uri.parse(url));
        file.writeAsBytesSync(fileBodyBytes);

        await Share.shareXFiles([XFile(file.path)]);
      } else {
        if (Platform.isAndroid || Platform.isIOS) {
          await Share.shareUri(Uri.parse(url));
        } else {
          await Share.share(url);
        }
      }
    } on Exception catch (e) {
      log('e = $e', name: 'WallpaperDetailsCubit');
    }
  }

  Future<void> getWallpaperInfo({required String id}) async {
    try {
      final wallpaper = await _wallhavenRepository.getWallpaperInfo(id: id);
      emit(state.copyWith(wallpaper: wallpaper));
    } on Exception catch (e) {
      log('e = $e', name: 'WallpaperDetailsCubit');
    }
  }

  @override
  WallpaperDetailsState fromJson(Map<String, dynamic> json) =>
      WallpaperDetailsState.fromJson(json);

  @override
  Map<String, dynamic> toJson(WallpaperDetailsState state) => state.toJson();
}
