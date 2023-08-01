import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show AsyncValue, AsyncValueX, ProviderSubscription;
import 'package:latlong2/latlong.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../app_settings/app_constants.dart';
import '../../generated/l10n.dart';
import '../../helpers/background_location_helper.dart';
import '../../helpers/distance_converter.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/location_permission_dialogs.dart';
import '../../helpers/notification/toast_notification.dart';
import '../../helpers/speed_to_color.dart';
import '../../helpers/timeconverter_helper.dart';
import '../../helpers/url_launch_helper.dart';
import '../../models/bn_map_friend_marker.dart';
import '../../models/bn_map_marker.dart';
import '../../models/event.dart';
import '../../models/route.dart';
import '../../pages/widgets/following_location_icon.dart';
import '../../providers/active_event_notifier_provider.dart';
import '../../providers/images_and_links/live_map_image_and_link_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/route_providers.dart';
import '../../providers/shared_prefs_provider.dart';
import 'widgets/map_layer.dart';
import 'widgets/qr_create_page.dart';
import 'widgets/track_progress_overlay.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

enum FollowLocationStates {
  followOff,
  followMe,
  followMeStopped,
  followTrain,
  followTrainStopped
}

class _MapPageState extends State<MapPage> with WidgetsBindingObserver {
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
    //LocationProvider.instance.addListener(resumeUpdates); //on changed resume update
  }

  @override
  void dispose() {
    pauseUpdates();
    WidgetsBinding.instance.removeObserver(this);
    //LocationProvider.instance.removeListener(resumeUpdates);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (Platform.isAndroid || Platform.isIOS) {
      if (!kIsWeb) {
        FLog.debug(text: 'map_page - didChangeAppLifecycleState $state');
      }
    }
    if (state == AppLifecycleState.resumed) {
      resumeUpdates(force: true);
      LocationProvider.instance.setToBackground(false);
      if (!kIsWeb) {
        FLog.trace(
          className: toString(),
          methodName: 'didChangeAppLifecycleState',
          text: 'resume updates calling',
        );
      }
    } else if (state == AppLifecycleState.paused) {
      LocationProvider.instance.setToBackground(true);
      if (!kIsWeb) {
        FLog.trace(
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
      context.read(locationProvider).refresh(forceUpdate: force);
      _firstRefresh = false;
    }
    //update data if not tracking
    _updateTimer = Timer.periodic(
      //realtimeUpdateProvider reads data on send-location - so it must not updated all 10 secs
      const Duration(seconds: defaultRealtimeUpdateInterval),
      (timer) {
        ///TODO subscribe eventprocession
        /* if (ActiveEventProvider.instance.event.status != EventStatus.confirmed && !kIsWeb) {
          return;
        }*/
        if (kIsWeb & !_webStartedTrainFollow) {
          startFollowingTrainHead();
          _webStartedTrainFollow = true;
        }
        int lastUpdate = DateTime.now()
            .difference(LocationProvider.instance.lastUpdate)
            .inSeconds;
        if (!LocationProvider.instance.isTracking ||
            lastUpdate >= defaultRealtimeUpdateInterval) {
          //refresh only when not tracking
          if (!kIsWeb) {
            FLog.trace(
                className: toString(),
                methodName: '_updateTime_periodic',
                text: 'updating because there are no new location data');
          }
          context.read(locationProvider).refresh();
        }
      },
    );
  }

  void pauseUpdates() {
    if (!kIsWeb) {
      FLog.trace(
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

    controller.move(
        LocationProvider.instance.userLatLng ?? defaultLatLng, controller.zoom);
    locationSubscription = context.subscribe<AsyncValue<LatLng?>>(
      locationUpdateProvider,
      (_, value) {
        if (value.value != null) {
          controller.move(value.value!, controller.zoom);
        }
      },
      fireImmediately: true,
    );
    setState(() {
      followLocationState = FollowLocationStates.followMe;
    });
    context.read(locationProvider).refresh(forceUpdate: true);
  }

  void startFollowingTrainHead() {
    locationSubscription?.close();
    locationSubscription = null;
    controller.move(defaultLatLng, controller.zoom);
    locationSubscription = context.subscribe<AsyncValue<LatLng?>>(
      locationTrainHeadUpdateProvider,
      (_, value) {
        if (value.value != null) {
          controller.move(value.value!, controller.zoom);
        }
      },
      fireImmediately: true,
    );
    context.read(locationProvider).refresh(forceUpdate: true);
  }

  void stopFollowingLocation() async {
    locationSubscription?.close();
    locationSubscription = null;
    setState(() {});
  }

  void moveMapToDefault() {
    controller.move(defaultLatLng, controller.zoom);
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

  void _showLiveMapLink(String? link) {
    QRCreatePage.show(
        context: context,
        qrcodetext: link ?? liveMapLink,
        headertext: Localize.of(context).liveMapInBrowserInfoHeader,
        infotext: Localize.of(context).liveMapInBrowser);
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    //print('build Fluttermaps');
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: CupertinoPageScaffold(
        child: Stack(children: [
          Builder(
            builder: (context) {
              var locationUpdate = context.watch(locationProvider);
              var activeEvent = context.watch(activeEventProvider);
              var runningRoutePoints = locationUpdate.realtimeUpdate
                  ?.runningRoute(activeEvent.activeEventRoutePoints);
              var headingRoutePoints = activeEvent.headingPoints;
              var sizeValue = MediaQuery.of(context).textScaleFactor *
                  HiveSettingsDB.iconSizeValue;
              return MapLayer(
                event: activeEvent.event,
                startPoint: activeEvent.startPoint,
                finishPoint: activeEvent.finishPoint,
                polyLines: [
                  Polyline(
                    //active route points
                    points: activeEvent.activeEventRoutePoints,
                    strokeWidth: locationUpdate.isTracking ? 5 : 3,
                    borderColor: locationUpdate.isTracking
                        ? const CupertinoDynamicColor.withBrightness(
                            color: CupertinoColors.activeGreen,
                            darkColor: CupertinoColors.white)
                        : CupertinoTheme.of(context).primaryColor,
                    color: locationUpdate.isTracking
                        ? const CupertinoDynamicColor.withBrightness(
                            color: CupertinoColors.white,
                            darkColor: CupertinoColors.lightBackgroundGray)
                        : Colors.transparent,
                    useStrokeWidthInMeter: true,
                    borderStrokeWidth: locationUpdate.isTracking ? 4 : 7,
                    isDotted: false, //ref.watch(isTrackingProvider),
                  ),
                  //user track
                  if (locationUpdate.userLatLongs.isNotEmpty &&
                      context.watch(ShowOwnTrack.provider))
                    Polyline(
                      points: locationUpdate.userLatLongs,
                      strokeWidth: locationUpdate.isTracking ? 4 : 3,
                      borderColor: context.watch(MeColor.provider),
                      color: context.watch(isTrackingProvider)
                          ? const CupertinoDynamicColor.withBrightness(
                              color: CupertinoColors.white,
                              darkColor: CupertinoColors.systemBlue)
                          : CupertinoColors.white,
                      borderStrokeWidth: 3.0,
                      isDotted: false, // ref.watch(isTrackingProvider),
                    ),
                  if (runningRoutePoints != null &&
                      runningRoutePoints.isNotEmpty)
                    Polyline(
                        points: runningRoutePoints,
                        color: CupertinoDynamicColor.withBrightness(
                            color: context.watch(ThemePrimaryColor.provider),
                            darkColor:
                                context.watch(ThemePrimaryDarkColor.provider)),
                        strokeWidth: 3,
                        borderStrokeWidth: 5.0,
                        isDotted: true),
                ],
                markers: [
                  //Direction arrows
                  if (headingRoutePoints.isNotEmpty) ...[
                    for (var hp in headingRoutePoints)
                      Marker(
                        width: 20,
                        height: 20,
                        point: hp.latLng,
                        builder: (context) => Transform.rotate(
                          angle: hp.bearing,
                          child: const Image(
                            image: AssetImage(
                              'assets/images/arrow_up.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                  // RoutePoints
                  if (runningRoutePoints != null) ...[
                    if (runningRoutePoints.isNotEmpty)
                      BnMapMarker(
                        buildContext: context,
                        headerText: Localize.of(context).tail,
                        speedText:
                            '${((locationUpdate.realtimeUpdate?.tail.speed) ?? '-')} km/h',
                        drivenDistanceText:
                            '${((locationUpdate.realtimeUpdate?.tail.position) ?? '-')} m',
                        timeToHeadText:
                            '${(TimeConverter.millisecondsToDateTimeString(value: locationUpdate.realtimeUpdate?.timeTrainComplete() ?? 0))}',
                        distanceToHeadText:
                            '${((locationUpdate.realtimeUpdate?.distanceOfTrainComplete()) ?? '-')} m',
                        timeUserToTailText:
                            '${(TimeConverter.millisecondsToDateTimeString(value: locationUpdate.realtimeUpdate?.timeUserToTail() ?? 0))}',
                        distanceUserToTailText:
                            '${((locationUpdate.realtimeUpdate?.distanceOfUserToTail()) ?? '-')} m',
                        color: Colors.orange,
                        point: runningRoutePoints.last,
                        width: sizeValue,
                        height: sizeValue,
                        builder: (context) => const Image(
                          image: AssetImage(
                            'assets/images/skatechildmunichred.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                  ], //end tail marker
                  //arrows for drive Direction
                  //end heading marker
                  if (runningRoutePoints != null) ...[
                    if (runningRoutePoints.isNotEmpty)
                      //Skater head marker -set as 2nd because tail overlay drawn first
                      BnMapMarker(
                        buildContext: context,
                        headerText: Localize.of(context).head,
                        speedText:
                            '${((locationUpdate.realtimeUpdate?.head.speed) ?? '-')} km/h',
                        drivenDistanceText:
                            '${((locationUpdate.realtimeUpdate?.head.position) ?? '-')} m',
                        distanceTailText:
                            '${((locationUpdate.realtimeUpdate?.distanceOfTrainComplete()) ?? '-')} m',
                        timeToTailText:
                            '${(TimeConverter.millisecondsToDateTimeString(value: locationUpdate.realtimeUpdate?.timeTrainComplete() ?? 0))}',
                        timeUserToHeadText:
                            '${(TimeConverter.millisecondsToDateTimeString(value: locationUpdate.realtimeUpdate?.timeUserToHead() ?? 0))}',
                        distanceUserToHeadText:
                            '${((locationUpdate.realtimeUpdate?.distanceOfUserToHead()) ?? '-')} m',
                        color: Colors.lightBlue,
                        point: runningRoutePoints.first,
                        width: sizeValue,
                        height: sizeValue,
                        builder: (context) => const Image(
                          image: AssetImage(
                            'assets/images/skatechildmunich.png',
                          ),
                        ),
                      ),
                  ],
                  //End SkaterHeadMarker
                  //finishMarker
                  if (runningRoutePoints != null &&
                      runningRoutePoints.isNotEmpty) ...[
                    BnMapMarker(
                      buildContext: context,
                      headerText: Localize.of(context).finish,
                      anchorPosition: AnchorPos.align(AnchorAlign.bottom),
                      color: Colors.red,
                      width: 35.0,
                      height: 35.0,
                      point: activeEvent.activeEventRoutePoints.last,
                      builder: (context) => const Stack(
                        children: [
                          Image(
                            image: AssetImage(
                              'assets/images/finishMarker.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ],
                  //StartMarker
                  if (runningRoutePoints != null &&
                      runningRoutePoints.isNotEmpty) ...[
                    BnMapMarker(
                      buildContext: context,
                      headerText: Localize.of(context).start,
                      anchorPosition: AnchorPos.align(AnchorAlign.top),
                      color: Colors.transparent,
                      width: 35.0,
                      height: 35.0,
                      point: activeEvent.activeEventRoutePoints.first,
                      builder: (context) => const Stack(
                        children: [
                          Image(
                            image: AssetImage(
                              'assets/images/startMarker.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (locationUpdate.realtimeUpdate != null &&
                      locationUpdate.userLatLng != null)
                    for (var friend in locationUpdate.realtimeUpdate!
                        .mapPointFriends(
                            locationUpdate.realtimeUpdate!.friends))

                      //Friends are only in [RealTimeData] available when we send an new user position to server.
                      //Friend has to stay visible when online - replace on offline message after send location
                      //collect friend list to check where online is, leave it in Marker list
                      BnMapFriendMarker(
                        friend: friend,
                        point: LatLng(friend.latitude ?? defaultLatitude,
                            friend.longitude ?? defaultLongitude),
                        width: friend.specialValue == 99
                            ? sizeValue - 8
                            : sizeValue,
                        height: friend.specialValue == 99
                            ? sizeValue - 8
                            : sizeValue,
                        builder: (context) {
                          if (HiveSettingsDB.wantSeeFullOfProcession &&
                              friend.specialValue == 1) {
                            return Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: SpeedToColor.getColorFromSpeed(
                                      friend.realSpeed),
                                  shape: BoxShape.circle),
                              child: const CircleAvatar(
                                backgroundImage: AssetImage(
                                    'assets/images/skatechildmunichgreen.png'),
                              ),
                            );
                          }
                          if (HiveSettingsDB.wantSeeFullOfProcession &&
                              friend.specialValue == 2) {
                            return Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: SpeedToColor.getColorFromSpeed(
                                      friend.realSpeed),
                                  shape: BoxShape.circle),
                              child: CircleAvatar(
                                radius: sizeValue - 6,
                                backgroundImage: const AssetImage(
                                    'assets/images/skatechildmunichred.png'),
                              ),
                            );
                          }
                          if (HiveSettingsDB.wantSeeFullOfProcession &&
                              friend.specialValue == 99) {
                            return Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: CircleAvatar(
                                radius: sizeValue - 6,
                                backgroundColor: SpeedToColor.getColorFromSpeed(
                                        friend.realSpeed)
                                    .withOpacity(0.4),
                                child: Container(),
                              ),
                            );
                          }
                          return CircleAvatar(
                            radius: sizeValue,
                            backgroundColor: friend.color,
                            child: Center(
                                child: Text(friend.name.substring(0, 1))),
                          );
                        },
                      ),
                  if (locationUpdate.userLatLng != null &&
                      context.watch(isTrackingProvider))
                    //MeMarker
                    BnMapMarker(
                        buildContext: context,
                        headerText: '${Localize.of(context).me} '
                            '${locationUpdate.isHead ? "${Localize.of(context).iam} ${Localize.of(context).head}" : ''} '
                            '${locationUpdate.isTail ? "${Localize.of(context).iam} ${Localize.of(context).tail}" : ''} ',
                        speedText:
                            '${locationUpdate.realUserSpeedKmh == null ? '- km/h' : locationUpdate.realUserSpeedKmh.formatSpeedKmH()} ∑${locationUpdate.odometer.toStringAsFixed(1)} km',
                        drivenDistanceText:
                            '${((locationUpdate.realtimeUpdate?.user.position) ?? '-')} m',
                        timeUserToHeadText:
                            '${(TimeConverter.millisecondsToDateTimeString(value: locationUpdate.realtimeUpdate?.timeUserToHead() ?? 0))}',
                        distanceUserToHeadText:
                            '${((locationUpdate.realtimeUpdate?.distanceOfUserToHead()) ?? '-')} m',
                        timeUserToTailText:
                            '${(TimeConverter.millisecondsToDateTimeString(value: locationUpdate.realtimeUpdate?.timeUserToTail() ?? 0))}',
                        distanceUserToTailText:
                            '${((locationUpdate.realtimeUpdate?.distanceOfUserToTail()) ?? '-')} m',
                        color: context.watch(MeColor.provider),
                        point: locationUpdate.userLatLng!,
                        width: sizeValue,
                        height: sizeValue,
                        builder: (context) {
                          if (locationUpdate.isHead) {
                            return Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              child: CircleAvatar(
                                radius: sizeValue - 5,
                                backgroundImage: const AssetImage(
                                    'assets/images/skaterIcon_256.png'),
                                backgroundColor: context
                                    .watch(MeColor.provider)
                                    .withOpacity(0.6),
                              ),
                            );
                          } else if (locationUpdate.isTail) {
                            return Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: Colors.purple, shape: BoxShape.circle),
                              child: CircleAvatar(
                                radius: sizeValue - 5,
                                backgroundImage: const AssetImage(
                                    'assets/images/skaterIcon_256.png'),
                                backgroundColor: context
                                    .watch(MeColor.provider)
                                    .withOpacity(0.6),
                              ),
                            );
                          }
                          return CircleAvatar(
                            backgroundColor: context
                                .watch(MeColor.provider)
                                .withOpacity(0.6),
                            child: locationUpdate.userIsParticipant
                                ? const ImageIcon(AssetImage(
                                    'assets/images/skaterIcon_256.png'))
                                : const Icon(Icons.gps_fixed_sharp),
                          );
                        }),
                ],
                //Markers end
                controller: controller,
              );
            },
          ),
          TrackProgressOverlay(mapController: controller),
          //##############right buttons
          if (!kIsWeb)
            Positioned(
              right: 5,
              bottom: 5,
              height: 30,
              width: MediaQuery.of(context).size.width * .60,
              child: Builder(builder: (context) {
                var lp = context.watch(locationProvider);
                if (lp.gpsLocationPermissionsStatus !=
                    LocationPermissionStatus.denied) {
                  var alwaysPermissionGranted =
                      (lp.gpsLocationPermissionsStatus ==
                          LocationPermissionStatus.always);
                  return GestureDetector(
                    onLongPress: () async {
                      await BackgroundGeolocationHelper.resetOdoMeter(context);
                      setState(() {});
                    },
                    child: FloatingActionButton.extended(
                      backgroundColor: lp.isTracking
                          ? alwaysPermissionGranted
                              ? CupertinoTheme.of(context)
                                  .barBackgroundColor
                                  .withOpacity(0.6)
                              : CupertinoColors.systemYellow
                          : CupertinoTheme.of(context)
                              .barBackgroundColor
                              .withOpacity(0.4),
                      foregroundColor: lp.isTracking
                          ? alwaysPermissionGranted
                              ? CupertinoTheme.of(context)
                                  .primaryColor
                                  .withOpacity(0.9)
                              : CupertinoColors.black
                          : Colors.black,
                      icon: Row(children: [
                        Icon(CupertinoIcons.gauge,
                            color: lp.isMoving
                                ? CupertinoTheme.of(context)
                                    .primaryContrastingColor
                                : CupertinoTheme.of(context).primaryColor),
                        lp.userIsParticipant
                            ? ImageIcon(
                                const AssetImage(
                                    'assets/images/skaterIcon_256.png'),
                                color: lp.isMoving
                                    ? CupertinoTheme.of(context)
                                        .primaryContrastingColor
                                    : CupertinoTheme.of(context).primaryColor,
                              )
                            : const Icon(Icons.gps_fixed_sharp),
                      ]),
                      label: FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          '${lp.realUserSpeedKmh == null ? '- km/h' : lp.realUserSpeedKmh.formatSpeedKmH()}  ${HiveSettingsDB.useAlternativeLocationProvider ? '' : '${lp.odometer.toStringAsFixed(1)} km'} ${alwaysPermissionGranted ? "" : "!"}',
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .navTitleTextStyle,
                        ),
                      ),
                      onPressed: () async {
                        if (alwaysPermissionGranted) {
                          resetOdoMeterAndRoutePoints();
                        } else {
                          var reqResult =
                              await FlutterPlatformAlert.showCustomAlert(
                                  windowTitle: Localize.of(context)
                                      .openOperatingSystemSettings,
                                  iconStyle: IconStyle.information,
                                  text:
                                      '${alwaysPermissionGranted ? "" : "\n${Localize.of(context).onlyWhileInUse}"} \n'
                                      '${Localize.of(context).userSpeed} ${lp.realUserSpeedKmh == null ? '- km/h' : lp.realUserSpeedKmh.formatSpeedKmH()} \n'
                                      '${Localize.of(context).distanceDrivenOdo} ${HiveSettingsDB.useAlternativeLocationProvider ? '' : '${lp.odometer.toStringAsFixed(1)} km'}\n'
                                      '${Localize.of(context).resetLongPress}',
                                  positiveButtonTitle: Localize.of(context)
                                      .openOperatingSystemSettings,
                                  negativeButtonTitle:
                                      Localize.of(context).cancel);
                          if (reqResult == CustomButton.positiveButton) {
                            await LocationPermissionDialog.openSystemSettings();
                          }
                        }
                      },
                    ),
                  );
                } else if (lp.gpsLocationPermissionsStatus ==
                    LocationPermissionStatus.denied) {
                  return FloatingActionButton.extended(
                    onPressed: () async {
                      FlutterPlatformAlert.showAlert(
                          windowTitle: Localize.of(context)
                              .noLocationPermissionGrantedAlertTitle,
                          text: Localize.of(context).locationServiceOff,
                          iconStyle: IconStyle.warning);
                    },
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    tooltip: Localize.of(context).locationServiceOff,
                    icon: const Row(children: [
                      Icon(CupertinoIcons.location_slash_fill),
                    ]),
                    label: const Text(
                      '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
            ),
          if (!kIsWeb)
            Positioned(
              right: 10,
              bottom: 40,
              child: Builder(builder: (context) {
                var isTracking = context.watch(isTrackingProvider);
                var autoStop = context.watch(isAutoStopProvider);
                var userParticipating =
                    context.watch(isUserParticipatingProvider);
                //for future implementations - if (isActive == EventStatus.confirmed) {
                return GestureDetector(
                  onLongPress: () async {
                    LocationProvider.instance.toggleAutoStop();
                    await FlutterPlatformAlert.showCustomAlert(
                      windowTitle: Localize.of(context).autoStopTracking,
                      text: Localize.of(context).automatedStopInfo,
                      positiveButtonTitle: Localize.of(context).ok,
                    );
                  },
                  child: FloatingActionButton(
                    onPressed: () async {
                      if (isTracking && !userParticipating) {
                        toggleViewerLocationService();
                      } else if (isTracking) {
                        //&& !autoStop
                        final clickedButton =
                            await FlutterPlatformAlert.showCustomAlert(
                                windowTitle:
                                    Localize.of(context).stopLocationTracking,
                                text: Localize.of(context).friendswillmissyou,
                                positiveButtonTitle: Localize.of(context).yes,
                                negativeButtonTitle: Localize.of(context)
                                    .no); //no neutral button on android
                        if (clickedButton == CustomButton.positiveButton) {
                          toggleLocationService();
                        }
                      } else {
                        toggleLocationService();
                      }
                    },
                    backgroundColor: isTracking && autoStop
                        ? CupertinoColors.systemYellow
                        : isTracking
                            ? CupertinoColors.systemRed
                            : CupertinoColors.activeGreen,
                    heroTag: 'startStopTrackingBtnTag',
                    child: Builder(builder: (context) {
                      return userParticipating
                          ? Icon(
                              isTracking && autoStop
                                  ? Icons.pause
                                  : isTracking
                                      ? CupertinoIcons.stop_circle
                                      : CupertinoIcons.play_fill,
                            )
                          : isTracking
                              ? const ImageIcon(
                                  AssetImage('assets/images/eyestop.png'))
                              : const Icon(CupertinoIcons.play_fill,
                                  color: CupertinoColors.white);
                    }),
                  ),
                );
              }),
            ),
          if (!kIsWeb)
            Positioned(
              right: 10,
              bottom: 110,
              child: Builder(builder: (context) {
                return FloatingActionButton(
                  onPressed: () {
                    switch (followLocationState) {
                      case FollowLocationStates.followOff:
                        followLocationState = FollowLocationStates.followMe;
                        startFollowingMeLocation();
                        showToast(
                            message: Localize.of(context).mapFollowLocation);
                        break;
                      case FollowLocationStates.followMe:
                        followLocationState =
                            FollowLocationStates.followMeStopped;
                        stopFollowingLocation();
                        showToast(
                            message: Localize.of(context).mapFollowStopped);
                        break;
                      case FollowLocationStates.followMeStopped:
                        followLocationState = FollowLocationStates.followTrain;
                        startFollowingTrainHead();
                        showToast(message: Localize.of(context).mapFollowTrain);
                        break;
                      case FollowLocationStates.followTrain:
                        followLocationState =
                            FollowLocationStates.followTrainStopped;
                        stopFollowingLocation();
                        showToast(
                            message:
                                Localize.of(context).mapFollowTrainStopped);
                        break;
                      case FollowLocationStates.followTrainStopped:
                        followLocationState = FollowLocationStates.followOff;
                        moveMapToDefault();
                        showToast(
                            message:
                                Localize.of(context).mapToStartNoFollowing);
                        break;
                      default:
                        followLocationState = FollowLocationStates.followOff;
                        if (locationSubscription != null) {
                          stopFollowingLocation();
                        } else {
                          startFollowingMeLocation();
                        }
                        break;
                    }
                  },
                  heroTag: 'locationBtnTag',
                  child: FollowingLocationIcon(
                    followLocationStatus: followLocationState,
                  ),
                );
              }),
            ),
          //Left located buttons

          Positioned(
            left: 10,
            bottom: 50,
            height: 40,
            child: Builder(builder: (context) {
              return FloatingActionButton(
                onPressed: () {
                  setState(() {
                    HiveSettingsDB.setMapMenuVisible(
                        !HiveSettingsDB.mapMenuVisible);
                  });
                },
                heroTag: 'showMenuTag',
                child: HiveSettingsDB.mapMenuVisible
                    ? const Icon(Icons.menu_open)
                    : const Icon(Icons.menu),
              );
            }),
          ),
          if (kIsWeb)
            Positioned(
              left: 10,
              bottom: HiveSettingsDB.mapMenuVisible ? 250 : 100,
              height: 40,
              child: Builder(builder: (context) {
                return FloatingActionButton(
                  onPressed: () {
                    switch (followLocationState) {
                      case FollowLocationStates.followOff:
                      case FollowLocationStates.followMeStopped:
                        followLocationState = FollowLocationStates.followTrain;
                        startFollowingTrainHead();
                        showToast(message: Localize.of(context).mapFollowTrain);
                        break;
                      case FollowLocationStates.followTrain:
                        followLocationState =
                            FollowLocationStates.followTrainStopped;
                        stopFollowingLocation();
                        showToast(
                            message:
                                Localize.of(context).mapFollowTrainStopped);
                        break;
                      case FollowLocationStates.followTrainStopped:
                        followLocationState = FollowLocationStates.followOff;
                        moveMapToDefault();
                        showToast(
                            message:
                                Localize.of(context).mapToStartNoFollowing);
                        break;
                      default:
                        followLocationState = FollowLocationStates.followOff;
                        if (locationSubscription != null) {
                          stopFollowingLocation();
                        } else {
                          startFollowingMeLocation();
                        }
                        break;
                    }
                  },
                  heroTag: 'locationBtnTagWeb',
                  child: FollowingLocationIcon(
                    followLocationStatus: followLocationState,
                  ),
                );
              }),
            ),
          Visibility(
            visible: HiveSettingsDB.mapMenuVisible,
            child: Stack(
              children: [
                if (!kIsWeb)
                  Positioned(
                    left: 10,
                    bottom: 350, //same height as qrcode in web
                    height: 40,
                    child: Builder(builder: (context) {
                      var isActive = context.watch(
                          isActiveEventProvider.select((ia) => ia.status));
                      if (isActive == EventStatus.confirmed) {
                        var currentRoute = context.watch(currentRouteProvider);
                        return currentRoute.when(data: (data) {
                          return FloatingActionButton(
                              heroTag: 'barcodeBtnTag',
                              backgroundColor: Colors.blue,
                              onPressed: () {
                                _showLiveMapLink(context
                                    .read(LiveMapImageAndLink.provider)
                                    .link);
                              },
                              child: const Icon(
                                CupertinoIcons.qrcode,
                                color: Colors.white,
                              ));
                        }, error: (err, stack) {
                          return Container();
                        }, loading: () {
                          return Container();
                        });
                      } else {
                        return Container();
                      }
                    }),
                  ),
                if (!kIsWeb)
                  Positioned(
                    left: 10,
                    bottom: HiveSettingsDB.mapMenuVisible ? 300 : 100,
                    height: 40,
                    child: Builder(builder: (context) {
                      var isTracking = context.watch(
                          locationProvider.select((it) => it.isTracking));
                      if (!isTracking) {
                        return FloatingActionButton(
                          heroTag: 'viewerBtnTag',
                          backgroundColor: Colors.blue,
                          onPressed: () {
                            toggleViewerLocationService();
                          },
                          child: const Icon(CupertinoIcons.eye_solid,
                              color: CupertinoColors.white),
                          /*CupertinoAdaptiveTheme.of(context).brightness ==
                                Brightness.light
                            ? context.watch(ThemePrimaryDarkColor.provider)
                            : context.watch(ThemePrimaryColor.provider)),*/
                        );
                      } else {
                        return Container();
                      }
                    }),
                  ),
                if (!kIsWeb)
                  Positioned(
                    left: 10,
                    bottom: 250, //same height as qrcode in web
                    height: 40,
                    child: Builder(builder: (context) {
                      return FloatingActionButton(
                        heroTag: 'resetBtnTag',
                        backgroundColor: Colors.blue,
                        onPressed: () {
                          resetOdoMeterAndRoutePoints();
                        },
                        child: const Icon(
                          Icons.restart_alt,
                          color: Colors.white,
                        ),
                      );
                    }),
                  ),
                Positioned(
                  left: 10,
                  bottom: 200,
                  height: 40,
                  child: Builder(builder: (context) {
                    return FloatingActionButton(
                      onPressed: () {
                        var zoom = controller.zoom;
                        controller.move(controller.center, zoom - 0.5);
                      },
                      heroTag: 'zoominTag',
                      child: const Icon(CupertinoIcons.zoom_out),
                    );
                  }),
                ),
                Positioned(
                  left: 10,
                  bottom: 150,
                  height: 40,
                  child: Builder(builder: (context) {
                    return FloatingActionButton(
                      onPressed: () {
                        var zoom = controller.zoom;
                        controller.move(controller.center, zoom + 0.5);
                      },
                      heroTag: 'zoomOutTag',
                      child: const Icon(CupertinoIcons.zoom_in),
                    );
                  }),
                ),
                Positioned(
                  left: 10,
                  bottom: 100,
                  height: 40,
                  child: Builder(builder: (context) {
                    return FloatingActionButton(
                      onPressed: () {
                        var theme = CupertinoAdaptiveTheme.of(context).theme;
                        if (theme.brightness == Brightness.light) {
                          CupertinoAdaptiveTheme.of(context).setDark();
                          HiveSettingsDB.setAdaptiveThemeMode(
                              AdaptiveThemeMode.dark);
                        } else {
                          CupertinoAdaptiveTheme.of(context).setLight();
                          HiveSettingsDB.setAdaptiveThemeMode(
                              AdaptiveThemeMode.light);
                        }
                      },
                      heroTag: 'darkLightTag',
                      child:
                          CupertinoAdaptiveTheme.of(context).theme.brightness ==
                                  Brightness.light
                              ? const Icon(CupertinoIcons.moon)
                              : const Icon(CupertinoIcons.sun_min),
                    );
                  }),
                ),
              ],
            ),
          ),
          Positioned(
            left: -10,
            bottom: 0,
            width: MediaQuery.of(context).size.width * .350,
            child: Builder(builder: (context) {
              return CupertinoButton(
                onPressed: () {
                  Launch.launchUrlFromString(
                      'https://www.openstreetmap.org/copyright');
                },
                child: const FittedBox(
                  child: Text(
                    '©OpenStreetMap contributors',
                    maxLines: 2,
                    style: TextStyle(
                        backgroundColor: Colors.black26,
                        color: CupertinoColors.white,
                        fontSize: 10.0),
                  ),
                ),
              );
            }),
          ),
        ]),
      ),
    );
  }

  void resetOdoMeterAndRoutePoints() async {
    var lp = LocationProvider.instance;
    var alwaysPermissionGranted =
        (lp.gpsLocationPermissionsStatus == LocationPermissionStatus.always);
    var whenInusePermissionGranted =
        (lp.gpsLocationPermissionsStatus == LocationPermissionStatus.whenInUse);
    if (alwaysPermissionGranted || whenInusePermissionGranted) {
      var odometerResetResult = await FlutterPlatformAlert.showCustomAlert(
          windowTitle: Localize.current.resetOdoMeterTitle,
          text:
              '${Localize.of(context).userSpeed}  ${lp.realUserSpeedKmh == null ? '- km/h' : lp.realUserSpeedKmh.formatSpeedKmH()}\n'
              '${Localize.of(context).distanceDrivenOdo} ${HiveSettingsDB.useAlternativeLocationProvider ? '' : '${lp.odometer.toStringAsFixed(1)} km'} \n '
              '${Localize.current.resetOdoMeter}',
          iconStyle: IconStyle.warning,
          positiveButtonTitle: Localize.current.yes,
          negativeButtonTitle: Localize.current.cancel);
      if (odometerResetResult == CustomButton.positiveButton) {
        lp.resetTrackPoints();
        bg.BackgroundGeolocation.setOdometer(0.0)
            .then((value) => setState(() {}))
            .catchError((error) {
          showToast(message: Localize.of(context).failed);
          if (!kIsWeb) {
            FLog.error(text: '[resetOdometer] ERROR: $error');
          }
        });
      }
    }
  }
}
