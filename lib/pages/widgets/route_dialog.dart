import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../helpers/location_bearing_distance.dart';
import '../../models/bn_map_marker.dart';
import '../../providers/route_providers.dart';
import '../map/widgets/map_layer.dart';
import 'data_loading_indicator.dart';
import 'no_data_warning.dart';

class RouteDialog extends ConsumerWidget {
  const RouteDialog({required this.route, required this.routeLength, Key? key})
      : super(key: key);

  final String route;
  final String routeLength;

  static show(BuildContext context, String routeName, String routeLength) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) =>
            RouteDialog(route: routeName, routeLength: routeLength),
        fullscreenDialog: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle:
            Text('${Localize.of(context).routeoverview}: $route $routeLength'),
      ),
      child: Builder(builder: (context) {
        var asyncRoute = ref.watch(routeProvider(route));
        return asyncRoute.maybeWhen(data: (route) {
          if (route.rpcException != null) {
            return SliverFillRemaining(
                child: NoDataWarning(
              onReload: () => ref.refresh(routeProvider(route.name)),
            ));
          }
          return MapLayer(
            polyLines: [
              Polyline(
                points: route.points ?? [],
                color: CupertinoTheme.of(context).primaryColor,
                strokeWidth: 4,
              ),
            ],
            markers: [
              //finishMarker
              ...[
                if (route.points != null && route.points!.isNotEmpty)
                  BnMapMarker(
                    buildContext: context,
                    headerText: Localize.of(context).finish,
                    anchorPos: AnchorPos.align(AnchorAlign.bottom),
                    color: Colors.red,
                    width: 20.0,
                    height: 20.0,
                    point: route.points!.last,
                    builder: (context) => const Stack(
                      children: [
                        Image(
                          image: AssetImage(
                            'assets/images/finishMarker.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
              ], //StartMarker
              ...[
                if (route.points != null && route.points!.isNotEmpty)
                  BnMapMarker(
                    buildContext: context,
                    headerText: Localize.of(context).start,
                    anchorPos: AnchorPos.align(AnchorAlign.top),
                    color: Colors.transparent,
                    width: 25.0,
                    height: 25.0,
                    point: route.points!.first,
                    builder: (context) => const Stack(
                      children: [
                        Image(
                          image: AssetImage(
                            'assets/images/startMarker.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                if (route.points != null && route.points!.length > 3) ...[
                  for (var hp
                      in LocationBearingAndDistanceHelper.calculateHeadings(
                          route.points!))
                    Marker(
                      point: hp.latLng,
                      width: 20,
                      height: 20,
                      builder: (context) => Transform.rotate(
                        angle: hp.bearing,
                        child: const Image(
                          image: AssetImage(
                            'assets/images/arrow_up.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ],
            ],
          );
        }, loading: () {
          return const Center(
            child: DataLoadingIndicator(),
          );
        }, orElse: () {
          return Center(
            child: NoDataWarning(
              onReload: () => ProviderContainer().refresh(routeProvider(route)),
            ),
          );
        });
      }),
    );
  }
}
