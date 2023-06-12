part of '../media_cache_manager.dart';

class Encryptor {

  static Encryptor instance = Encryptor();

  bool _isPasswordSet = false;

  Future<void> init() async {
    _crypt.setOverwriteMode(AesCryptOwMode.on);
    _crypt.setUserData(createdBy: "media_cache_manager");
    _crypt.aesSetMode(AesMode.ofb);
  }

  final _crypt = AesCrypt();

  /// Set Encryption Password.
  void setPassword(String password) {
    _crypt.setPassword(password);
    _isPasswordSet = true;
  }

  /// Encrypting file with AES.
  Future<String?> encrypt(String filePath) async {
    try {
      if (!_isPasswordSet) {
        return filePath;
      }
      final encryptedFilePath = await _crypt.encryptFile(filePath);
      await File(filePath).delete();
      return encryptedFilePath;
    } catch (e, s) {
      customLog(e.toString(), s);
    }
    return null;
  }

  /// Decrypting file with AES.
  Future<String?> decrypt(String filePath) async {
    try {
      if (!_isPasswordSet) {
        return filePath;
      }
      final decryptedFilePath = await _crypt.decryptFile(filePath);
      customLog((await File(decryptedFilePath).readAsBytes()).toString());
      // await File(decryptedFilePath).delete();
      return decryptedFilePath;
    } catch (e, s) {
      customLog(e.toString(), s);
    }
    return null;
  }
}
