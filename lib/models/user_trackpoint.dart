import 'dart:convert';

import 'package:latlong2/latlong.dart';

class UserTrackPoint {
  UserTrackPoint(this.latitude, this.longitude, this.realSpeedKmh, this.heading,
      this.altitude, this.odometer, this.timeStamp);

  final double latitude;
  final double longitude;
  final double realSpeedKmh;
  final double heading;
  final double altitude;
  final double odometer;
  final DateTime timeStamp;

  Map toJson() => {
        'trkpt': LatLng(latitude, longitude).toJson(),
        //'lat': latitude,
        //'lon': longitude,
        'speed': realSpeedKmh.toStringAsFixed(2),
        'heading': heading,
        'ele': altitude.toStringAsFixed(2),
        'odometer': odometer.toStringAsFixed(2),
        'time': timeStamp.toIso8601String()
      };

  String toXML() {
    return '';
  }
}

class UserTrackPoints {
  UserTrackPoints(this.utps);

  final List<UserTrackPoint> utps;

  String toJson() => jsonEncode(utps);
}
