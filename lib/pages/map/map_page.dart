import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../generated/l10n.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/notification/toast_notification.dart';
import '../../models/follow_location_state.dart';
import '../../models/route.dart';
import '../../providers/active_event_provider.dart';
import '../../providers/active_event_route_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/map/use_open_street_map_provider.dart';
import '../widgets/no_connection_warning.dart';
import 'widgets/custom_location_layer.dart';
import 'widgets/gps_info_and_map_copyright.dart';
import 'widgets/headings_layer.dart';
import 'widgets/map_buttons.dart';
import 'widgets/map_tile_layer.dart';
import 'widgets/markers_layer.dart';
import 'widgets/bn_map_page_poly_lines_layer.dart';
import 'widgets/track_progress_overlay.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> with WidgetsBindingObserver {
  late MapController _mapController;
  late CameraFollow followLocationState = CameraFollow.followOff;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final PopupController _popupController = PopupController();

  StreamSubscription<LatLng>? locationSubscription;

  bool _hasGesture = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _popupController.dispose();
    _mapController.dispose();
    locationSubscription?.cancel();
    locationSubscription = null;
    super.dispose();
  }

  void startFollowingTrainHead() {
    locationSubscription?.cancel();
    locationSubscription = null;
    _mapController.move(defaultLatLng, _mapController.camera.zoom);
    locationSubscription = LocationProvider().trainHeadUpdateStream.listen(
      (value) {
        _mapController.move(value, _mapController.camera.zoom);
      },
    );
    ref.read(locationProvider).refreshRealtimeData(forceUpdate: true);
  }

  @override
  Widget build(BuildContext context) {
    print('${DateTime.now().toIso8601String()} Build Fluttermap (map_page)');
    var route = ref.watch(activeEventRouteProvider);
    var osmEnabled = ref.watch(useOpenStreetMapProvider);
    var startPoint = route.hasValue ? route.value!.startLatLng : defaultLatLng;
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: CupertinoPageScaffold(
        child: Stack(children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              keepAlive: true,
              initialZoom: 13.0,
              onMapEvent: (event) {
                //print('${DateTime.now().toIso8601String()} mapevent $event ');
              },
              minZoom:
                  osmEnabled ? MapSettings.minZoom : MapSettings.minZoomDefault,
              maxZoom:
                  osmEnabled ? MapSettings.maxZoom : MapSettings.maxZoomDefault,
              initialCenter: startPoint,
              onPointerDown: (e, l) => _onPointerDown(e, l),
              onPointerUp: (e, l) => _onPointerUp(e, l),
              //onPositionChanged: (p, g) => _onPositionChanged(p, g),
              cameraConstraint: osmEnabled ||
                      ref.watch(activeEventProvider).hasSpecialStartPoint
                  ? CameraConstraint.contain(
                      bounds: MapSettings.mapOnlineBoundaries)
                  : CameraConstraint.contain(
                      bounds: MapSettings.bayernAtlasBoundaries),
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
                enableMultiFingerGestureRace: true,
              ),
              onTap: (_, __) => _popupController.hideAllPopups(),
            ),
            children: [
              const MapTileLayer(),
              Builder(builder: (context) {
                print(
                    '${DateTime.now().toIso8601String()} Build Fluttermap children');
                return Stack(
                  children: [
                    MouseRegion(
                      hitTestBehavior: HitTestBehavior.deferToChild,
                      cursor: SystemMouseCursors.click,
                      // Use a special cursor to indicate interactivity
                      child: GestureDetector(
                        onTap: () {
                          final LayerHitResult? hitResult = hitNotifier.value;
                          if (hitResult == null) return;
                          // If running frequently (such as on a hover handler), and heavy work or state changes are performed here, store each result so it can be compared to the newest result, then avoid work if they are equal
                          for (final hitValue in hitResult.hitValues) {
                            showToast(
                                message:
                                    '${Localize.current.speed} $hitValue km/h');

                            break;
                          }
                        },
                        child: const BnMapPagePolyLinesLayer(),
                      ),
                    ),

                    //CurrentLocationLayer(),
                    /*AnimatedLocationMarkerLayer(
                position: LocationMarkerPosition(
                    latitude: ref.watch(realtimeDataProvider)!.head.latitude!,
                    longitude: ref.watch(realtimeDataProvider)!.head.longitude!,
                    accuracy: 1.0
                ),
              ),*/
                    const HeadingsLayer(),
                    //SpecialPointsLayer(_popupController), //crashes with global key multi usage on open Popup
                    CustomLocationLayer(_hasGesture),
                    //needs map controller
                    MarkersLayer(_popupController),

                    TrackProgressOverlay(_mapController),
                    const MapButtonsLayer(),
                  ],
                );
              }),
              //CurrentLocationLayer(),
            ],
          ),
          const GPSInfoAndMapCopyright(),
          const SafeArea(
            child: Align(
                alignment: Alignment.topCenter, child: ConnectionWarning()),
          ),
        ]),
      ),
    );
  }

  /// Disable align position and align direction temporarily when user is
  /// manipulating the map.
  int _pointerCount = 0;

  void _onPointerDown(e, l) {
    _pointerCount++;
    setState(() {
      _hasGesture = true;
    });
  }

  // Enable align position and align direction again when user manipulation
  // ended.
  void _onPointerUp(e, l) {
    if (--_pointerCount <= 0) {
      setState(() {
        _hasGesture = false;
      });
    }
  }
}
