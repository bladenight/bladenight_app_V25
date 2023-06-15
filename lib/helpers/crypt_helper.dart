import 'package:encrypt/encrypt.dart';

class EncryptData {
  static String? encryptAES(String plainText, String password) {
    final key = Key.fromUtf8(password);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    Encrypted encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static String? decryptAES(String plainBase64Text, String password) {
    final key = Key.fromUtf8(password);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    return encrypter.decrypt(Encrypted.fromBase64(plainBase64Text), iv: iv);
  }
}
