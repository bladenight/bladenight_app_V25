import 'package:flutter/cupertino.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:location2/location2.dart';

extension Location2Mapper on LocationData {
  bg.Location convertToBGLocation( ) {
    Map<String, dynamic> coords = {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy ?? 0.0,
      'altitude': altitude ?? 0.0,
      'ellipsoidal_altitude': altitude ?? 0.0,
      'heading': bearing ?? 0.0,
      'speed': speed ?? 0.0,
      'speedAccuracy': speedAccuracy ?? 0.0,
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
      'timestamp':
          DateTime.fromMillisecondsSinceEpoch(time!.toInt())
              .toUtc()
              .toIso8601String(),
      'is_moving': true,
      'uuid': UniqueKey().toString(),
      'odometer': 0.0
    };
    return bg.Location(bgLocation);
  }
}
