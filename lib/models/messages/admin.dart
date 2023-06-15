import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'admin.mapper.dart';

@MappableClass()
class AdminMessage with AdminMessageMappable {
  @MappableField(key: 'tim')
  late final int timestamp;
  @MappableField(key: 'chk')
  late final String checksum;
  @MappableField(key: 'noi')
  late final int noise;
  @MappableField(key: 'did')
  late final String deviceId;

  AdminMessage({
    required this.timestamp,
    required this.checksum,
    required this.noise,
    required this.deviceId
  });

  AdminMessage.authenticate({required String password,required this.deviceId}) {
    timestamp = DateTime.now().millisecondsSinceEpoch;
    noise = generateNoise();
    checksum = generateChecksum(password, noise, timestamp);
  }
}

int generateNoise() {
  return Random().nextInt(1 << 32);
}

String generateChecksum(String password, int noise, int timestamp) {
  String msg = '$password$timestamp$noise';

  var checksum = sha1.convert(utf8.encode(msg)).toString();
  return checksum;
}
