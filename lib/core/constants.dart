part of '../media_cache_manager.dart';

void customLog(String message, [stacktrace]) {
  log(
    message,
    name: 'media_cache_manager',
    stackTrace: kDebugMode ? stacktrace : null,
  );
}

String getFileNameFromURL(String url, {int maxLength = 100}) {
  Uri uri = Uri.parse(url);
  String fileName =
      uri.pathSegments.isNotEmpty ? uri.pathSegments.last : "file";

  final dotIndex = fileName.lastIndexOf('.');
  String ext = dotIndex != -1 ? fileName.substring(dotIndex) : '';
  String nameWithoutExt =
      dotIndex != -1 ? fileName.substring(0, dotIndex) : fileName;

  if (fileName.length <= maxLength) return fileName;

  String hash = nameWithoutExt.hashCode.abs().toRadixString(36);

  String prefix = nameWithoutExt.substring(0, 20);

  return '${prefix}_$hash$ext';
}
