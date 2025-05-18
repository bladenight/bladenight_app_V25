import 'package:dart_mappable/dart_mappable.dart';

part 'moving_point.mapper.dart';

@MappableClass()
class MovingPoint with MovingPointMappable {
  @MappableField(key: 'pos')
  final int position;

  //real speed in km/h
  @MappableField(key: 'rsp')
  final double? realSpeed;

  //calculated linear speed in m/s
  @MappableField(key: 'spd')
  final int speed;
  @MappableField(key: 'eta')
  final int?
      eta; //milliseconds from me to head /// milliseconds from me to tail /// up: user estimated time of arrival

  @MappableField(key: 'ior')
  final bool isOnRoute;
  @MappableField(key: 'iip')
  final bool isInProcession;

  @MappableField(key: 'lat')
  final double? latitude;
  @MappableField(key: 'lon')
  final double? longitude;

  @MappableField(key: 'acc')
  final int? accuracy;

  MovingPoint({
    required this.position,
    required this.speed,
    this.realSpeed,
    this.eta,
    this.isOnRoute = true,
    this.isInProcession = true,
    this.latitude,
    this.longitude,
    this.accuracy,
  });

  static MovingPoint movingPointEmpty() {
    return MovingPoint(position: 0, speed: 0);
  }
}
