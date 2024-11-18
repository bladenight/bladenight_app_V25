import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../generated/l10n.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/notification/toast_notification.dart';
import '../../models/user_gpx_point.dart';
import '../map/widgets/map_buttons_light.dart';
import '../map/widgets/map_tile_layer.dart';
import '../map/widgets/open_street_map_copyright.dart';
import '../map/widgets/poly_lines.dart';

class UserTrackDialog extends ConsumerWidget {
  const UserTrackDialog({
    required this.userGPXPoints,
    required this.date,
    super.key,
  });

  final String date;
  final UserGPXPoints userGPXPoints;

  static void show(
      BuildContext context, UserGPXPoints userGPXPoints, String date) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) =>
            UserTrackDialog(userGPXPoints: userGPXPoints, date: date),
        fullscreenDialog: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var initLatLng = defaultLatLng;

    if (userGPXPoints.latLngList.isNotEmpty) {
      var lastCoordinate = userGPXPoints.latLngList.last;
      initLatLng = LatLng(lastCoordinate.latitude, lastCoordinate.longitude);
    }
    return ScaffoldMessenger(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('${Localize.of(context).trackingPoints}: $date'),
        ),
        child: Builder(builder: (context) {
          return FlutterMap(
            options: MapOptions(
              keepAlive: true,
              initialZoom: 13.0,
              minZoom: MapSettings.openStreetMapEnabled
                  ? MapSettings.minZoom
                  : MapSettings.minZoomDefault,
              maxZoom: MapSettings.openStreetMapEnabled
                  ? MapSettings.maxZoom
                  : MapSettings.maxZoomDefault,
              initialCenter: initLatLng,
              cameraConstraint: MapSettings.openStreetMapEnabled
                  ? CameraConstraint.contain(
                      bounds: MapSettings.mapOnlineBoundaries)
                  : CameraConstraint.contain(
                      bounds: MapSettings.bayernAtlasBoundaries),
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
                enableMultiFingerGestureRace: true,
              ),
            ),
            children: [
              MapTileLayer(
                  hasSpecialStartPoint: MapSettings.openStreetMapEnabled),
              GestureDetector(
                onTap: () {
                  final LayerHitResult? hitResult = hitNotifier.value;
                  if (hitResult == null) return;
                  // If running frequently (such as on a hover handler), and heavy work or state changes are performed here, store each result so it can be compared to the newest result, then avoid work if they are equal
                  for (final hitValue in hitResult.hitValues) {
                    if (kDebugMode) {
                      print(hitValue);
                    }
                    showToast(
                        message: '${Localize.current.speed} $hitValue km/h');

                    break;
                  }
                },
                child: PolylineLayer(polylines: [
                  for (var part
                      in userGPXPoints.userSpeedPoints.userSpeedPoints)
                    Polyline(
                        points: part.latLngList,
                        color: part.color,
                        strokeWidth: 6,
                        borderStrokeWidth: 1.0,
                        useStrokeWidthInMeter: false,
                        //hitValue: part.realSpeedKmh,
                        borderColor: CupertinoAdaptiveTheme.of(context)
                                    .theme
                                    .brightness ==
                                Brightness.light
                            ? CupertinoColors.black
                            : part.color),
                  // ref.watch(polyLinesProvider),// widget.polyLines,
                ]),
              ),
              const Positioned(
                  left: 5,
                  bottom: 5,
                  child: SafeArea(child: OpenStreetMapCopyright())),
              const SafeArea(child: MapButtonsLayerLight()),
            ],
          );
        }),
      ),
    );
  }
}
