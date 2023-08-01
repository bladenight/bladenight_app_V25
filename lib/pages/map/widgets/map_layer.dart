import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../models/bn_map_friend_marker.dart';
import '../../../models/bn_map_marker.dart';
import '../../../models/event.dart';
import '../../../models/route.dart';
import 'bn_dark_container.dart';
import 'map_friend_marker_popup.dart';
import 'map_marker_popup.dart';

class MapLayer extends StatefulWidget {
  const MapLayer(
      {required this.event,
      required this.startPoint,
      required this.finishPoint,
      this.location,
      this.markers = const [],
      this.polyLines = const [],
      this.controller,
      Key? key})
      : super(key: key);

  final LatLng? location;
  final Event event;
  final LatLng startPoint;
  final LatLng finishPoint;
  final List<Marker> markers;
  final List<Polyline> polyLines;
  final MapController? controller;

  @override
  State<StatefulWidget> createState() => _MapLayerState();
}

class _MapLayerState extends State<MapLayer> {
  /// Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  @override
  Widget build(BuildContext context) {
    //print('build map_layer');
    return FlutterMap(
      mapController: widget.controller,
      options: MapOptions(
        keepAlive: true,
        zoom: 12.0,
        minZoom: HiveSettingsDB.openStreetMapEnabled
            ? MapSettings.minZoom
            : MapSettings.minZoomDefault,
        maxZoom: HiveSettingsDB.openStreetMapEnabled
            ? MapSettings.maxZoom
            : MapSettings.maxZoomDefault,
        center: widget.startPoint,
        maxBounds: HiveSettingsDB.openStreetMapEnabled ||
                widget.event.hasSpecialStartPoint
            ? MapSettings.mapOnlineBoundaries
            : MapSettings.mapOfflineBoundaries,
        interactiveFlags: InteractiveFlag.all ^ InteractiveFlag.rotate,
        onTap: (_, __) => _popupLayerController.hideAllPopups(),
      ),
      children: [
        _darkModeContainerIfEnabled(
          TileLayer(
            minNativeZoom: HiveSettingsDB.openStreetMapEnabled
                ? MapSettings.minNativeZoom
                : MapSettings.minNativeZoomDefault,
            maxNativeZoom: HiveSettingsDB.openStreetMapEnabled
                ? MapSettings.maxNativeZoom
                : MapSettings.maxNativeZoomDefault,
            minZoom: HiveSettingsDB.openStreetMapEnabled
                ? MapSettings.minZoom
                : MapSettings.minZoomDefault,
            maxZoom: HiveSettingsDB.openStreetMapEnabled
                ? MapSettings.maxZoom
                : MapSettings.maxZoomDefault,
            urlTemplate: HiveSettingsDB.openStreetMapEnabled ||
                    widget.event.hasSpecialStartPoint
                ? MapSettings.openStreetMapLinkString //use own ts
                : 'assets/maptiles/osday/{z}/{x}/{y}.jpg',
            evictErrorTileStrategy:
                EvictErrorTileStrategy.notVisibleRespectMargin,
            tileProvider: HiveSettingsDB.openStreetMapEnabled ||
                    widget.event.hasSpecialStartPoint
                ? CachedTileProvider(errorListener: () {
                    print('CachedTileProvider errorListener');
                  })
                : AssetTileProvider(),
            subdomains: HiveSettingsDB.openStreetMapEnabled ||
                    widget.event.hasSpecialStartPoint
                ? MapSettings.mapLinkSubdomains
                : <String>[],
            errorImage: const AssetImage(
              'assets/images/skatemunichmaperror.png',
            ),
          ),
        ),
        PolylineLayer(
          polylines: widget.polyLines,
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
            popupController: _popupLayerController,

            markerTapBehavior: MarkerTapBehavior.togglePopup(),
            // : MarkerTapBehavior.togglePopupAndHideRest(),
            onPopupEvent: (event, selectedMarkers) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      ],
    );
  }

  Widget _darkModeContainerIfEnabled(Widget child) {
    if (CupertinoTheme.brightnessOf(context) == Brightness.light) {
      return child;
    }

    return bnDarkModeTilesContainerBuilder(context, child);
  }
}

class CachedTileProvider extends TileProvider {
  CachedTileProvider({required Null Function() errorListener});

  @override
  ImageProvider getImage(coordinates, TileLayer options) {
    return CachedNetworkImageProvider(getTileUrl(coordinates, options));
  }
}

class CachedAssetProvider extends TileProvider {
  CachedAssetProvider(
      {required BuildContext context, required Null Function() errorListener});

  @override
  ImageProvider getImage(coordinates, TileLayer options) {
    return AssetImage(getTileUrl(coordinates, options));
  }
}
