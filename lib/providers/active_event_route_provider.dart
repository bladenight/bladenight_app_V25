import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/location_bearing_distance.dart';
import '../models/event.dart';
import '../models/route.dart';
import 'active_event_provider.dart';
import 'realtime_data_provider.dart';

part 'active_event_route_provider.g.dart';

@Riverpod(keepAlive: true)
class ActiveEventRoute extends _$ActiveEventRoute {
  RoutePoints rp = RoutePoints('', <LatLng>[]);

  @override
  Future<RoutePoints> build() async {
    var activeEvent = ref.watch(activeEventProvider);
    return await _updateRoutePoints(activeEvent);
  }

  Future<RoutePoints> _updateRoutePoints(Event event) async {
    if (event.status != EventStatus.noevent) {
      var oldEventInPrefs = HiveSettingsDB.getActualEvent;
      //get route points on event update to update Map
      if (oldEventInPrefs.compareTo(event) != 0 ||
          rp.name != event.routeName ||
          rp.points.length <= 2) {
        var route = await RoutePoints.getActiveRoutePointsWamp();
        if (route.rpcException != null) {
          //don't_update
          return rp;
        } else {
          rp = route;
          return rp;
        }
      } else {
        return rp;
      }
    }
    rp = RoutePoints('', <LatLng>[]);
    return rp;
  }
}

@riverpod
class HeadingPoints extends _$HeadingPoints {
  @override
  Future<List<HeadingPoint>> build() async {
    var activeRoute = await ref.watch(activeEventRouteProvider.future);
    return GeoLocationHelper.calculateHeadings(activeRoute.points);
  }
}

@riverpod
class SpecialPoints extends _$SpecialPoints {
  @override
  Future<List<SpecialPoint>> build() async {
    List<SpecialPoint> points = [];
    points.add(SpecialPoint(const LatLng(48.15964, 11.52988),
        'assets/images/skatemunich_child_stop.png'));
    points.add(SpecialPoint(const LatLng(48.11015, 11.51962),
        'assets/images/skatemunich_child_stop.png'));
    points.add(SpecialPoint(const LatLng(48.12308, 11.56730),
        'assets/images/skatemunich_child_stop.png'));
    points.add(SpecialPoint(const LatLng(48.15726, 11.58417),
        'assets/images/skatemunich_child_stop.png'));
    return points;
  }
}

@riverpod
class ProcessionRoutePoints extends _$ProcessionRoutePoints {
  List<LatLng> rtData = <LatLng>[];
  int failCounter = 0;

  @override
  Future<List<LatLng>> build() async {
    var activeRoute = await ref.watch(activeEventRouteProvider.future);
    var realtimeData = ref.watch(realtimeDataProvider);
    if (realtimeData != null) {
      failCounter = 0;
      rtData = runningRoute(activeRoute.points, realtimeData.head.position,
          realtimeData.tail.position);
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
      } else if (length + segmentLength == tailPos) {
        length += segmentLength;
        running.add(a);
        continue;
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
