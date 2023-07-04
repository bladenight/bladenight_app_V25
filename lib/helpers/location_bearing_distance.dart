import 'dart:math';

import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:vector_math/vector_math.dart';

import '../models/route.dart';

class GeoLocationHelper {
  static List<HeadingPoint> calculateHeadings(List<LatLng> routePoints) {
    List<HeadingPoint> headingPoints = <HeadingPoint>[];
    int count = routePoints.length;
    for (var i = 0; i < count - 2; i++) {
      var point1 = mp.LatLng(routePoints[i].latitude, routePoints[i].longitude);
      var point2 =
          mp.LatLng(routePoints[i + 1].latitude, routePoints[i + 1].longitude);
      var heading = mp.SphericalUtil.computeAngleBetween(point1, point2);
      var distP1P2 = mp.SphericalUtil.computeDistanceBetween(point1, point2);
      var bearing = bearingBetween(
          point1.latitude, point1.longitude, point2.latitude, point2.longitude);
      var midPoint = getMidPointBetweentwoPoints(
          point1.latitude, point1.longitude, point2.latitude, point2.longitude);
      headingPoints.add(HeadingPoint(
          LatLng(midPoint.latitude, midPoint.longitude),
          heading.toDouble(),
          radians(bearing),
          distP1P2.toDouble()));
    }
    //max 20
    if (headingPoints.length > 20) {
      var sublist = <HeadingPoint>[];
      int i = (headingPoints.length / 20).round();
      var subcount = 0;
      for (var hp in headingPoints) {
        if (subcount == 0) sublist.add(hp);
        subcount++;
        if (subcount >= i) {
          subcount = 0;
        }
      }
      return sublist;
    }
    return headingPoints;
  }

  static double calculateDistance(List<LatLng> routePoints) {
    if (routePoints.isEmpty) return 0.0;
    double sumDistance = 0;

    for (var i = 0; i < routePoints.length; i++) {
      var point1 = mp.LatLng(routePoints[i].latitude, routePoints[i].longitude);
      var point2 =
          mp.LatLng(routePoints[i + 1].latitude, routePoints[i + 1].longitude);
      sumDistance += mp.SphericalUtil.computeDistanceBetween(point1, point2);
    }
    return sumDistance;
  }

  static LatLng getMidPointBetweentwoPoints(
      double x1, double x2, double y1, double y2) {
    var lat1 = radians(x1);
    var lon1 = radians(x2);
    var lat2 = radians(y1);
    var lon2 = radians(y2);

    var bx = cos(lat2) * cos(lon2 - lon1);
    var by = cos(lat2) * sin(lon2 - lon1);
    var lat3 = atan2(sin(lat1) + sin(lat2),
        sqrt((cos(lat1) + bx) * (cos(lat1) + bx) + pow(by, 2)));
    var lon3 = lon1 + atan2(by, cos(lat1) + bx);

    return LatLng(degrees(lat3), degrees(lon3));
  }

  static double bearingBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    var startLongitudeRadians = radians(startLongitude);
    var startLatitudeRadians = radians(startLatitude);
    var endLongitudeRadians = radians(endLongitude);
    var endLatitudeRadians = radians(endLatitude);

    var y = sin(endLongitudeRadians - startLongitudeRadians) *
        cos(endLatitudeRadians);
    var x = cos(startLatitudeRadians) * sin(endLatitudeRadians) -
        sin(startLatitudeRadians) *
            cos(endLatitudeRadians) *
            cos(endLongitudeRadians - startLongitudeRadians);

    return degrees(atan2(y, x));
  }
}

class HeadingPoint {
  HeadingPoint(this.latLng, this.heading, this.bearing, this.segmentLength);

  final LatLng latLng;
  final double heading;
  final double bearing;
  final double segmentLength;
}
