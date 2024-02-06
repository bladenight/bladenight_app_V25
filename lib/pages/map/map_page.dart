import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../app_settings/app_constants.dart';
import '../../generated/l10n.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/logger.dart';
import '../../models/follow_location_state.dart';
import '../../models/route.dart';
import '../../providers/active_event_notifier_provider.dart';
import '../../providers/is_tracking_provider.dart';
import '../../providers/location_provider.dart';
import 'widgets/custom_location_layer.dart';
import 'widgets/map_buttons.dart';
import 'widgets/map_tile_layer.dart';
import 'widgets/markers_layer.dart';
import 'widgets/poly_lines.dart';
import 'widgets/track_progress_overlay.dart';
import 'widgets/gps_info_and_map_copyright.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> with WidgetsBindingObserver {
  late MapController controller;
  late List<Marker> mapMarker = [];
  late FollowLocationStates followLocationState =
      FollowLocationStates.followOff;
  bool _webStartedTrainFollow = false;
  Timer? _updateRealTimeDataTimer;
  bool _firstRefresh = true;

  ProviderSubscription<AsyncValue<LatLng?>>? locationSubscription;

  @override
  void initState() {
    super.initState();
    controller = MapController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    pauseUpdates();
    WidgetsBinding.instance.removeObserver(this);
    _popupController.dispose();
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
      BnLog.trace(
        className: toString(),
        methodName: 'didChangeAppLifecycleState',
        text: 'resume updates calling',
      );
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

  void resumeUpdates({bool force = false}) {
    _updateRealTimeDataTimer?.cancel();
    if (force || _firstRefresh) {
      print('_firstRefresh resumeUpdates');
      ref.read(locationProvider).refresh(forceUpdate: force);
      _firstRefresh = false;
    }
    //update data if not tracking
    _updateRealTimeDataTimer = Timer.periodic(
      //realtimeUpdateProvider reads data on send-location - so it must not updated all 10 secs
      const Duration(seconds: defaultRealtimeUpdateInterval),
      (timer) {
        ///TODO subscribe event procession
        /* if (ActiveEventProvider.instance.event.status != EventStatus.confirmed && !kIsWeb) {
          return;
        }*/
        if (kIsWeb & !_webStartedTrainFollow) {
          startFollowingTrainHead();
          _webStartedTrainFollow = true;
        }

        ref.read(locationProvider).refreshRealtimeData();
      },
    );
  }

  void pauseUpdates() {
    if (!kIsWeb) {
      BnLog.trace(
          className: toString(),
          methodName: 'pauseUpdates',
          text: 'update Paused');
    }
    _updateRealTimeDataTimer?.cancel();
    _updateRealTimeDataTimer = null;
  }

  void startFollowingMeLocation() {
    locationSubscription?.close();
    locationSubscription = null;

    controller.move(LocationProvider.instance.userLatLng ?? defaultLatLng,
        controller.camera.zoom);
    locationSubscription = context.subscribe<AsyncValue<LatLng?>>(
      locationUpdateProvider,
      (_, value) {
        if (value.value != null) {
          controller.move(value.value!, controller.camera.zoom);
        }
      },
      fireImmediately: true,
    );
    setState(() {
      followLocationState = FollowLocationStates.followMe;
    });
    ref.read(locationProvider).refresh(forceUpdate: true);
  }

  void startFollowingTrainHead() {
    locationSubscription?.close();
    locationSubscription = null;
    controller.move(defaultLatLng, controller.camera.zoom);
    locationSubscription = context.subscribe<AsyncValue<LatLng?>>(
      locationTrainHeadUpdateProvider,
      (_, value) {
        if (value.value != null) {
          controller.move(value.value!, controller.camera.zoom);
        }
      },
      fireImmediately: true,
    );
    ref.read(locationProvider).refresh(forceUpdate: true);
  }

  void stopFollowingLocation() async {
    locationSubscription?.close();
    locationSubscription = null;
    setState(() {});
  }

  void moveMapToDefault() {
    controller.move(defaultLatLng, controller.camera.zoom);
  }

  ///Toggles between location tracking and view without user pos

  void toggleLocationService() async {
    ref.read(isTrackingProvider.notifier).toggleTracking(true);
  }

  ///Toggles between user position and view with user pos
  void toggleViewerLocationService() async {

    if (ref.read(isTrackingProvider)) {
      ref.read(isTrackingProvider.notifier).toggleTracking(false);
      return;
    }
    final clickedButton = await FlutterPlatformAlert.showCustomAlert(
        windowTitle: Localize.of(context).startLocationWithoutParticipating,
        text: Localize.of(context).startLocationWithoutParticipatingInfo,
        positiveButtonTitle: Localize.of(context).yes,
        negativeButtonTitle:
            Localize.of(context).no); //no neutral button on android
    if (clickedButton == CustomButton.positiveButton) {

      ref.read(isTrackingProvider.notifier).toggleTracking(false);
    }
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final PopupController _popupController = PopupController();

  @override
  Widget build(BuildContext context) {
    print('rebuilding flutter_maps');
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: CupertinoPageScaffold(
        child: Stack(children: [

          FlutterMap(
            mapController: controller,
            options: MapOptions(
              keepAlive: true,
              initialZoom: 13.0,
              minZoom: HiveSettingsDB.openStreetMapEnabled
                  ? MapSettings.minZoom
                  : MapSettings.minZoomDefault,
              maxZoom: HiveSettingsDB.openStreetMapEnabled
                  ? MapSettings.maxZoom
                  : MapSettings.maxZoomDefault,
              initialCenter: ref.watch(activeEventProvider).startPoint,
              cameraConstraint: kDebugMode
                  ? null
                  : HiveSettingsDB.openStreetMapEnabled ||
                          ref
                              .watch(activeEventProvider)
                              .event
                              .hasSpecialStartPoint
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
              const PolyLinesLayer(),
              /*AnimatedLocationMarkerLayer(
                position: LocationMarkerPosition(
                    latitude: ref.watch(realtimeDataProvider)!.head.latitude!,
                    longitude: ref.watch(realtimeDataProvider)!.head.longitude!,
                    accuracy: 1.0),
              ),*/
              const CustomLocationLayer(),
              //needs map controller
              MarkersLayer(_popupController),
              TrackProgressOverlay(controller),
              const MapButtonsLayer(),
            ],
          ),
          const GPSInfoAndMapCopyright(),
        ]),
      ),
    );
  }
}
