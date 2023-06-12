part of '../media_cache_manager.dart';

class DownloadCacheManager {
  /// Singleton instance for DownloadCacheManager.
  static DownloadCacheManager instance = DownloadCacheManager();

  /// Cache box name
  final String _boxName = 'MediaCacheManager';

  /// Cache Instance
  late GetStorage _getStorage;

  /// Initializing Cache
  Future<void> init() async {
    _getStorage =  GetStorage(_boxName);
    await GetStorage.init(_boxName);
  }

  /// Caching File Path
  /// [Caching in HashMap Key is : URL, Value is : Path]
  Future<void> cacheFilePath({
    required String url,
    required String path,
  }) async {
    await _getStorage.write(url, path);
  }

  /// Getting File path based on given url
  /// [It's Big O is a Constant Time]
  String? getCachedFilePath(String url) {
    return _getStorage.read(url);
  }

  /// Setting ExpireDate if expire date came
  /// the downloaded files will be deleted to reduce storage usage.
  Future<void> setExpireDate({required int daysToExpire}) async {
    const expiryDateKey = 'expiryDate';
    final expireDuration = Duration(days: daysToExpire);
    final dateTimeNow = DateTime.now();
    if (!_getStorage.hasData(expiryDateKey)) {
      _getStorage.write(
          expiryDateKey, dateTimeNow.add(expireDuration).toString(),
      );
      return;
    }
    bool expired =
        DateTime.parse(_getStorage.read(expiryDateKey)).isBefore(dateTimeNow);
    if (expired) {
      await _getStorage.erase();
      await Downloader.clearCachedFiles();
      _getStorage.write(
          expiryDateKey, dateTimeNow.add(expireDuration).toString(),);
    }
  }
}
