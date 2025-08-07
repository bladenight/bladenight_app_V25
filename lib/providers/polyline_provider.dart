import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final polyLinesProvider =
    StateNotifierProvider<PolyLinesProviderNotifier, List<Polyline>>((ref) {
  return PolyLinesProviderNotifier(ref);
});

class PolyLinesProviderNotifier extends StateNotifier<List<Polyline>> {
  PolyLinesProviderNotifier(this.ref) : super([]);
  final Ref ref;

  void setLines() {
    state = [
      /*Polyline(
//active route points
      points:  ref.watch(activeEventProvider).activeEventRoutePoints,
      strokeWidth: ref.watch(locationProvider).isTracking ? 5 : 3,
      borderColor: ref.watch(locationProvider).isTracking
          ?  CupertinoDynamicColor.withBrightness(
          color: CupertinoColors.activeGreen,
          darkColor: CupertinoColors.white)
          : CupertinoTheme.of(context).primaryColor,
      color: ref.watch(locationProvider).isTracking
          ?  CupertinoDynamicColor.withBrightness(
          color: CupertinoColors.white,
          darkColor: CupertinoColors.lightBackgroundGray)
          : Colors.transparent,
      useStrokeWidthInMeter: true,
      borderStrokeWidth: ref.watch(locationProvider).isTracking ? 4 : 7,
      isDotted: false, //ref.watch(isTrackingProvider),
    ),*/

/*
Polyline(
//active route points
points:  activeEventProvider.activeEventRoutePoints,
strokeWidth: locationUpdate.isTracking ? 5 : 3,
borderColor: locationUpdate.isTracking
? const CupertinoDynamicColor.withBrightness(
color: CupertinoColors.activeGreen,
darkColor: CupertinoColors.white)
    : CupertinoTheme.of(context).primaryColor,
color: locationUpdate.isTracking
? const CupertinoDynamicColor.withBrightness(
color: CupertinoColors.white,
darkColor: CupertinoColors.lightBackgroundGray)
    : Colors.transparent,
useStrokeWidthInMeter: true,
borderStrokeWidth: locationUpdate.isTracking ? 4 : 7,
isDotted: false, //ref.watch(isTrackingProvider),
),


//user track
if (locationUpdate.userLatLongs.isNotEmpty &&
ref.watch(ShowOwnTrack.provider))
Polyline(
points: locationUpdate.userLatLongs,
strokeWidth: locationUpdate.isTracking ? 4 : 3,
borderColor: ref.watch(MeColor.provider),
color: ref.watch(isTrackingProvider)
? const CupertinoDynamicColor.withBrightness(
color: CupertinoColors.white,
darkColor: CupertinoColors.systemBlue)
    : CupertinoColors.white,
borderStrokeWidth: 3.0,
isDotted: false, // ref.watch(isTrackingProvider),
),
if (runningRoutePoints != null &&
runningRoutePoints.isNotEmpty)
Polyline(
points: runningRoutePoints,
color: CupertinoDynamicColor.withBrightness(
color: ref.watch(ThemePrimaryColor.provider),
darkColor:
ref.watch(ThemePrimaryDarkColor.provider)),
strokeWidth: 3,
borderStrokeWidth: 5.0,
isDotted: true),*/
    ];
  }
}
