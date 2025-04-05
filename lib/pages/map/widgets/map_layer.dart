import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

import '../../../app_settings/app_configuration_helper.dart';
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
import 'special_points_layer.dart';

//map layer class for routes
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

  //only to calc dist
  final List<LatLng> routePoints;
  final List<Marker> markers;
  final List<Polyline> polyLines;
  final MapController? controller;

  @override
  State<StatefulWidget> createState() => _MapLayerState();
}

class _MapLayerState extends State<MapLayer> {
  /// Used to trigger showing/hiding of popups.
  final PopupController _popupController = PopupController();

  @override
  Widget build(BuildContext context) {
    //print('build map_layer');
    var bounds = widget.routePoints.getBounds;
    return FlutterMap(
      mapController: widget.controller,
      options: MapOptions(
        keepAlive: true,
        initialCameraFit: CameraFit.insideBounds(bounds: bounds),
        initialZoom: initialZoom,
        minZoom: MapSettings.openStreetMapEnabled
            ? MapSettings.minZoom
            : MapSettings.minZoomDefault,
        maxZoom: MapSettings.openStreetMapEnabled
            ? MapSettings.maxZoom
            : MapSettings.maxZoomDefault,
        //initialCenter: widget.startPoint,
        cameraConstraint: MapSettings.openStreetMapEnabled ||
                widget.event.hasSpecialStartPoint
            ? const CameraConstraint
                .unconstrained() //CameraConstraint.contain(bounds: MapSettings.mapOnlineBoundaries)
            : CameraConstraint.contain(
                bounds: MapSettings.bayernAtlasBoundaries),
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
          enableMultiFingerGestureRace: true,
        ),
        onTap: (_, __) => _popupController.hideAllPopups(),
      ),
      children: [
        MapTileLayer(hasSpecialStartPoint: widget.event.hasSpecialStartPoint),
        const GPSInfoAndMapCopyright(
          showOdoMeter: false,
        ),
        if (widget.routePoints.isNotEmpty)
          PolylineLayer(polylines: [
            Polyline(
                points: widget.routePoints,
                color: CupertinoTheme.of(context).primaryColor,
                strokeWidth: 4)
          ]),
        if (widget.polyLines.isNotEmpty)
          PolylineLayer(
            polylines: widget
                .polyLines, // ref.watch(polyLinesProvider),// widget.polyLines,
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
            popupController: _popupController,

            markerTapBehavior: MarkerTapBehavior.togglePopup(),
            // : MarkerTapBehavior.togglePopupAndHideRest(),
            onPopupEvent: (event, selectedMarkers) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
        SpecialPointsLayer(_popupController),
        EventInfoOverlay(event: widget.event),
        const MapButtonsLayerLight(),
      ],
    );
  }
}
