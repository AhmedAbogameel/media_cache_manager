part of '../media_cache_manager.dart';

enum DownloadMediaStatus {
  /// File has been downloaded successfully.
  success,
  /// File is downloading.
  loading,
  /// Download failed.
  error,
  /// Download has been canceled by user before complete.
  canceled,
}
