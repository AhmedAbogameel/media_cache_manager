part of '../media_cache_manager.dart';

enum DownloadMediaStatus {
  /// Initial state.
  initial,
  /// File has been downloaded successfully.
  success,
  /// File is downloading.
  loading,
  /// File has been downloaded but still under encrypting.
  /// this state will be raised only if the file under encryption.
  encrypting,
  /// File has been downloaded but still under decrypting.
  /// this state will be raised only if the file under decryption.
  decrypting,
  /// Download failed.
  error,
  /// Download has been canceled by user before complete.
  canceled,
}
