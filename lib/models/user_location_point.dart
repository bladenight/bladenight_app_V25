import 'package:dart_mappable/dart_mappable.dart';

part 'user_location_point.mapper.dart';

@MappableClass()
class UserLocationPoint with UserLocationPointMappable {
  @MappableField(key: 'lat')
  final double latitude;
  @MappableField(key: 'lon')
  final double longitude;

  @MappableField(key: 'spd')
  final String speed;

  /// User location point to send to watch
  /// contains lat,lon,speed
  UserLocationPoint({
    required this.latitude,
    required this.longitude,
    required this.speed,
  });

  /// empty user location point to send to watch
  /// contains lat = 0 ,lon = 0 ,speed = ''
  static UserLocationPoint userLocationPointEmpty() {
    return UserLocationPoint(latitude: 0, longitude: 0, speed: '');
  }
}
