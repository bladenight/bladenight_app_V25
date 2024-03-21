import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../models/images_and_links.dart';
import '../../../providers/active_event_route_provider.dart';
import '../../../providers/is_tracking_provider.dart';
import '../../../providers/location_provider.dart';
import '../../../providers/map/map_settings_provider.dart';
import '../../../providers/settings/dark_color_provider.dart';
import '../../../providers/settings/light_color_provider.dart';
import '../../../providers/me_color_provider.dart';

class PolyLinesLayer extends ConsumerStatefulWidget {
  const PolyLinesLayer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PolyLines();
}

class _PolyLines extends ConsumerState<PolyLinesLayer> {
  @override
  Widget build(BuildContext context) {
    var locationUpdate = ref.watch(locationProvider);
    var activeEventRouteP = ref.watch(activeEventRouteProvider);
    var processionRoutePointsP = ref.watch(processionRoutePointsProvider);
    var activeEventRoutePoints = <LatLng>[];
    activeEventRouteP.hasValue
        ? activeEventRoutePoints = activeEventRouteP.value!.points
        : <LatLng>[];
    var processionRoutePoints = <LatLng>[];
    processionRoutePointsP.hasValue
        ? processionRoutePoints = processionRoutePointsP.value!
        : <LatLng>[];

    return PolylineLayer(polylines: [
      if (activeEventRoutePoints.isNotEmpty)
        Polyline(
          //active route points
          points: activeEventRoutePoints,
          strokeWidth: context.watch(isTrackingProvider) ? 5 : 3,
          borderColor: context.watch(isTrackingProvider)
              ? const CupertinoDynamicColor.withBrightness(
                  color: CupertinoColors.activeGreen,
                  darkColor: CupertinoColors.white)
              : CupertinoTheme.of(context).primaryColor,
          color: context.watch(isTrackingProvider)
              ? const CupertinoDynamicColor.withBrightness(
                  color: CupertinoColors.white,
                  darkColor: CupertinoColors.lightBackgroundGray)
              : Colors.transparent,
          useStrokeWidthInMeter: true,
          borderStrokeWidth: context.watch(isTrackingProvider) ? 4 : 7,
          isDotted: false, //ref.watch(isTrackingProvider),
        ),

      if (processionRoutePoints.isNotEmpty)
        Polyline(
            points: processionRoutePoints,
            color: CupertinoDynamicColor.withBrightness(
                color: context.watch(themePrimaryLightColorProvider),
                darkColor: ref.watch(themePrimaryDarkColorProvider)),
            strokeWidth: 3,
            borderStrokeWidth: 5.0,
            isDotted: true),
      //user track
      if (locationUpdate.userLatLongs.isNotEmpty &&
          context.watch(showOwnTrackProvider))
        Polyline(
          points: locationUpdate.userLatLongs,
          strokeWidth: context.watch(isTrackingProvider) ? 4 : 3,
          borderColor: context.watch(meColorProvider),
          color: context.watch(isTrackingProvider)
              ? const CupertinoDynamicColor.withBrightness(
                  color: CupertinoColors.white,
                  darkColor: CupertinoColors.systemBlue)
              : CupertinoColors.white,
          borderStrokeWidth: 3.0,
          isDotted: false, // ref.watch(isTrackingProvider),
        ),
    ]);
  }
}
