import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
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
import '../../providers/location_provider.dart';
import '../../providers/shared_prefs_provider.dart';
import '../widgets/user_speed_odometer.dart';
import 'widgets/bn_dark_container.dart';
import 'widgets/custom_location_layer.dart';
import 'widgets/map_buttons.dart';

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
  Timer? _updateTimer;
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
    _popupLayerController.dispose();
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
    _updateTimer?.cancel();
    if (force || _firstRefresh) {
      print('_firstRefresh resumeUpdates');
      ref.read(locationProvider).refresh(forceUpdate: force);
      _firstRefresh = false;
    }
    //update data if not tracking
    _updateTimer = Timer.periodic(
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
    _updateTimer?.cancel();
    _updateTimer = null;
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
    await LocationProvider.instance
        .toggleProcessionTracking(userIsParticipant: true);
  }

  ///Toggles between user position and view with user pos
  void toggleViewerLocationService() async {
    if (LocationProvider.instance.isTracking) {
      await LocationProvider.instance
          .toggleProcessionTracking(userIsParticipant: false);
      return;
    }
    final clickedButton = await FlutterPlatformAlert.showCustomAlert(
        windowTitle: Localize.of(context).startLocationWithoutParticipating,
        text: Localize.of(context).startLocationWithoutParticipatingInfo,
        positiveButtonTitle: Localize.of(context).yes,
        negativeButtonTitle:
            Localize.of(context).no); //no neutral button on android
    if (clickedButton == CustomButton.positiveButton) {
      await LocationProvider.instance
          .toggleProcessionTracking(userIsParticipant: false);
    }
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final PopupController _popupLayerController = PopupController();

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
              cameraConstraint: HiveSettingsDB.openStreetMapEnabled ||
                      ref.watch(activeEventProvider).event.hasSpecialStartPoint
                  ? CameraConstraint.contain(
                      bounds: MapSettings.mapOnlineBoundaries)
                  : CameraConstraint.contain(
                      bounds: MapSettings.mapOfflineBoundaries),
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
                enableMultiFingerGestureRace: true,
              ),
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
                          ref
                              .watch(activeEventProvider)
                              .event
                              .hasSpecialStartPoint
                      ? MapSettings.openStreetMapLinkString //use own ts
                      : 'assets/maptiles/osday/{z}/{x}/{y}.jpg',
                  evictErrorTileStrategy:
                      EvictErrorTileStrategy.notVisibleRespectMargin,
                  tileProvider: HiveSettingsDB.openStreetMapEnabled ||
                          ref
                              .watch(activeEventProvider)
                              .event
                              .hasSpecialStartPoint
                      ? CancellableNetworkTileProvider()
                      : AssetTileProvider(),
                  errorImage: const AssetImage(
                    'assets/images/skatemunichmaperror.png',
                  ),
                ),
              ),
              PolylineLayer(polylines: [
                Polyline(
                  //active route points
                  points: ref.watch(activeEventProvider).activeEventRoutePoints,
                  strokeWidth: ref.watch(isTrackingProvider) ? 5 : 3,
                  borderColor: ref.watch(isTrackingProvider)
                      ? const CupertinoDynamicColor.withBrightness(
                          color: CupertinoColors.activeGreen,
                          darkColor: CupertinoColors.white)
                      : CupertinoTheme.of(context).primaryColor,
                  color: ref.watch(isTrackingProvider)
                      ? const CupertinoDynamicColor.withBrightness(
                          color: CupertinoColors.white,
                          darkColor: CupertinoColors.lightBackgroundGray)
                      : Colors.transparent,
                  useStrokeWidthInMeter: true,
                  borderStrokeWidth: ref.watch(isTrackingProvider) ? 4 : 7,
                  isDotted: false, //ref.watch(isTrackingProvider),
                ),
                //user track
                if (ref.watch(userLatLongProvider).isNotEmpty &&
                    ref.watch(ShowOwnTrack.provider))
                  Polyline(
                    points: ref.watch(userLatLongProvider),
                    strokeWidth: ref.watch(isTrackingProvider) ? 4 : 3,
                    borderColor: ref.watch(MeColor.provider),
                    color: ref.watch(isTrackingProvider)
                        ? const CupertinoDynamicColor.withBrightness(
                            color: CupertinoColors.white,
                            darkColor: CupertinoColors.systemBlue)
                        : CupertinoColors.white,
                    borderStrokeWidth: 3.0,
                    isDotted: false, // ref.watch(isTrackingProvider),
                  ),
                if (context
                    .watch(activeEventProvider)
                    .activeEventRoutePoints
                    .isNotEmpty)
                  Polyline(
                      points: context
                          .watch(activeEventProvider)
                          .activeEventRoutePoints,
                      color: CupertinoDynamicColor.withBrightness(
                          color: ref.watch(ThemePrimaryColor.provider),
                          darkColor: ref.watch(ThemePrimaryDarkColor.provider)),
                      strokeWidth: 3,
                      borderStrokeWidth: 5.0,
                      isDotted: true),
              ]),

              //const TrackProgressOverlay(),
              const MapButtonsOverlay(),
              const CustomLocationLayer(),
            ],
          ),
          const UserSpeedAndOdometer(),
        ]),
      ),
    );
  }

  Widget _darkModeContainerIfEnabled(Widget child) {
    if (CupertinoTheme.brightnessOf(context) == Brightness.light) {
      return child;
    }

    return bnDarkModeTilesContainerBuilder(context, child);
  }
}
