import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:geolocator/geolocator.dart';

import 'uuid_helper.dart';

extension Location2Mapper on Position {
  bg.Location convertToBGLocation() {
    Map<String, dynamic> coords = {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'ellipsoidal_altitude': altitude,
      'heading': heading,
      'speed': speed,
      'speedAccuracy': speedAccuracy,
      'floor': 0
    };

    Map<String, dynamic> battery = {'is_charging': false, 'level': 1.0};
    Map<String, dynamic> activity = {
      'type': 'on_foot',
      'confidence': 1,
    };
    Map<String, dynamic> bgLocation = {
      'coords': coords,
      'battery': battery,
      'activity': activity,
      'age': 0,
      'timestamp': timestamp.toUtc().toIso8601String(),
      'is_moving': true,
      'uuid': UUID.createUuid(),
      'odometer': 0.0
    };
    return bg.Location(bgLocation);
  }
}
