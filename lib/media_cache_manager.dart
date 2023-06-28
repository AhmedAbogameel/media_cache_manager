import 'dart:developer';
import 'dart:io';

import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

part 'core/constants.dart';
part 'core/download_cache_manager.dart';
part 'core/download_media_builder_controller.dart';
part 'core/downloader.dart';
part 'core/encryptor.dart';
part 'enums/download_media_status.dart';
part 'models/download_media_snapshot.dart';
part 'widgets/download_media_builder.dart';

class MediaCacheManager {
  static MediaCacheManager instance = MediaCacheManager();

  /// Initialize dependencies
  /// encryptionPassword calls setEncryptionPassword to enable files encryption.
  /// daysToExpire set expire date of files in days.
  Future<void> init({String? encryptionPassword, int? daysToExpire}) async {
    await DownloadCacheManager.instance.init();
    if (daysToExpire != null) {
      await setExpireDate(daysToExpire: daysToExpire);
    }
    await Encryptor.instance.init();
    if (encryptionPassword != null) {
      await setEncryptionPassword(encryptionPassword);
    }
  }

  /// By default encryption is disabled until you call setEncryptionPassword.
  Future<void> setEncryptionPassword(String password) async {
    Encryptor.instance.setPassword(password);
  }

  /// Setting ExpireDate if expire date came
  /// the downloaded files will be deleted to reduce storage usage.
  Future<void> setExpireDate({required int daysToExpire}) async {
    return DownloadCacheManager.instance.setExpireDate(daysToExpire: daysToExpire);
  }
}
