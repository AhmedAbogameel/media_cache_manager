import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'constants.dart';

class Downloader {

  Downloader({required this.url});

  final String url;
  final CancelToken _cancelToken = CancelToken();
  final Dio _dio = Dio();

  Future<String?> download({
    required Function(int progress, int total) onProgress,
    void Function()? cancelDownload,
  }) async {
    try {
      final downloadDir = await _getDownloadDirectory();
      String fileName = getFileNameFromURL(url, '/');
      await _dio.download(
        url,
        '${downloadDir.path}/$fileName',
        onReceiveProgress: onProgress,
        cancelToken: _cancelToken,
      );
      final filePath = '${downloadDir.path}/$fileName';
      return filePath;
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
      return null;
    }
  }

  Future<void> cancel() async {
    try {
      if (!_cancelToken.isCancelled) {
        _cancelToken.cancel();
      }
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
    }
  }

  static Future<Directory> _getDownloadDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${appDir.path}/files');
    final isDirExist = await downloadDir.exists();
    if (!isDirExist) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir;
  }

  static Future<void> clearCachedFiles() async {
    final dir = await _getDownloadDirectory();
    await dir.delete(recursive: true);
  }
}
