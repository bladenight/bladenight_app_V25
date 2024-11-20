import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../generated/l10n.dart';
import '../../helpers/location_bearing_distance.dart';
import '../../models/bn_map_marker.dart';
import '../../models/event.dart';
import '../../models/route.dart';
import '../../providers/map/icon_size_provider.dart';
import '../../providers/route_providers.dart';
import '../map/widgets/map_layer.dart';
import 'data_loading_indicator.dart';
import 'no_data_warning.dart';

class RouteNameDialog extends ConsumerWidget {
  const RouteNameDialog({required this.routeName, super.key});

  final String routeName;

  static show(BuildContext context, String routeName) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => RouteNameDialog(
          routeName: routeName,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldMessenger(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('${Localize.of(context).routeoverview}: $routeName'),
        ),
        child: Builder(builder: (context) {
          var iconSize = ref.watch(iconSizeProvider);
          var sizeValue = MediaQuery.textScalerOf(context).scale(iconSize);
          var asyncRoute = ref.watch(routeProvider(routeName));
          return asyncRoute.maybeWhen(
              skipLoadingOnRefresh: false,
              skipLoadingOnReload: false,
              data: (route) {
                if (route.rpcException != null) {
                  return Stack(children: [
                    MapLayer(
                      event: Event(
                          startDate: DateTime.now(), routeName: routeName),
                      startPoint: LatLng(defaultLatitude, defaultLongitude),
                      finishPoint: route.finishLatLngOrDefault,
                      routePoints: route.points,
                    ),
                    NoDataWarning(
                      onReload: () => ref.refresh(routeProvider(route.name)),
                    )
                  ]);
                }
                return Stack(children: [
                  MapLayer(
                    event:
                        Event(startDate: DateTime.now(), routeName: routeName),
                    startPoint: route.startLatLngOrDefault,
                    finishPoint: route.finishLatLngOrDefault,
                    routePoints: route.points,
                    polyLines: [
                      Polyline(
                        points: route.points,
                        color: CupertinoTheme.of(context).primaryColor,
                        strokeWidth: 4,
                      ),
                    ],
                    markers: [
                      //finishMarker
                      ...[
                        if (route.points.isNotEmpty)
                          BnMapMarker(
                            buildContext: context,
                            headerText: Localize.of(context).finish,
                            color: Colors.red,
                            width: 20.0,
                            height: 20.0,
                            point: route.points.last,
                            child: Builder(
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
                          ),
                      ], //StartMarker
                      ...[
                        if (route.points.isNotEmpty)
                          BnMapMarker(
                            buildContext: context,
                            headerText: Localize.of(context).start,
                            //anchorPosition: AnchorPos.align(AnchorAlign.top),
                            color: Colors.transparent,
                            width: sizeValue,
                            height: sizeValue,
                            point: route.points.first,
                            child: Builder(
                              builder: (context) => const Stack(
                                children: [
                                  Image(
                                    image: AssetImage(
                                      'assets/images/start_marker.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (route.points.length > 3) ...[
                          for (var hp in GeoLocationHelper.calculateHeadings(
                              route.points))
                            Marker(
                              point: hp.latLng,
                              width: 20,
                              height: 20,
                              child: Builder(
                                builder: (context) => Transform.rotate(
                                  angle: hp.bearing,
                                  child: const Image(
                                    image: AssetImage(
                                      'assets/images/arrow_up_pure_margin.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ],
                    ],
                  ),
                ]);
              },
              loading: () {
                return const Center(
                  child: DataLoadingIndicator(),
                );
              },
              orElse: () {
                return Center(
                  child: NoDataWarning(
                    onReload: () => ref.refresh(routeProvider(routeName)),
                  ),
                );
              });
        }),
      ),
    );
  }
}
