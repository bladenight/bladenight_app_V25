import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  const MapLayer({required this.event,
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
        zoom: 13.0,
        minZoom: 5,
        maxZoom: HiveSettingsDB.openStreetMapEnabled ? 18 : 18,
        center: widget.startPoint,
        maxBounds: HiveSettingsDB.openStreetMapEnabled ||
            widget.event.hasSpecialStartPoint
            ? null
            : LatLngBounds.fromPoints([
          LatLng(kIsWeb ? 47.9579 : 48.0570, kIsWeb ? 11.8213 : 11.4416),
          LatLng(kIsWeb ? 48.2349 : 48.2349, kIsWeb ? 11.2816 : 11.6213),
        ]),
        interactiveFlags: InteractiveFlag.all ^ InteractiveFlag.rotate,
        onTap: (_, __) => _popupLayerController.hideAllPopups(),
      ),
      children: [
        _darkModeContainerIfEnabled(
          TileLayer(
            minNativeZoom: 5,
            maxNativeZoom: HiveSettingsDB.openStreetMapEnabled ? 15 : 15,
            urlTemplate: HiveSettingsDB.openStreetMapEnabled ||
                widget.event.hasSpecialStartPoint
                ? HiveSettingsDB.openStreetMapLinkString
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
                ? ['a', 'b', 'c']
                : <String>[],
            errorImage: const AssetImage(
              'assets/images/skatemunichmaperror.png',
            ),
          ),
        ),
        PolylineLayer(
          polylines: widget.polyLines,
        ),
        PopupMarkerLayerWidget(
          options: PopupMarkerLayerOptions(
            popupSnap: PopupSnap.markerBottom,
            markerCenterAnimation: const MarkerCenterAnimation(),
            markers: widget.markers,
            popupController: _popupLayerController,
            popupBuilder: (BuildContext context, Marker marker) {
              if (marker is BnMapMarker) {
                return MapMarkerPopup(marker);
              } else if (marker is BnMapFriendMarker) {
                return MapFriendMarkerPopup(marker);
              }
              return Container();
            },
            popupAnimation: const PopupAnimation.fade(
                duration: Duration(milliseconds: 200)),
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
