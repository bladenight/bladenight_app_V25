import 'package:dart_mappable/dart_mappable.dart';
import 'package:latlong2/latlong.dart';

import 'lat_lng_mapper.dart';

part 'location.mapper.dart';

@MappableClass(includeCustomMappers: [LatLngMapper()])
class LocationInfo with LocationInfoMappable{
  @MappableField(key: 'coo')
  final LatLng coords;
  @MappableField(key: 'par')
  final bool isParticipating;
  @MappableField(key: 'did')
  final String deviceId;
  @MappableField(key: 'spf')
  final int? specialFunction;
  @MappableField(key: 'spd')
  final double? userSpeed;
  @MappableField(key: 'rsp')
  final double? realSpeed;
  @MappableField(key: 'acc')
  final double? accuracy;

  LocationInfo(
      {required this.coords,
      required this.isParticipating,
      required this.deviceId,
      this.specialFunction,
      this.userSpeed,
      this.realSpeed,
      this.accuracy});
}
