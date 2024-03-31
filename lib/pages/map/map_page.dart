import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/logger.dart';
import '../../models/follow_location_state.dart';
import '../../models/route.dart';
import '../../providers/active_event_provider.dart';
import '../../providers/active_event_route_provider.dart';
import '../../providers/is_tracking_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/map/use_open_street_map_provider.dart';
import '../widgets/no_connection_warning.dart';
import 'widgets/custom_location_layer.dart';
import 'widgets/gps_info_and_map_copyright.dart';
import 'widgets/headings_layer.dart';
import 'widgets/map_buttons.dart';
import 'widgets/map_tile_layer.dart';
import 'widgets/markers_layer.dart';
import 'widgets/poly_lines.dart';
import 'widgets/special_points_layer.dart';
import 'widgets/track_progress_overlay.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> with WidgetsBindingObserver {
  late MapController _mapController;
  late CameraFollow followLocationState = CameraFollow.followOff;
  Timer? _updateRealTimeDataTimer;
  bool _firstRefresh = true;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final PopupController _popupController = PopupController();

  ProviderSubscription<AsyncValue<LatLng?>>? locationSubscription;

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
    pauseUpdates();
    WidgetsBinding.instance.removeObserver(this);
    _popupController.dispose();
    _mapController.dispose();
    locationSubscription?.close();
    locationSubscription = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (Platform.isAndroid || Platform.isIOS) {
      if (!kIsWeb) {
        BnLog.debug(text: 'map_page - didChangeAppLifecycleState $state');
      }
    }
    if (state == AppLifecycleState.resumed) {
      resumeUpdates(force: true);
      LocationProvider.instance.setToBackground(false);
    } else if (state == AppLifecycleState.paused) {
      LocationProvider.instance.setToBackground(true);
      if (!kIsWeb) {
        BnLog.trace(
            className: 'resumeUpdates',
            methodName: 'timer',
            text: 'LocProvider instance pause updates calling');
      }
      pauseUpdates();
    }
  }

  void resumeUpdates({bool force = false}) async {
    BnLog.trace(
      className: toString(),
      methodName: 'didChangeAppLifecycleState',
      text: 'resume updates calling',
    );
    _updateRealTimeDataTimer?.cancel(); //important
    if (force || _firstRefresh) {
      ref.read(locationProvider).refresh(forceUpdate: force);
      _firstRefresh = false;
    }
    //update data if not tracking
    /*_updateRealTimeDataTimer = Timer.periodic(
      //realtimeUpdateProvider reads data on send-location - so it must not updated all 10 secs
      const Duration(milliseconds: defaultRealtimeUpdateInterval),
      (timer) {
        if (kIsWeb & !_webStartedTrainFollow) {
          startFollowingTrainHead();
          _webStartedTrainFollow = true;
        }
        ref.read(realtimeDataProvider.notifier).refresh();
      },
    );*/
  }

  void pauseUpdates() async {
    BnLog.trace(
      className: toString(),
      methodName: 'didChangeAppLifecycleState',
      text: 'resume updates calling',
    );
    if (!kIsWeb) {
      BnLog.trace(
          className: toString(),
          methodName: 'pauseUpdates',
          text: 'update Paused');
    }
    _updateRealTimeDataTimer?.cancel();
    _updateRealTimeDataTimer = null;
  }

  void startFollowingTrainHead() {
    locationSubscription?.close();
    locationSubscription = null;
    _mapController.move(defaultLatLng, _mapController.camera.zoom);
    locationSubscription = context.subscribe<AsyncValue<LatLng?>>(
      locationTrainHeadUpdateProvider,
      (_, value) {
        if (value.value != null) {
          _mapController.move(value.value!, _mapController.camera.zoom);
        }
      },
      fireImmediately: true,
    );
    ref.read(locationProvider).refresh(forceUpdate: true);
  }

  @override
  Widget build(BuildContext context) {
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
                      bounds: MapSettings.mapOfflineBoundaries),
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
                enableMultiFingerGestureRace: true,
              ),
              onTap: (_, __) => _popupController.hideAllPopups(),
            ),
            children: [
              const MapTileLayer(),
              Builder(builder: (context) {
                return Stack(
                  children: [
                    const PolyLinesLayer(),
                    // CurrentLocationLayer(),
                    /*AnimatedLocationMarkerLayer(
                position: LocationMarkerPosition(
                    latitude: ref.watch(realtimeDataProvider)!.head.latitude!,
                    longitude: ref.watch(realtimeDataProvider)!.head.longitude!,
                    accuracy: 1.0
                ),
              ),*/
                    const HeadingsLayer(),
                    SpecialPointsLayer(_popupController),
                    CustomLocationLayer(_popupController, _hasGesture),
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

  /// TODO
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

  _onPositionChanged(MapPosition p, bool g) {
    if (ref.read(isTrackingProvider)) {
      setState(() {
        _hasGesture = g;
      });
    }
  }
}
