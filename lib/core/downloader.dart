import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'constants.dart';

abstract class Downloader {

  static Future<String?> downloadFile(String url, {required Function(int progress, int total) onProgress}) async {
    try {
      final downloadDir = await _getDownloadDirectory();
      String fileName = getFileNameFromURL(url, '/');
      await Dio().download(
        url,
        '${downloadDir.path}/$fileName',
        onReceiveProgress: onProgress,
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

  static Future<Directory> _getDownloadDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${appDir.path}/files');
    final isDirExist = await downloadDir.exists();
    if(!isDirExist) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir;
  }

}