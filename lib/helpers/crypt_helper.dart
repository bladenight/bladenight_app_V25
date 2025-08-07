import 'dart:convert';

import 'package:encrypt/encrypt.dart';

class CryptHelper {
  static String? encryptAES(String plainText, String password) {
    final key = Key.fromUtf8(password..padRight(32, '\x00'));
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    Encrypted encrypted = encrypter.encrypt(plainText, iv: iv);
    var crypt =
        utf8.encoder.convert('sha-256-cbc:${encrypted.base64}:${iv.base64}');
    return base64Encode(crypt);
  }

  ///Code as base 64 sha-256-cbc:base64encrypted:base64salt
  static String? decryptAES(String plainBase64Text, String password) {
    try {
      var code = utf8.decode(base64Decode(plainBase64Text));
      var parts = code.split(':');
      if (parts.length != 3 || parts[0].toLowerCase() != 'sha-256-cbc') {
        return null;
      }
      final key = Key.fromUtf8(password.padRight(32, '\x00'));
      final ivs = base64Decode(parts[2]);
      final iv = IV(ivs);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      return encrypter.decrypt(Encrypted.fromBase64(parts[1]), iv: iv);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
