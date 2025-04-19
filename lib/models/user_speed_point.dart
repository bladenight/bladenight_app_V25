import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../helpers/speed_to_color.dart';
import 'images_and_links.dart';

part 'user_speed_point.mapper.dart';

@MappableClass()

/// Helper to create a polyline btw. two Points
class UserSpeedPoint with UserSpeedPointMappable {
  UserSpeedPoint(this.dateTime, this.latitude, this.longitude,
      this.realSpeedKmh, LatLng? previousLatLng) {
    if (previousLatLng != null) {
      previousLatitude = previousLatLng.latitude;
      previousLongitude = previousLatLng.longitude;
    } else {
      previousLatitude = latitude;
      previousLongitude = longitude;
    }
  }
  final DateTime dateTime;
  final double latitude;
  final double longitude;
  final double realSpeedKmh;
  late double previousLatitude;
  late double previousLongitude;

  Color get color => SpeedToColor.getColorFromSpeed(realSpeedKmh);

  LatLng get latLng => LatLng(latitude, longitude);

  LatLng get previousLatLng => LatLng(previousLatitude, previousLongitude);

  List<LatLng> get latLngList => <LatLng>[latLng, previousLatLng];

  String toXML() {
    return '\t\t<trkpt lat="$latitude" lon="$longitude">\n'
        '\t\t\t<speed>${realSpeedKmh.toStringAsFixed(1)}</speed>\n'
        '\t\t</trkpt>\n';
  }
}

@MappableClass()
class UserSpeedPoints with UserSpeedPointsMappable {
  UserSpeedPoints(this.userSpeedPoints);

  final List<UserSpeedPoint> userSpeedPoints;

  add(DateTime dateTime, double latitude, double longitude, double realSpeedKmh,
      LatLng previousLatLng) {
    userSpeedPoints.add(UserSpeedPoint(
        dateTime, latitude, longitude, realSpeedKmh, previousLatLng));
  }

  addUserSpeedPoint(UserSpeedPoint userSpeedPoint) {
    userSpeedPoints.add(userSpeedPoint);
  }

  void clear() {
    userSpeedPoints.clear();
  }

  List<LatLng> get latLngList {
    List<LatLng> list = <LatLng>[];
    for (var sp in userSpeedPoints) {
      list.add(sp.latLng);
    }
    return list;
  }

  LatLng? get lastSpeedPointLatLng {
    if (userSpeedPoints.isNotEmpty) {
      return userSpeedPoints.last.latLng;
    }
    return null;
  }

  UserSpeedPoint? get lastSpeedPoint {
    if (userSpeedPoints.isNotEmpty) {
      return userSpeedPoints.last;
    }
    return null;
  }

  List<Color> get colorList {
    List<Color> list = <Color>[];
    for (var sp in userSpeedPoints) {
      list.add(sp.color);
    }
    return list;
  }

  String toXML() {
    var str = '<?xml version="1.0" encoding="UTF-8" standalone="no" ?>'
        '<gpx xmlns="https://www.topografix.com/GPX/1/1" version="1.1" creator="BladenightAPP"'
        'xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance"'
        'xsi:schemaLocation="https://www.topografix.com/GPX/1/1 https://www.topografix.com/GPX/1/1/gpx.xsd">'
        '<trk>\n'
        '\t<name>Bladenight Aufzeichnung vom ${DateTime.now().toIso8601String()}</name>\n'
        '\t\t<trkseg>\n';
    for (var tp in userSpeedPoints) {
      str = '$str${tp.toXML()}';
    }
    str = '$str\t\t</trkseg>\n'
        '\t</trk>\n'
        '</gpx>\n';
    return str;
  }
}
