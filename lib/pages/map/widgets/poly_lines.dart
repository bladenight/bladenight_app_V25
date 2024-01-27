import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../providers/active_event_notifier_provider.dart';
import '../../../providers/location_provider.dart';
import '../../../providers/shared_prefs_provider.dart';

class PolyLinesLayer extends StatefulWidget {
  const PolyLinesLayer({super.key});

  @override
  State<StatefulWidget> createState() => _PolyLines();
}

class _PolyLines extends State<PolyLinesLayer> {
  @override
  Widget build(BuildContext context) {
    var locationUpdate = context.watch(locationProvider);
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
      //user track
      if (locationUpdate.userLatLongs.isNotEmpty &&
          context.watch(ShowOwnTrack.provider))
        Polyline(
          points: locationUpdate.userLatLongs,
          strokeWidth: locationUpdate.isTracking ? 4 : 3,
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
