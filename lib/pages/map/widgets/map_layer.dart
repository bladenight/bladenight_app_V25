import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../models/bn_map_friend_marker.dart';
import '../../../models/bn_map_marker.dart';
import '../../../models/event.dart';
import '../../../models/route.dart';
import 'event_info_overlay.dart';
import 'gps_info_and_map_copyright.dart';
import 'map_buttons_light.dart';
import 'map_friend_marker_popup.dart';
import 'map_marker_popup.dart';
import 'map_tile_layer.dart';

class MapLayer extends StatefulWidget {
  const MapLayer({
    required this.event,
    required this.startPoint,
    required this.finishPoint,
    required this.routePoints,
    this.location,
    this.markers = const [],
    this.polyLines = const [],
    this.controller,
    super.key,
  });

  final LatLng? location;
  final Event event;
  final LatLng startPoint;
  final LatLng finishPoint;
  final RoutePoints routePoints;
  final List<Marker> markers;
  final List<Polyline> polyLines;
  final MapController? controller;

  @override
  State<StatefulWidget> createState() => _MapLayerState();
}

class _MapLayerState extends State<MapLayer> {
  /// Used to trigger showing/hiding of popups.
  final PopupController _popupMarkerController = PopupController();

  @override
  Widget build(BuildContext context) {
    //print('build map_layer');
    return FlutterMap(
      mapController: widget.controller,
      options: MapOptions(
        keepAlive: true,
        initialZoom: 13.0,
        minZoom: MapSettings.openStreetMapEnabled
            ? MapSettings.minZoom
            : MapSettings.minZoomDefault,
        maxZoom: MapSettings.openStreetMapEnabled
            ? MapSettings.maxZoom
            : MapSettings.maxZoomDefault,
        initialCenter: widget.startPoint,
        cameraConstraint: MapSettings.openStreetMapEnabled ||
                widget.event.hasSpecialStartPoint
            ? CameraConstraint.contain(bounds: MapSettings.mapOnlineBoundaries)
            : CameraConstraint.contain(
                bounds: MapSettings.mapOfflineBoundaries),
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
          enableMultiFingerGestureRace: true,
        ),
        onTap: (_, __) => _popupMarkerController.hideAllPopups(),
      ),
      children: [
        const MapTileLayer(),
        const GPSInfoAndMapCopyright(
          showOdoMeter: false,
        ),
        PolylineLayer(
          polylines: widget
              .polyLines, // context.watch(polyLinesProvider),// widget.polyLines,
        ),
        PopupMarkerLayer(
          options: PopupMarkerLayerOptions(
            popupDisplayOptions: PopupDisplayOptions(
              builder: (BuildContext context, Marker marker) {
                if (marker is BnMapMarker) {
                  return MapMarkerPopup(marker);
                } else if (marker is BnMapFriendMarker) {
                  return MapFriendMarkerPopup(marker);
                }
                return Container();
              },
              snap: PopupSnap.markerBottom,
              animation: const PopupAnimation.fade(
                  duration: Duration(milliseconds: 200)),
            ),
            markerCenterAnimation: const MarkerCenterAnimation(),
            markers: widget.markers,
            popupController: _popupMarkerController,

            markerTapBehavior: MarkerTapBehavior.togglePopup(),
            // : MarkerTapBehavior.togglePopupAndHideRest(),
            onPopupEvent: (event, selectedMarkers) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
        EventInfoOverlay(event: widget.event, routePoints: widget.routePoints),
        const MapButtonsLayerLight(),
      ],
    );
  }
}
