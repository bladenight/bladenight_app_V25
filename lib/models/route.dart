import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../app_settings/app_configuration_helper.dart';
import '../app_settings/app_constants.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/location_bearing_distance.dart';
import '../helpers/wamp/message_types.dart';
import '../wamp/bn_wamp_message.dart';
import '../wamp/wamp_endpoints.dart';
import '../wamp/wamp_exception.dart';
import '../wamp/wamp_v2.dart';
import 'lat_lng_mapper.dart';

export 'package:latlong2/latlong.dart';

part 'route.mapper.dart';

@MappableClass(includeCustomMappers: [LatLngMapper()])
class RoutePoints with RoutePointsMappable {
  @MappableField(key: 'nam')
  final String name;
  @MappableField(key: 'nod')
  List<LatLng> points = <LatLng>[];

  Exception? rpcException;
  DateTime? lastUpdate;

  LatLng get startLatLng => _startLatLng;

  LatLng get finishLatLng => _finishLatLng;

  LatLng _startLatLng = defaultLatLng;
  LatLng _finishLatLng = defaultLatLng;

  static RoutePoints rpcError(Exception exception) {
    return RoutePoints('error', [], exception);
  }

  RoutePoints(this.name, this.points, [this.rpcException]);

  static Future<RoutePoints> getActiveRoutePointsWamp() async {
    if (HiveSettingsDB.routePointsString.isNotEmpty &&
        DateTime.now()
                .toUtc()
                .difference(HiveSettingsDB.routePointsLastUpdate) <
            const Duration(seconds: 30)) {
      var rp = MapperContainer.globals
          .fromJson<RoutePoints>(HiveSettingsDB.routePointsString);
      if (rp.points.isNotEmpty) {
        rp._startLatLng = rp.points.first;
        rp._finishLatLng = rp.points.last;
      } else {
        rp._startLatLng = defaultLatLng;
        rp._finishLatLng = defaultLatLng;
      }
      return rp;
    }

    Completer completer = Completer();
    BnWampMessage bnWampMessage = BnWampMessage(
        WampMessageType.call, completer, WampEndpoint.getActiveRoute);
    var wampResult = await WampV2()
        .addToWamp<RoutePoints>(bnWampMessage)
        .timeout(wampTimeout)
        .catchError((error, stackTrace) =>
            RoutePoints('error', [], WampException(error.toString())));
    if (wampResult is Map<String, dynamic>) {
      var rp = MapperContainer.globals.fromMap<RoutePoints>(wampResult);
      HiveSettingsDB.setRoutePointsString(MapperContainer.globals.toJson(rp));
      return rp;
    }
    if (wampResult is RoutePoints) {
      return wampResult;
    }
    return RoutePoints.rpcError(WampException('unknown'));
  }

  static Future<RoutePoints> getActiveRoutePointsByNameWamp(String name) async {
    Completer completer = Completer();
    BnWampMessage bnWampMessage = BnWampMessage(
        WampMessageType.call, completer, WampEndpoint.getroute, name);
    var wampResult = await WampV2()
        .addToWamp<RoutePoints>(bnWampMessage)
        .timeout(wampTimeout)
        .catchError((error, stackTrace) =>
            RoutePoints(name, [], WampException(error.toString())));
    if (wampResult is Map<String, dynamic>) {
      var rp = MapperContainer.globals.fromMap<RoutePoints>(wampResult);
      return rp;
    }
    if (wampResult is RoutePoints) {
      return wampResult;
    }
    return RoutePoints.rpcError(WampException('unknown'));
  }

  @override
  String toString() {
    return 'RoutePoints $name, length:${points.length}';
  }
}

extension RoutePointExtension on RoutePoints {
  double get getRouteTotalDistance {
    if (points.isEmpty) {
      return 0.0;
    }
    return GeoLocationHelper.calculateDistance(points);
  }

  LatLng get startLatLngOrDefault {
    if (points.isEmpty) {
      return defaultLatLng;
    }
    return points.first;
  }

  LatLng get finishLatLngOrDefault {
    if (points.isEmpty) {
      return defaultLatLng;
    }
    return points.last;
  }

  LatLngBounds? get routeBounds {
    if (points.isEmpty) {
      return null;
    }
    return points.getBounds;
  }
}

extension LatLngBoundsExtension on List<LatLng> {
  ///Get [LatLngBounds] for given [List<LatLng>] or [defaultMapCamBounds]
  LatLngBounds get getBounds {
    if (isEmpty) {
      return defaultMapCamBounds;
    }
    double? x0, x1, y0, y1;
    for (LatLng latLng in this) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (x1 == null || latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (y1 == null || latLng.longitude > y1) y1 = latLng.longitude;
        if (y0 == null || latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    //return MapSettings.bayernAtlasBoundaries;
    //const LatLng(47.248466288051446, 8.945107890491915),
    //const LatLng(50.57987000589413, 13.90891310401004),
    if (x0 == null || y0 == null || x1 == null || y1 == null) {
      return defaultMapCamBounds;
    }
    var offset = 0.03;
    return LatLngBounds(
        LatLng(x0 - offset, y0 - offset), LatLng(x1 + offset, y1 + offset));
  }

  LatLng get firstOrDefault {
    if (isNotEmpty) {
      return first;
    } else {
      return defaultLatLng;
    }
  }

  LatLng get lastOrDefault {
    if (isNotEmpty) {
      return last;
    } else {
      return defaultLatLng;
    }
  }
}
