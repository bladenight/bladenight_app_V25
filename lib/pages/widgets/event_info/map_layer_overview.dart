import 'package:flutter/cupertino.dart';
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
    this.markers = const [],
    this.polylines = const [],
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
  final List<Marker> markers;
  final List<Polyline> polylines;
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
    var bounds = widget.event.nodes.getBounds;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: FlutterMap(
          mapController: widget.controller,
          options: MapOptions(
              keepAlive: true,
              initialCameraFit: CameraFit.insideBounds(bounds: bounds),
              initialZoom: widget.initialZoom,
              minZoom: widget.minZoom,
              maxZoom: widget.maxZoom,
              //initialCenter: widget.startPoint,
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
                  .polylines, // ref.watch(polyLinesProvider),// widget.polyLines,
            ),
            MarkerLayer(markers: widget.markers),
            const SafeArea(
                child: MapButtonsLayerLight(
              bottomMargin: 25,
              showHelp: false,
            )),
          ]),
    );
  }
}
