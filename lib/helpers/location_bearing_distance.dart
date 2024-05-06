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
      var midPoint = getMidPointBetweenTwoPoints(
          point1.latitude, point1.longitude, point2.latitude, point2.longitude);
      headingPoints.add(HeadingPoint(
          LatLng(midPoint.latitude, midPoint.longitude),
          heading.toDouble(),
          radians(bearing),
          distP1P2.toDouble()));
    }
    //max 20
    if (headingPoints.length > 30) {
      var sublist = <HeadingPoint>[];
      int i = (headingPoints.length / 30).round();
      var subCount = 0;
      for (var hp in headingPoints) {
        if (subCount == 0) sublist.add(hp);
        subCount++;
        if (subCount >= i) {
          subCount = 0;
        }
      }
      return sublist;
    }
    return headingPoints;
  }

  static double calculateDistance(List<LatLng> routePoints) {
    if (routePoints.isEmpty) return 0.0;
    double sumDistance = 0;

    for (var i = 0; i < routePoints.length - 1; i++) {
      var point1 = LatLng(routePoints[i].latitude, routePoints[i].longitude);
      var point2 =
          LatLng(routePoints[i + 1].latitude, routePoints[i + 1].longitude);
      sumDistance += haversine(
          point1.latitude, point1.longitude, point2.latitude, point2.longitude);
    }
    return sumDistance;
  }

  /// Calculate between two locations in meter
  static double haversine(double lat1, double lon1, double lat2, double lon2) {
    // distance between latitudes and longitudes
    double dLat = radians(lat2 - lat1);
    double dLon = radians(lon2 - lon1);
    // convert to radians
    lat1 = radians(lat1);
    lat2 = radians(lat2); // apply formulae
    var a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    double rad = 6371;
    double c = 2 * asin(sqrt(a));
    return rad * c*1000;
  }

  static LatLng getMidPointBetweenTwoPoints(
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

   static LatLng getLatLongForLinearPos(double linearPosition, double lat1, double long1, double lat2, double long2){
    final double bearing  = bearingBetween(lat1, long1, lat2, long2);
    return moveLatLng(LatLng(lat1, long1), linearPosition, bearing);
  }

   static LatLng moveLatLng(LatLng latLng, double range, double bearing) {
   const double earthRadius = 6378137.0;
   const degreesToRadians = pi / 180.0;
   const radiansToDegrees = 180.0 / pi;

    final double latA = latLng.latitude * degreesToRadians;
    final double lonA = latLng.longitude * degreesToRadians;
    final double angularDistance = range / earthRadius;
    final double trueCourse = bearing * degreesToRadians;

    final double lat = asin(
        sin(latA) * cos(angularDistance) +
            cos(latA) * sin(angularDistance) * cos(trueCourse));

    final double dLon = atan2(
        sin(trueCourse) * sin(angularDistance) * cos(latA),
        cos(angularDistance) - sin(latA) * sin(lat));

    final double lon = ((lonA + dLon + pi) % (pi * 2)) - pi;

    return LatLng(lat * radiansToDegrees, lon * radiansToDegrees);
  }
}


class HeadingPoint {
  HeadingPoint(this.latLng, this.heading, this.bearing, this.segmentLength);

  final LatLng latLng;
  final double heading;
  final double bearing;
  final double segmentLength;
}


