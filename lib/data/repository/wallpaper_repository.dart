import 'package:haven_app/data/model/wallpaper_info.dart';
import 'package:haven_app/data/provider/wallhaven_api_client.dart';

class WallpaperRepository {
  final WallhavenApiClient api;

  WallpaperRepository(this.api);

  Future<WallpaperInfo> getWallpaperInfo({required String id}) async {
    final wallpaper = await api.wallpaperInfo(id: id);
    return wallpaper;
  }
}
