import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/event.dart';
import '../../../models/route.dart';
import '../../map/widgets/gps_info_and_map_copyright.dart';
import '../../map/widgets/map_buttons_light.dart';
import '../../map/widgets/map_tile_layer.dart';

///Map layer for events home and mapView
///
///
class MapLayerOverview extends ConsumerStatefulWidget {
  const MapLayerOverview({
    required this.event,
    required this.startPoint,
    required this.finishPoint,
    required this.showSpeed,
    this.location,
    this.markerList = const [],
    this.polyLineList = const [],
    this.controller,
    this.initialZoom = 13,
    this.minZoom = 5,
    this.maxZoom = 19,
    this.interactionOptions = const InteractionOptions(
      flags: InteractiveFlag.all,
      enableMultiFingerGestureRace: true,
    ),
    super.key,
  });

  final LatLng? location;
  final Event event;
  final LatLng startPoint;
  final LatLng finishPoint;
  final bool showSpeed;
  final List<Marker> markerList;
  final List<Polyline> polyLineList;
  final MapController? controller;
  final double initialZoom;
  final double minZoom;
  final double maxZoom;
  final InteractionOptions interactionOptions;

  @override
  ConsumerState<MapLayerOverview> createState() => _MapLayerOverviewState();
}

class _MapLayerOverviewState extends ConsumerState<MapLayerOverview> {
  @override
  Widget build(BuildContext context) {
    LatLngBounds bounds;
    if (MediaQuery.orientationOf(context) == Orientation.portrait) {
      bounds = widget.event.nodes.getBounds;
    } else {
      bounds = widget.event.nodes.getBoundsLandscape;
    }
    var factor = kIsWeb ? 0.6 : 0.4;
    return SizedBox(
      height: MediaQuery.of(context).size.height * factor,
      child: FlutterMap(
          mapController: widget.controller,
          options: MapOptions(
              keepAlive: true,
              initialCameraFit: CameraFit.insideBounds(bounds: bounds),
              initialZoom: widget.initialZoom,
              minZoom: widget.minZoom,
              maxZoom: widget.maxZoom,
              cameraConstraint: CameraConstraint.containCenter(bounds: bounds),
              initialCenter: widget.startPoint,
              /* cameraConstraint: MapSettings.openStreetMapEnabled ||
                    widget.event.hasSpecialStartPoint
                ? const CameraConstraint
                    .unconstrained() //CameraConstraint.contain(bounds: MapSettings.mapOnlineBoundaries)
                : CameraConstraint.contain(
                    bounds: MapSettings.bayernAtlasBoundaries),*/
              interactionOptions: widget.interactionOptions),
          children: [
            MapTileLayer(
                hasSpecialStartPoint: widget.event.hasSpecialStartPoint),
            GPSInfoAndMapCopyright(
              showOdoMeter: false,
              showSpeed: widget.showSpeed,
            ),
            PolylineLayer(
              polylines: widget
                  .polyLineList, // ref.watch(polyLinesProvider),// widget.polyLines,
            ),
            if (widget.markerList.isNotEmpty)
              MarkerLayer(markers: widget.markerList),
            const SafeArea(
                child: MapButtonsLayerLight(
              bottomMargin: 25,
              showHelp: false,
            )),
          ]),
    );
  }
}
