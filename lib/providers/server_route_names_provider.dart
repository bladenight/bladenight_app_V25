import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/route_names.dart';

part 'server_route_names_provider.g.dart';

///Get [RouteNames]  from server
@riverpod
class ServerRouteNames extends _$ServerRouteNames {
  @override
  Future<RouteNames> build() async {
    var rn = await RouteNames.getAllRouteNamesWamp();
    if (rn.routeNames != null && rn.exception == null) {
      rn.routeNames!.sort();
      RouteNames rn2 = RouteNames(routeNames: rn.routeNames);
    }
    return rn;
  }

  Future<void> refresh() async {
    state = AsyncLoading();
    var res = await RouteNames.getAllRouteNamesWamp();
    state = AsyncData(res);
  }
}
