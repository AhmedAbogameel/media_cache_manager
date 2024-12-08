part of '../media_cache_manager.dart';

class Encryptor {
  static Encryptor instance = Encryptor();

  bool get isEnabled => _isPasswordSet;

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
    String? encryptedFilePath;
    try {
      if (!_isPasswordSet) {
        return filePath;
      }
      encryptedFilePath = await compute(
          _encryptInIsolate, {'crypt': _crypt, 'filePath': filePath});
    } catch (e, s) {
      customLog(e.toString(), s);
    }
    return encryptedFilePath;
  }

  /// Decrypting file with AES.
  Future<String?> decrypt(String filePath) async {
    String? decryptedFilePath;
    try {
      if (!_isPasswordSet) {
        return filePath;
      }
      decryptedFilePath = await compute(
          _decryptInIsolate, {'crypt': _crypt, 'filePath': filePath});
    } catch (e, s) {
      customLog(e.toString(), s);
    }
    return decryptedFilePath;
  }
}

Future<String?> _encryptInIsolate(Map<String, dynamic> data) async {
  final encryptedFilePath =
      await (data['crypt'] as AesCrypt).encryptFile(data['filePath']);
  return encryptedFilePath;
}

Future<String?> _decryptInIsolate(Map<String, dynamic> data) async {
  final decryptedFilePath =
      await (data['crypt'] as AesCrypt).decryptFile(data['filePath']);
  return decryptedFilePath;
}
