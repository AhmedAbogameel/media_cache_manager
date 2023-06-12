part of '../media_cache_manager.dart';

String getFileNameFromURL(String url, String symbol) => url.substring(url.lastIndexOf(symbol) + 1);

void customLog(String message, [stacktrace]) {
  log(
    message,
    name: 'media_cache_manager',
    stackTrace: kDebugMode ? stacktrace : null,
  );
}
