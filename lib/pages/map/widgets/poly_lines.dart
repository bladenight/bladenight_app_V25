import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../providers/active_event_notifier_provider.dart';
import '../../../providers/is_tracking_provider.dart';
import '../../../providers/location_provider.dart';
import '../../../providers/shared_prefs_provider.dart';

class PolyLinesLayer extends ConsumerStatefulWidget {
  const PolyLinesLayer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PolyLines();
}

class _PolyLines extends ConsumerState<PolyLinesLayer> {
  @override
  Widget build(BuildContext context) {
    var locationUpdate = ref.watch(locationProvider);
    var activeEvent = ref.watch(activeEventProvider);
    var runningRoutePoints = locationUpdate.realtimeUpdate
        ?.runningRoute(activeEvent.activeEventRoutePoints);

    return PolylineLayer(polylines: [
      if (context.watch(activeEventProvider).activeEventRoutePoints.isNotEmpty)
        Polyline(
          //active route points
          points: context.watch(activeEventProvider).activeEventRoutePoints,
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

      if (runningRoutePoints != null && runningRoutePoints.isNotEmpty)
        Polyline(
            points: runningRoutePoints,
            color: CupertinoDynamicColor.withBrightness(
                color: context.watch(ThemePrimaryColor.provider),
                darkColor: ref.watch(ThemePrimaryDarkColor.provider)),
            strokeWidth: 3,
            borderStrokeWidth: 5.0,
            isDotted: true),
      //user track
      if (locationUpdate.userLatLongs.isNotEmpty &&
          context.watch(ShowOwnTrack.provider))
        Polyline(
          points: locationUpdate.userLatLongs,
          strokeWidth: context.watch(isTrackingProvider) ? 4 : 3,
          borderColor: context.watch(MeColor.provider),
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
