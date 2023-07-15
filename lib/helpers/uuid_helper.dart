import 'dart:math';

class UUID {
  /// Create unique string generator
  static String createUuid() {

    String randomString = '${_generateRandom(8)}-'
        '${_generateRandom(4)}-'
        '${_generateRandom(4)}-'
        '${_generateRandom(12)}';

    return randomString;
  }

  static String _generateRandom(int length) {
    Random random = Random();
    String id = '';
    while (id.length < length) {
      id += (random.nextInt(16)).toRadixString(16);
    }
    return id.substring(0, length);
  }
}
