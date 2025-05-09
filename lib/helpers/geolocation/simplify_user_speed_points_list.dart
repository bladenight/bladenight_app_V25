// Based on simplify
// Copyright (c) 2021, Bjarte Bore
// Copyright (c) 2017, Vladimir Agafonkin
// All rights reserved.

import '../../models/images_and_links.dart';
import '../../models/user_speed_point.dart';

/// Square distance between two points
double getSquareDistance(LatLng p1, LatLng p2) {
  var dx = p1.latitude - p2.latitude;
  var dy = p1.longitude - p2.longitude;

  return dx * dx + dy * dy;
}

/// Square distance between point and a segment
double getSquareSegmentDistance(LatLng p, LatLng p1, LatLng p2) {
  var x = p1.latitude;
  var y = p1.longitude;

  var dx = p2.latitude - x;
  var dy = p2.longitude - y;

  if (dx != 0 || dy != 0) {
    var t =
        ((p.latitude - x) * dx + (p.longitude - y) * dy) / (dx * dx + dy * dy);

    if (t > 1) {
      x = p2.latitude;
      y = p2.longitude;
    } else if (t > 0) {
      x += dx * t;
      y += dy * t;
    }
    dx = p.latitude - x;
    dy = p.longitude - y;
  }
  return dx * dx + dy * dy;
}

List<UserSpeedPoint> _simplifyRadialDist(
  List<UserSpeedPoint> points,
  double sqTolerance,
) {
  UserSpeedPoint prevPoint = points[0];
  final List<UserSpeedPoint> newPoints = [prevPoint];
  late UserSpeedPoint point;

  // ignore: prefer_final_locals
  for (var i = 1, len = points.length; i < len; i++) {
    point = points[i];

    if (getSquareDistance(LatLng(point.latitude, point.longitude),
            LatLng(prevPoint.latitude, prevPoint.longitude)) >
        sqTolerance) {
      newPoints.add(point);
      prevPoint = point;
    }
  }

  if (prevPoint != point) {
    newPoints.add(point);
  }

  return newPoints;
}

void _simplifyDPStep(
  List<UserSpeedPoint> points,
  int first,
  int last,
  double sqTolerance,
  List<UserSpeedPoint> simplified,
) {
  double maxSqDist = sqTolerance;
  late int index;

  for (var i = first + 1; i < last; i++) {
    final double sqDist = getSquareSegmentDistance(
        LatLng(points[i].latitude, points[i].longitude),
        LatLng(points[first].latitude, points[first].longitude),
        LatLng(points[last].latitude, points[last].longitude));

    if (sqDist > maxSqDist) {
      index = i;
      maxSqDist = sqDist;
    }
  }

  if (maxSqDist > sqTolerance) {
    if (index - first > 1) {
      _simplifyDPStep(points, first, index, sqTolerance, simplified);
    }
    simplified.add(points[index]);
    if (last - index > 1) {
      _simplifyDPStep(points, index, last, sqTolerance, simplified);
    }
  }
}

// simplification using Ramer-Douglas-Peucker algorithm
List<UserSpeedPoint> _simplifyDouglasPeucker(
  List<UserSpeedPoint> points,
  double sqTolerance,
) {
  final int last = points.length - 1;

  final List<UserSpeedPoint> simplified = [points[0]];
  _simplifyDPStep(points, 0, last, sqTolerance, simplified);
  simplified.add(points[last]);

  return simplified;
}

// both algorithms combined for awesome performance
List<UserSpeedPoint> simplifyUserSpeedPointList(
  List<UserSpeedPoint> points, {
  double? tolerance,
  bool highestQuality = false,
}) {
  if (points.length <= 2) {
    return points;
  }

  List<UserSpeedPoint> nextPoints = points;

  final double sqTolerance =
      tolerance != null ? tolerance / 10000 * tolerance / 10000 : 1 / 10000;

  nextPoints =
      highestQuality ? points : _simplifyRadialDist(nextPoints, sqTolerance);

  nextPoints = _simplifyDouglasPeucker(nextPoints, sqTolerance);

  return nextPoints;
}
