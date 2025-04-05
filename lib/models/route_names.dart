import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';

import '../app_settings/app_constants.dart';
import '../helpers/wamp/message_types.dart';
import '../wamp/bn_wamp_message.dart';
import '../wamp/wamp_endpoints.dart';
import '../wamp/wamp_exception.dart';
import '../wamp/wamp_v2.dart';

export 'package:latlong2/latlong.dart';

part 'route_names.mapper.dart';

@MappableClass()
class RouteNames with RouteNamesMappable {
  @MappableField(key: 'rna')
  final List<String>? routeNames;

  Exception? exception;

  RouteNames({required this.routeNames, this.exception});

  static Future<RouteNames> getAllRouteNamesWamp([string]) async {
    Completer completer = Completer();
    BnWampMessage bnWampMessage = BnWampMessage(
        WampMessageType.call, completer, WampEndpoint.getallrouteNames);
    var wampResult = await WampV2()
        .addToWamp<RouteNames>(bnWampMessage)
        .timeout(wampTimeout)
        .catchError((error, stackTrace) => error);
    if (wampResult is Map<String, dynamic>) {
      var rp = MapperContainer.globals.fromMap<RouteNames>(wampResult);
      return rp;
    }
    if (wampResult is RouteNames) {
      return wampResult;
    }
    if (wampResult is WampException) {
      return RouteNames(routeNames: [], exception: wampResult);
    }
    return RouteNames(
        routeNames: [], exception: WampException(WampExceptionReason.unknown));
  }

  @override
  String toString() {
    return 'RouteNames - length:${routeNames?.length}';
  }
}
