import 'package:bladenight_app_flutter/pages/map/widgets/event_Info_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../helpers/distance_converter.dart';
import '../../helpers/location_bearing_distance.dart';
import '../../models/bn_map_marker.dart';
import '../../models/event.dart';
import '../../models/route.dart';
import '../../providers/route_providers.dart';
import '../map/widgets/map_layer.dart';
import 'data_loading_indicator.dart';
import 'no_data_warning.dart';

class RouteDialog extends ConsumerWidget {
  RouteDialog({required this.event, Key? key}) : super(key: key);

  final Event event;

  static show(BuildContext context, Event event) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => RouteDialog(event: event),
        fullscreenDialog: false,
      ),
    );
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
              '${Localize.of(context).routeoverview}: ${event.routeName}'),
        ),
        child: Builder(builder: (context) {
          var asyncRoute = ref.watch(routeProvider(event.routeName));
          return asyncRoute.maybeWhen(data: (route) {
            if (route.rpcException != null) {
              return SliverFillRemaining(
                  child: NoDataWarning(
                onReload: () => ref.refresh(routeProvider(route.name)),
              ));
            }
            return Stack(children: [
              MapLayer(
                event: event,
                startPoint: route.firstPointOrDefault,
                finishPoint: route.lastPointOrDefault,
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
                          in GeoLocationHelper.calculateHeadings(route.points!))
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
              ),
              EventInfoOverlay(event: event, routePoints: route),
            ]);
          }, loading: () {
            return const Center(
              child: DataLoadingIndicator(),
            );
          }, orElse: () {
            return Center(
              child: NoDataWarning(
                onReload: () =>
                    ProviderContainer().refresh(routeProvider(event.routeName)),
              ),
            );
          });
        }),
      ),
    );
  }
}
