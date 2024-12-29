import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/route_names.dart';

///Get [RouteNames]  from server
final getAllRouteNamesProvider = FutureProvider<RouteNames>((ref) async {
  return RouteNames.getAllRouteNamesWamp();
});
