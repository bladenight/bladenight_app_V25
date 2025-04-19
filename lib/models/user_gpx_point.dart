import 'user_speed_point.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/speed_to_color.dart';
import 'images_and_links.dart';

part 'user_gpx_point.mapper.dart';

@MappableClass()
class UserGpxPoint with UserGpxPointMappable {
  UserGpxPoint(this.latitude, this.longitude, this.realSpeedKmh, this.heading,
      this.altitude, this.odometer, this.dateTime);

  final double latitude;
  final double longitude;
  final double realSpeedKmh;
  final double heading;
  final double altitude;
  final double odometer;
  final DateTime dateTime;

  Color get color => SpeedToColor.getColorFromSpeed(realSpeedKmh);

  LatLng get latLng => LatLng(latitude, longitude);

  String toXML() {
    final f = DateFormat('yyyy-MM-ddTHH:mm:ss');
    return '\t\t<trkpt lat="$latitude" lon="$longitude">\n'
        '\t\t\t<ele>${altitude.toStringAsFixed(2)}</ele>\n'
        '\t\t\t<speed>${realSpeedKmh.toStringAsFixed(1)}</speed>\n'
        '\t\t\t<heading>${heading == -1.0 ? 0.0 : heading.toStringAsFixed(2)}</heading>\n'
        '\t\t\t<odometer>${odometer.toStringAsFixed(2)}</odometer>\n'
        '\t\t\t<time>${f.format(dateTime.toUtc())}Z</time>\n'
        '\t\t</trkpt>\n';
  }
}

@MappableClass()
class UserGPXPoints with UserGPXPointsMappable {
  UserGPXPoints(this.userGPXPointList);

  final List<UserGpxPoint> userGPXPointList;

  List<LatLng> get latLngList {
    var latLngList = <LatLng>[];
    for (var tp in userGPXPointList) {
      latLngList.add(tp.latLng);
    }
    return latLngList;
  }

  UserSpeedPoints get userSpeedPoints {
    var userSpeedPoints = UserSpeedPoints([]);
    LatLng? lastLatLng;
    for (var tp in userGPXPointList) {
      if (lastLatLng == null) {
        //first point
        UserSpeedPoint userSpeedPoint = UserSpeedPoint(
          tp.dateTime,
          tp.latitude,
          tp.longitude,
          tp.realSpeedKmh,
          LatLng(tp.latitude, tp.longitude),
        );
        lastLatLng = LatLng(tp.latitude, tp.longitude);
        userSpeedPoints.addUserSpeedPoint(userSpeedPoint);
      } else {
        UserSpeedPoint userSpeedPoint = UserSpeedPoint(tp.dateTime, tp.latitude,
            tp.longitude, tp.realSpeedKmh, lastLatLng);
        userSpeedPoints.addUserSpeedPoint(userSpeedPoint);
        lastLatLng = LatLng(tp.latitude, tp.longitude);
      }
    }
    return userSpeedPoints;
  }

  //String toJson() => jsonEncode(utps);
  String toXML() {
    var str = r'<?xml version="1.0" encoding="utf-8" standalone="yes"?>'
        '<gpx version="1.1" '
        'creator="BladenightApp https://www.bladenight.app/" '
        'xmlns="http://www.topografix.com/GPX/1/1" '
        'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
        'xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">'
        '<name>Bladenight Aufzeichnung vom ${DateTime.now().toIso8601String()}</name>\n'
        '\t<trk>\n'
        '\t\t<trkseg>\n';
    for (var tp in userGPXPointList) {
      str = '$str${tp.toXML()}';
    }
    str = '$str\t\t</trkseg>\n'
        '\t</trk>\n'
        '</gpx>\n';
    return str;
  }
}

// both algorithms combined for awesome performance
extension UserGpxPointExtenison on List<UserGpxPoint> {
  List<LatLng> get toLatLngList {
    List<LatLng> latLngList = [];
    for (var point in this) {
      latLngList.add(point.latLng);
    }
    return latLngList;
  }
}
