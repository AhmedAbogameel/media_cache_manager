import '../media_cache_manager.dart';

class DownloadMediaBuilderController {

  DownloadMediaBuilderController({
    required this.url,
    required DownloadMediaSnapshot snapshot,
    required Function(DownloadMediaSnapshot) onSnapshotChanged,
  }) {
    _onSnapshotChanged = onSnapshotChanged;
    _snapshot = snapshot;
  }

  final String url;

  /// When snapshot changes this function will called and give you the new snapshot
  late final Function(DownloadMediaSnapshot) _onSnapshotChanged;

  /// Provide us a 3 Variable
  /// 1 - Status : It's the status of the process (Success, Loading, Error, Canceled).
  /// 2 - Progress : The progress if the file is downloading.
  /// 3 - FilePath : When Status is Success the FilePath won't be null;
  late final DownloadMediaSnapshot _snapshot;

  /// Downloader Instance
  Downloader? _downloader;

  /// Try to get file path from cache,
  /// If it's not exists it will download the file and cache it.
  Future<void> getFile() async {
    String? filePath = DownloadCacheManager.getCachedFilePath(url);
    if (filePath != null) {
      _snapshot.filePath = filePath;
      _snapshot.status = DownloadMediaStatus.success;
      _onSnapshotChanged(_snapshot);
      return;
    }
    _downloader = Downloader(url: url);
    filePath = await _downloader!.downloadFile(
      onProgress: (progress, total) {
        _snapshot.status = DownloadMediaStatus.loading;
        _onSnapshotChanged(_snapshot..progress = (progress / total));
      },
    );
    if (filePath != null) {
      _snapshot.filePath = filePath;
      _snapshot.status = DownloadMediaStatus.success;
      _onSnapshotChanged(_snapshot);

      /// Caching FilePath
      await DownloadCacheManager.cacheFilePath(url: url, path: filePath);
    } else {
      if (_snapshot.status != DownloadMediaStatus.canceled) {
        _onSnapshotChanged(_snapshot..status = DownloadMediaStatus.error);
      }
    }
  }

  /// Cancel Downloading file if download status is loading otherwise nothing will happen
  Future<void> cancelDownload() async {
    if (_snapshot.status == DownloadMediaStatus.loading) {
      await _downloader?.cancelDownload();
      _snapshot.status = DownloadMediaStatus.canceled;
      _onSnapshotChanged(_snapshot);
    }
  }

  /// Retry to get a downloaded file only if the status is canceled or end with error.
  Future<void> retry() async {
    if (_snapshot.status == DownloadMediaStatus.canceled || _snapshot.status == DownloadMediaStatus.error) {
      _snapshot.status = DownloadMediaStatus.loading;
      _snapshot.progress = null;
      _onSnapshotChanged(_snapshot);
      _downloader = Downloader(url: url);
      getFile();
    }
  }
}
