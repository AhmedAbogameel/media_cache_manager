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
    try {
      if (!_isPasswordSet) {
        return filePath;
      }
      final encryptedFilePath = await compute(_encryptInIsolate, {'crypt': _crypt, 'filePath': filePath});
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
      final decryptedFilePath = await compute(_decryptInIsolate, {'crypt': _crypt, 'filePath': filePath});
      return decryptedFilePath;
    } catch (e, s) {
      customLog(e.toString(), s);
    }
    return null;
  }
}

Future<String?> _encryptInIsolate(Map<String, dynamic> data) async {
  final encryptedFilePath = await (data['crypt'] as AesCrypt).encryptFile(data['filePath']);
  return encryptedFilePath;
}

Future<String?> _decryptInIsolate(Map<String, dynamic> data) async {
  final decryptedFilePath = await (data['crypt'] as AesCrypt) .decryptFile(data['filePath']);
  return decryptedFilePath;
}
