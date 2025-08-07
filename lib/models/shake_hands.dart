import 'dart:core';

import 'package:dart_mappable/dart_mappable.dart';

part 'shake_hands.mapper.dart';

@MappableClass()
class ShakeHand with ShakeHandMappable implements Comparable {
  @MappableField(key: 'bui')
  final int build;
  @MappableField(key: 'did')
  final String deviceId;
  @MappableField(key: 'man')
  final String manufacturer;
  @MappableField(key: 'mod')
  final String model;
  @MappableField(key: 'rel')
  final String osversion;

  ShakeHand(
      {required this.build,
      required this.deviceId,
      this.manufacturer = 'unknown',
      this.model = 'unknown',
      this.osversion = 'unknown'});

  @override
  String toString() {
    return ', $deviceId,$model:$manufacturer,$osversion';
  }

  @override
  int compareTo(other) {
    return other.hashCode - hashCode;
  }
}
