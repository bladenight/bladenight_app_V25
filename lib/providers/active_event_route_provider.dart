import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/location_bearing_distance.dart';
import '../helpers/logger/logger.dart';
import '../helpers/watch_communication_helper.dart';
import '../models/event.dart';
import '../models/route.dart';
import '../models/special_point.dart';
import 'active_event_provider.dart';
import 'images_and_links/special_points_image_and_link_provider.dart';
import 'location_provider.dart';

part 'active_event_route_provider.g.dart';

@riverpod
class HeadingPoints extends _$HeadingPoints {
  @override
  Future<List<HeadingPoint>> build() async {
    var activeRoute = ref.watch(activeEventProvider);
    return GeoLocationHelper.calculateHeadings(activeRoute.nodes);
  }
}

@riverpod
class SpecialPoints extends _$SpecialPoints {
  @override
  Future<List<SpecialPoint>> build() async {
    List<SpecialPoint> points = [];
    var pointsJson = ref.read(specialPointsImageAndLinkProvider).text;
    if (pointsJson != null) {
      try {
        var spPoints = SpecialPointsMapper.fromJson(pointsJson);
        points = spPoints.specialPoints;
      } catch (e) {
        BnLog.error(
            text: 'SpecialPoints parse error $e', className: toString());
      }
    }
    return points;
  }
}

@riverpod
class ProcessionRoutePoints extends _$ProcessionRoutePoints {
  List<LatLng> rtData = <LatLng>[];
  int failCounter = 0;

  @override
  Future<List<LatLng>> build() async {
    var activeRoute = ref.read(activeEventProvider).nodes;
    var realtimeData = ref.watch(realtimeDataProvider);
    if (realtimeData != null) {
      failCounter = 0;
      rtData = runningRoute(
          activeRoute, realtimeData.head.position, realtimeData.tail.position);
      SendToWatch.updateRunningRoute(rtData);
      state = AsyncValue.data(rtData);
      return Future(() => rtData);
    }
    failCounter++;
    if (failCounter > 3) {
      return Future(() => <LatLng>[]);
    } else {
      return Future(() => rtData);
    }
  }

  List<LatLng> runningRoute(List<LatLng> points, int headPos, int tailPos) {
    var running = <LatLng>[];
    var length = 0.0;
    bool tailExactFound = false;

    for (var i = 0; i < points.length - 1; i++) {
      var a = points[i], b = points[i + 1];
      var segmentLength = GeoLocationHelper.haversine(
        a.latitude,
        a.longitude,
        b.latitude,
        b.longitude,
      );

      if (tailPos == 0 && headPos == 0) {
        running.add(a);
        break;
      }

      if (length + segmentLength < tailPos) {
        length += segmentLength;
        continue;
      } else if (!tailExactFound && length + segmentLength >= tailPos) {
        //calculate exact end marker
        double missingLength = tailPos - length;
        if (missingLength <= segmentLength) {
          double relativePositionOnSegment = missingLength / segmentLength;
          double lat = a.latitude +
              relativePositionOnSegment * (b.latitude - a.latitude);
          double lon = a.longitude +
              relativePositionOnSegment * (b.longitude - a.longitude);
          var endLatLong = LatLng(lat, lon);
          running.add(endLatLong);
        } else {
          running.add(a);
        }
        length += segmentLength;
        tailExactFound = true;
        continue;
        //find exact point for tail
      } else {
        if (length + segmentLength >= headPos) {
          running.add(a);
          //calculate missing part
          double missingLength = headPos - length;
          if (missingLength <= segmentLength) {
            double relativePositionOnSegment = missingLength / segmentLength;
            double lat = a.latitude +
                relativePositionOnSegment * (b.latitude - a.latitude);
            double lon = a.longitude +
                relativePositionOnSegment * (b.longitude - a.longitude);
            var endLatLong = LatLng(lat, lon);
            running.add(endLatLong);
          }
          break;
        } else {
          length += segmentLength;
          running.add(a);
        }
      }
    }

    if (running.isEmpty && points.isNotEmpty) {
      running.add(points.first);
    }
//reverse it to draw head -first in queue to tail last in queue
    return running.reversed.toList();
  }
}
