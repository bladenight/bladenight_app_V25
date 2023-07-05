import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:latlong2/latlong.dart';

import '../app_settings/app_configuration_helper.dart';
import '../app_settings/app_constants.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/location_bearing_distance.dart';
import '../helpers/wamp/message_types.dart';
import '../wamp/bn_wamp_message.dart';
import '../wamp/wamp_endpoints.dart';
import '../wamp/wamp_error.dart';
import '../wamp/wamp_v2.dart';
import 'lat_lng_mapper.dart';

export 'package:latlong2/latlong.dart';

part 'route.mapper.dart';

@MappableClass(includeCustomMappers: [LatLngMapper()])
class RoutePoints with RoutePointsMappable {
  @MappableField(key: 'nam')
  final String name;
  @MappableField(key: 'nod')
  final List<LatLng>? points;

  Exception? rpcException;
  DateTime? lastUpdate;

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
      return MapperContainer.globals
          .fromJson<RoutePoints>(HiveSettingsDB.routePointsString);
    }

    Completer completer = Completer();
    BnWampMessage bnWampMessage = BnWampMessage(
        WampMessageType.call, completer, WampEndpoint.getActiveRoute);
    var wampResult = await Wamp_V2.instance
        .addToWamp<RoutePoints>(bnWampMessage)
        .timeout(wampTimeout)
        .catchError((error, stackTrace) => RoutePoints('error', [], error));
    if (wampResult is Map<String, dynamic>) {
      var rp = MapperContainer.globals.fromMap<RoutePoints>(wampResult);
      HiveSettingsDB.setRoutePointsString(MapperContainer.globals.toJson(rp));
      HiveSettingsDB.setRoutePointsLastUpdate(DateTime.now().toUtc());
      return rp;
    }
    if (wampResult is RoutePoints) {
      return wampResult;
    }
    return RoutePoints.rpcError(Exception(WampError('unknown')));
  }

  static Future<RoutePoints> getActiveRoutePointsByNameWamp(String name) async {
    Completer completer = Completer();
    BnWampMessage bnWampMessage = BnWampMessage(
        WampMessageType.call, completer, WampEndpoint.getroute, name);
    var wampResult = await Wamp_V2.instance
        .addToWamp<RoutePoints>(bnWampMessage)
        .timeout(wampTimeout)
        .catchError((error, stackTrace) => RoutePoints(name, [], error));
    if (wampResult is Map<String, dynamic>) {
      var rp = MapperContainer.globals.fromMap<RoutePoints>(wampResult);
      return rp;
    }
    if (wampResult is RoutePoints) {
      return wampResult;
    }
    return RoutePoints.rpcError(Exception(WampError('unknown')));
  }

  @override
  String toString() {
    return 'RoutePoints $name, length:${points?.length}';
  }
}

extension RoutePointExtension on RoutePoints {
  double get getRoutePointsSummaryDistance {
    if (points == null || points!.isEmpty) {
      return 0.0;
    }
    return GeoLocationHelper.calculateDistance(points!);
  }

  LatLng get firstPointOrDefault {
    if (points == null || points!.isEmpty) {
      return defaultLatLng;
    }
    return points!.first;
  }

  LatLng get lastPointOrDefault {
    if (points == null || points!.isEmpty) {
      return defaultLatLng;
    }
    return points!.last;
  }
}
