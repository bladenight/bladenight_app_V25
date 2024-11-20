import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_settings/app_configuration_helper.dart';
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

final LayerHitNotifier hitNotifier = ValueNotifier(null);

class BnMapPagePolyLinesLayer extends ConsumerStatefulWidget {
  const BnMapPagePolyLinesLayer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BnMapPagePolyLinesLayer();
}

class _BnMapPagePolyLinesLayer extends ConsumerState<BnMapPagePolyLinesLayer> {
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
    print('${DateTime.now().toIso8601String()} Build Polylines Layer');
    return PolylineLayer(hitNotifier: hitNotifier, polylines: [
      if (activeEventRoutePoints.isNotEmpty)
        Polyline(
          //current and active route points
          points: activeEventRoutePoints,
          strokeWidth: ref.watch(isTrackingProvider) ? 5 : 3,
          borderColor: CupertinoAdaptiveTheme.of(context).theme.brightness ==
                  Brightness.light
              ? Colors.blue
              : Colors.yellow,
          color: ref.watch(isTrackingProvider)
              ? CupertinoAdaptiveTheme.of(context).theme.brightness ==
                      Brightness.light
                  ? CupertinoColors.white
                  : CupertinoColors.darkBackgroundGray
              : Colors.transparent,
          useStrokeWidthInMeter: false,
          borderStrokeWidth: ref.watch(isTrackingProvider) ? 4 : 5,
          //ref.watch(isTrackingProvider),
        ),
      //user‘s track points
      if (locationUpdate.userSpeedPoints.userSpeedPoints.isNotEmpty &&
          ref.watch(showOwnTrackProvider) &&
          ref.watch(showOwnColoredTrackProvider))
        for (var part in locationUpdate.userSpeedPoints.userSpeedPoints)
          Polyline(
              points: part.latLngList,
              color: part.color,
              strokeWidth: ref.watch(isTrackingProvider) ? 6 : 6,
              borderStrokeWidth: 1.0,
              useStrokeWidthInMeter: false,
              hitValue: part.realSpeedKmh,
              borderColor:
                  CupertinoAdaptiveTheme.of(context).theme.brightness ==
                          Brightness.light
                      ? CupertinoColors.black
                      : part.color),
      if (ref.watch(showOwnTrackProvider) &&
          !ref.watch(showOwnColoredTrackProvider))
        Polyline(
          points: locationUpdate.userLatLngList,
          strokeWidth: ref.watch(isTrackingProvider) ? 4 : 3,
          borderColor: ref.watch(meColorProvider),
          color: ref.watch(isTrackingProvider)
              ? const CupertinoDynamicColor.withBrightness(
                  color: CupertinoColors.white,
                  darkColor: CupertinoColors.systemBlue)
              : CupertinoColors.white,
          borderStrokeWidth: 2.0, // ref.watch(isTrackingProvider),
        ),
      if (processionRoutePoints.isNotEmpty)
        Polyline(
          points: processionRoutePoints,
          color: CupertinoAdaptiveTheme.of(context).theme.brightness ==
                  Brightness.light
              ? ref.watch(themePrimaryDarkColorProvider)
              : ref.watch(themePrimaryLightColorProvider),
          borderColor: CupertinoAdaptiveTheme.of(context).theme.brightness ==
                  Brightness.light
              ? ref.watch(themePrimaryLightColorProvider)
              : ref.watch(themePrimaryDarkColorProvider),
          strokeWidth: ref.watch(iconSizeProvider) - 10,
          borderStrokeWidth: 2.0,
          pattern: const StrokePattern.dotted(),
        ),
    ]);
  }
}
