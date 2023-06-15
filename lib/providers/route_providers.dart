import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/route.dart';

final currentRouteProvider = FutureProvider((ref) async {
  return RoutePoints.getActiveRoutePointsWamp();
});

final routeProvider =
    FutureProvider.autoDispose.family((ref, String name) async {
      return RoutePoints.getActiveRoutePointsByNameWamp(name);
});
