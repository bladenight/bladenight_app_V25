import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../helpers/logger.dart';
import '../../../models/images_and_links.dart';
import '../../../providers/active_event_route_provider.dart';
import '../../../providers/is_tracking_provider.dart';
import '../../../providers/location_provider.dart';
import '../../../providers/map/icon_size_provider.dart';
import '../../../providers/map/map_settings_provider.dart';
import '../../../providers/settings/dark_color_provider.dart';
import '../../../providers/settings/light_color_provider.dart';
import '../../../providers/settings/me_color_provider.dart';

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
    if (!processionRoutePointsP.hasValue || processionRoutePoints.isEmpty) {
      BnLog.debug(
          text: 'ProcessionRoutePointsCount = ${processionRoutePoints.length}');
    }
    return PolylineLayer(polylines: [
      if (activeEventRoutePoints.isNotEmpty)
        Polyline(
          //active route points
          points: activeEventRoutePoints,
          strokeWidth: context.watch(isTrackingProvider) ? 5 : 3,
          borderColor: context.watch(meColorProvider),
          color: context.watch(isTrackingProvider)
              ? const CupertinoDynamicColor.withBrightness(
                  color: CupertinoColors.white,
                  darkColor: CupertinoColors.lightBackgroundGray)
              : Colors.transparent,
          useStrokeWidthInMeter: true,
          borderStrokeWidth: context.watch(isTrackingProvider) ? 4 : 7,
          //ref.watch(isTrackingProvider),
        ),
      //user‘s track points
      if (locationUpdate.userSpeedPoints.userSpeedPoints.isNotEmpty &&
          context.watch(showOwnTrackProvider))
        for (var part in locationUpdate.userSpeedPoints.userSpeedPoints)
          Polyline(
            points: part.latLngList,
            color: part.color,
            strokeWidth: context.watch(isTrackingProvider) ? 7 : 6,
            borderStrokeWidth: 4.0,
            useStrokeWidthInMeter: true,
            borderColor: part.color
          ),

      /* Polyline(
          points: locationUpdate.userLatLongs.latLngList,
          strokeWidth: context.watch(isTrackingProvider) ? 4 : 3,
          borderColor: context.watch(meColorProvider),
          color: context.watch(isTrackingProvider)
              ? const CupertinoDynamicColor.withBrightness(
                  color: CupertinoColors.white,
                  darkColor: CupertinoColors.systemBlue)
              : CupertinoColors.white,
          borderStrokeWidth: 3.0, // ref.watch(isTrackingProvider),
        ),*/
      if (processionRoutePoints.isNotEmpty)
        Polyline(
          points: processionRoutePoints,
          color: CupertinoDynamicColor.withBrightness(
              color: ref.watch(themePrimaryDarkColorProvider),
              darkColor: ref.watch(themePrimaryLightColorProvider)),
          borderColor: CupertinoDynamicColor.withBrightness(
              color: ref.watch(themePrimaryLightColorProvider),
              darkColor: ref.watch(themePrimaryDarkColorProvider)),
          strokeWidth: ref.watch(iconSizeProvider) - 3,
          borderStrokeWidth: 3.0,
          pattern: const StrokePattern.dotted(),
        ),
    ]);
  }
}
