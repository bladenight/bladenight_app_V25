import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/route.dart';

part 'route_providers.g.dart';

@riverpod
class CurrentRoute extends _$CurrentRoute {
  @override
  Future<RoutePoints> build() {
    return RoutePoints.getActiveRoutePointsWamp();
  }
}

@riverpod
class Route extends _$Route {
  /// Notifier arguments are specified on the build method.
  /// There can be as many as you want, have any name, and even be optional/named.
  @override
  Future<RoutePoints> build(String routeName) async {
    return RoutePoints.getActiveRoutePointsByNameWamp(this.routeName);
  }
}
