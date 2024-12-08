part of '../media_cache_manager.dart';

class DownloadCacheManager {
  /// Singleton instance for DownloadCacheManager.
  static DownloadCacheManager instance = DownloadCacheManager();

  /// Cache box name
  final String _boxName = 'MediaCacheManager';

  /// Cache Instance
  late GetStorage _getStorage;

  final _expiryDateKey = 'daysToExpire';

  /// Initializing Cache
  Future<void> init() async {
    _getStorage = GetStorage(_boxName);
    await GetStorage.init(_boxName);
  }

  /// Caching File Path
  /// [Caching in HashMap Key is : URL, Value is : Path]
  Future<void> cacheFilePath({
    required String url,
    required String path,
  }) async {
    await _getStorage.write(url, {'path': path});
    _expansionFileExpiryDate(url);
  }

  /// Getting File path based on given url
  /// [It's Big O is a Constant Time]
  String? getCachedFilePath(String url) {
    final element = _getStorage.read(url);
    if (element != null) {
      _expansionFileExpiryDate(url);
      return element['path'];
    }
    return null;
  }

  /// expansion File Expiry Date based on daysToExpire value
  /// if daysToExpire null method will has no effect
  void _expansionFileExpiryDate(String url) async {
    if (_getExpireDateInDays != null) {
      final element = _getStorage.read(url);
      await _getStorage.write(
        url,
        {
          'path': element['path'],
          _expiryDateKey: DateTime.now()
              .add(Duration(days: _getExpireDateInDays!))
              .toString(),
        },
      );
    }
  }

  /// Setting ExpireDate
  Future<void> setExpireDate({required int daysToExpire}) async {
    if (_getExpireDateInDays == null) {
      _getStorage.write(
        _expiryDateKey,
        daysToExpire,
      );
      return;
    }
    await _deleteExpiredFiles();
  }

  /// get value of daysToExpire
  int? get _getExpireDateInDays {
    return _getStorage.read(_expiryDateKey);
  }

  /// Delete expired files
  Future<void> _deleteExpiredFiles() async {
    if (_getExpireDateInDays == null) {
      return;
    }
    final dateTimeNow = DateTime.now();
    final keys = List<String>.from(_getStorage.getKeys());
    for (String key in keys) {
      if (!key.startsWith('http')) {
        continue;
      }
      final element = _getStorage.read(key);
      final expiryDate = element[_expiryDateKey];
      if (expiryDate != null &&
          DateTime.parse(expiryDate).isBefore(dateTimeNow)) {
        _getStorage.remove(key);
        await File(element['path']).delete();
      }
    }
  }
}
