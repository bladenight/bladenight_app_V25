import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../app_settings/app_configuration_helper.dart';
import '../../../generated/l10n.dart';
import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../helpers/notification/toast_notification.dart';
import '../../../models/follow_location_state.dart';
import '../../../models/route.dart';
import '../../../pages/widgets/following_location_icon.dart';
import '../../../providers/images_and_links/live_map_image_and_link_provider.dart';
import '../../../providers/is_tracking_provider.dart';
import '../../../providers/location_provider.dart';
import '../../../providers/map/align_flutter_map_provider.dart';
import '../../../providers/map/camera_follow_location_provider.dart';
import '../../../providers/map_button_visibility_provider.dart';
import '../../../providers/route_providers.dart';
import '../../widgets/align_map_icon.dart';
import '../widgets/qr_create_page.dart';
import 'map_left_buttons.dart';

class MapButtonsLayer extends ConsumerStatefulWidget {
  const MapButtonsLayer({super.key});

  @override
  ConsumerState<MapButtonsLayer> createState() => _MapButtonsOverlay();
}

class _MapButtonsOverlay extends ConsumerState<MapButtonsLayer> {
  ProviderSubscription<AsyncValue<LatLng?>>? locationSubscription;

  @override
  Widget build(BuildContext context) {
    CameraFollow followLocationState = ref.watch(cameraFollowLocationProvider);

    return Stack(children: [
      if (!kIsWeb)
        Positioned(
          left: 80,
          bottom: 40,
          //same height as qrcode in web
          height: 40,
          width: 40,
          child: Builder(builder: (context) {
            if (ref.watch(isActiveEventProvider)) {
              var currentRoute = ref.watch(currentRouteProvider);
              return currentRoute.when(data: (data) {
                return FloatingActionButton(
                    heroTag: 'barcodeBtnTag',
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      _showLiveMapLink(
                          ref.read(LiveMapImageAndLink.provider).link);
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

      if (!kIsWeb && ref.watch(mapSettingsProviderProvider))
        Positioned(
          left: 10,
          bottom: ref.watch(mapSettingsProviderProvider) ? 300 : 100,
          height: 40,
          child: Builder(builder: (context) {
            var isTracking = ref.watch(isTrackingProvider);
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
                            ? ref.watch(ThemePrimaryDarkColor.provider)
                            : ref.watch(ThemePrimaryColor.provider)),*/
              );
            } else {
              return Container();
            }
          }),
        ),
      if (!kIsWeb && MapSettings.mapMenuVisible)
        Positioned(
          left: 10,
          bottom: 250, //same height as qrcode in web
          height: 40,
          child: Builder(builder: (context) {
            return FloatingActionButton(
              heroTag: 'resetBtnTag',
              backgroundColor: Colors.blue,
              onPressed: () async {
                await LocationProvider.instance.resetOdoMeterAndRoutePoints();
              },
              child: const Icon(
                Icons.restart_alt,
                color: Colors.white,
              ),
            );
          }),
        ),
      const MapLeftButtonsLayer(),

      //##############right buttons

      if (!kIsWeb)
        Positioned(
          right: 10,
          bottom: 40,
          child: Builder(builder: (context) {
            var isTracking = ref.watch(isTrackingProvider);
            var autoStop = ref.watch(isAutoStopProvider);
            var userParticipating = ref.watch(isUserParticipatingProvider);
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
                      _toggleLocationService();
                    }
                  } else {
                    _toggleLocationService();
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
          height: 40,
          child: Builder(builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                var controller = MapController.maybeOf(context);
                if (controller == null) return;
                var nextState =
                    ref.read(cameraFollowLocationProvider.notifier).setNext();
                switch (nextState) {
                  case CameraFollow.followOff:
                    _moveMapToDefault(controller);
                    showToast(
                        message: Localize.of(context).mapToStartNoFollowing);

                    break;
                  case CameraFollow.followMe:
                    showToast(message: Localize.of(context).mapFollowLocation);
                    break;
                  case CameraFollow.followMeStopped:
                    stopFollowingLocation();
                    showToast(message: Localize.of(context).mapFollowStopped);

                    break;
                  case CameraFollow.followTrain:
                    startFollowingTrainHead(controller);
                    showToast(message: Localize.of(context).mapFollowTrain);

                    break;
                  case CameraFollow.followTrainStopped:
                    stopFollowingLocation();
                    showToast(
                        message: Localize.of(context).mapFollowTrainStopped);

                    break;
                  default:
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

      if (!kIsWeb)
        Visibility(
          visible: followLocationState == CameraFollow.followMe ? true : false,
          child: Positioned(
            right: 10,
            height: 40,
            bottom: 160,
            child: Builder(builder: (context) {
              var alignMap = ref.watch(alignFlutterMapProvider);
              return FloatingActionButton(
                onPressed: () {
                  var controller = MapController.maybeOf(context);
                  if (controller == null) return;
                  var nextState =
                      ref.read(alignFlutterMapProvider.notifier).setNext();
                  switch (nextState) {
                    case AlignFlutterMapState.alignNever:
                      var mapController = MapController.of(context);
                      mapController.rotate(0);
                      showToast(message: Localize.of(context).alignNever);
                      break;
                    case AlignFlutterMapState.alignPositionOnUpdateOnly:
                      showToast(
                          message:
                              Localize.of(context).alignPositionOnUpdateOnly);
                      break;
                    case AlignFlutterMapState.alignDirectionOnUpdateOnly:
                      showToast(
                          message:
                              Localize.of(context).alignDirectionOnUpdateOnly);
                      break;
                    case AlignFlutterMapState.alignDirectionAndPositionOnUpdate:
                      showToast(
                          message: Localize.of(context)
                              .alignDirectionAndPositionOnUpdate);
                      break;
                  }
                },
                heroTag: 'mapAlignBtnTag',
                child: AlignMapIcon(
                  alignMapStatus: alignMap,
                ),
              );
            }),
          ),
        ),

      //Left located button web
      if (kIsWeb)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          left: 10,
          bottom: ref.watch(mapSettingsProviderProvider) ? 250 : 100,
          height: 40,
          child: Builder(builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                final controller = MapController.maybeOf(context);
                final camera = MapCamera.maybeOf(context);
                if (controller == null || camera == null) {
                  return;
                }
                switch (followLocationState) {
                  case CameraFollow.followOff:
                  case CameraFollow.followMeStopped:
                    followLocationState = CameraFollow.followTrain;
                    startFollowingTrainHead(controller);
                    showToast(message: Localize.of(context).mapFollowTrain);
                    break;
                  case CameraFollow.followTrain:
                    followLocationState = CameraFollow.followTrainStopped;
                    stopFollowingLocation();
                    showToast(
                        message: Localize.of(context).mapFollowTrainStopped);
                    break;
                  case CameraFollow.followTrainStopped:
                    followLocationState = CameraFollow.followOff;
                    _moveMapToDefault(controller);
                    showToast(
                        message: Localize.of(context).mapToStartNoFollowing);
                    break;
                  default:
                    followLocationState = CameraFollow.followOff;
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
    ]);
  }

  ///Toggles between location tracking and view without user pos
  void _toggleLocationService() async {
    ref.read(isTrackingProvider.notifier).toggleTracking(true);
  }

  ///Toggles between user position and view with user pos
  void toggleViewerLocationService() async {
    if (context.watch(isTrackingProvider)) {
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

  void _showLiveMapLink(String? link) {
    showCupertinoModalBottomSheet(
        backgroundColor: CupertinoDynamicColor.resolve(
            CupertinoColors.systemBackground, context),
        context: context,
        builder: (context) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: kIsWeb
                  ? MediaQuery.of(context).size.height * 0.5
                  : MediaQuery.of(context).size.height * 0.7,
            ),
            child: QRCreatePage(
                qrcodetext: link ?? liveMapLink,
                headertext: Localize.of(context).liveMapInBrowserInfoHeader,
                infotext: Localize.of(context).liveMapInBrowser),
          );
        });
  }

  void startFollowingTrainHead(MapController controller) {
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

  void startFollowingMeLocation() {
    final controller = MapController.maybeOf(context);
    final camera = MapCamera.maybeOf(context);
    if (controller == null || camera == null) {
      return;
    }
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
    ref.read(locationProvider).refresh(forceUpdate: true);
  }

  void stopFollowingLocation() async {
    locationSubscription?.close();
    locationSubscription = null;
    setState(() {});
  }

  void _moveMapToDefault(MapController controller) {
    controller.move(defaultLatLng, controller.camera.zoom);
  }
}
