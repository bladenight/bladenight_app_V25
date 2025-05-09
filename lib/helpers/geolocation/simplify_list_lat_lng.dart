// Based on simplify
// Copyright (c) 2021, Bjarte Bore
// Copyright (c) 2017, Vladimir Agafonkin
// All rights reserved.

import '../../models/images_and_links.dart';

/// Square distance between two points
double _getSquareDistance(LatLng p1, LatLng p2) {
  var dx = p1.latitude - p2.latitude;
  var dy = p1.longitude - p2.longitude;

  return dx * dx + dy * dy;
}

/// Square distance between point and a segment
double _getSquareSegmentDistance(LatLng p, LatLng p1, LatLng p2) {
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

List<LatLng> _simplifyRadialDist(
  List<LatLng> points,
  double sqTolerance,
) {
  LatLng prevPoint = points[0];
  final List<LatLng> newPoints = [prevPoint];
  late LatLng point;

  for (var i = 1, len = points.length; i < len; i++) {
    point = points[i];
    var dist = _getSquareDistance(point, prevPoint);
    if (dist > sqTolerance) {
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
  List<LatLng> points,
  int first,
  int last,
  double sqTolerance,
  List<LatLng> simplified,
) {
  double maxSqDist = sqTolerance;
  late int index;

  for (var i = first + 1; i < last; i++) {
    final double sqDist =
        _getSquareSegmentDistance(points[i], points[first], points[last]);

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
List<LatLng> _simplifyDouglasPeucker(
  List<LatLng> points,
  double sqTolerance,
) {
  final int last = points.length - 1;

  final List<LatLng> simplified = [points[0]];
  _simplifyDPStep(points, 0, last, sqTolerance, simplified);
  simplified.add(points[last]);

  return simplified;
}

// both algorithms combined for awesome performance
List<LatLng> simplify(
  List<LatLng> points, {
  double? tolerance,
  bool highestQuality = false,
}) {
  if (points.length <= 2) {
    return points;
  }

  List<LatLng> nextPoints = points;

  final double sqTolerance =
      tolerance != null ? tolerance * tolerance : 1 / 1000;

  nextPoints =
      highestQuality ? points : _simplifyRadialDist(nextPoints, sqTolerance);

  nextPoints = _simplifyDouglasPeucker(nextPoints, sqTolerance);

  return nextPoints;
}
