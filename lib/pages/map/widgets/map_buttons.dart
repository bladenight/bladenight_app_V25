import 'dart:core';

import 'package:adaptive_theme/adaptive_theme.dart';
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
import '../../../helpers/url_launch_helper.dart';
import '../../../models/follow_location_state.dart';
import '../../../models/route.dart';
import '../../../pages/widgets/following_location_icon.dart';
import '../../../providers/images_and_links/live_map_image_and_link_provider.dart';
import '../../../providers/location_provider.dart';
import '../../../providers/route_providers.dart';
import '../widgets/qr_create_page.dart';

class MapButtonsOverlay extends ConsumerStatefulWidget {
  const MapButtonsOverlay({super.key});

  @override
  ConsumerState<MapButtonsOverlay> createState() => _MapButtonsOverlay();
}

class _MapButtonsOverlay extends ConsumerState<MapButtonsOverlay> {
  ProviderSubscription<AsyncValue<LatLng?>>? locationSubscription;

  late FollowLocationStates followLocationState =
      FollowLocationStates.followOff;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      if (!kIsWeb)
        Visibility(
          visible: true, //MapSettings.mapMenuVisible,
          child: Positioned(
            right: 10,
            bottom: 190, //same height as qrcode in web
            height: 40,
            child: Builder(builder: (context) {
              var isActive =
                  ref.watch(isActiveEventProvider.select((ia) => ia));
              if (isActive) {
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
        ),
      if (!kIsWeb && MapSettings.mapMenuVisible)
        Positioned(
          left: 10,
          bottom: MapSettings.mapMenuVisible ? 300 : 100,
          height: 40,
          child: Builder(builder: (context) {
            var isTracking =
                ref.watch(locationProvider.select((it) => it.isTracking));
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
      if (MapSettings.mapMenuVisible)
        Positioned(
          left: 10,
          bottom: 200,
          height: 40,
          child: Builder(builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                final controller = MapController.maybeOf(context);
                final camera = MapCamera.maybeOf(context);
                if (controller == null || camera == null) {
                  return;
                }
                controller.move(controller.camera.center, camera.zoom - 0.5);
              },
              heroTag: 'zoomInTag',
              child: const Icon(CupertinoIcons.zoom_out),
            );
          }),
        ),
      if (MapSettings.mapMenuVisible)
        Positioned(
          left: 10,
          bottom: 150,
          height: 40,
          child: Builder(builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                final controller = MapController.maybeOf(context);
                final camera = MapCamera.maybeOf(context);
                if (controller == null || camera == null) {
                  return;
                }
                controller.move(controller.camera.center, camera.zoom + 0.5);
              },
              heroTag: 'zoomOutTag',
              child: const Icon(CupertinoIcons.zoom_in),
            );
          }),
        ),
      if (MapSettings.mapMenuVisible)
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
                  HiveSettingsDB.setAdaptiveThemeMode(AdaptiveThemeMode.dark);
                } else {
                  CupertinoAdaptiveTheme.of(context).setLight();
                  HiveSettingsDB.setAdaptiveThemeMode(AdaptiveThemeMode.light);
                }
              },
              heroTag: 'darkLightTag',
              child: CupertinoAdaptiveTheme.of(context).theme.brightness ==
                      Brightness.light
                  ? const Icon(CupertinoIcons.moon)
                  : const Icon(CupertinoIcons.sun_min),
            );
          }),
        ),

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
          child: Builder(builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                var controller = MapController.maybeOf(context);
                if (controller == null) return;
                switch (followLocationState) {
                  case FollowLocationStates.followOff:
                    followLocationState = FollowLocationStates.followMe;
                    startFollowingMeLocation();
                    showToast(message: Localize.of(context).mapFollowLocation);
                    break;
                  case FollowLocationStates.followMe:
                    followLocationState = FollowLocationStates.followMeStopped;
                    stopFollowingLocation();
                    showToast(message: Localize.of(context).mapFollowStopped);
                    break;
                  case FollowLocationStates.followMeStopped:
                    followLocationState = FollowLocationStates.followTrain;
                    startFollowingTrainHead(controller);
                    showToast(message: Localize.of(context).mapFollowTrain);
                    break;
                  case FollowLocationStates.followTrain:
                    followLocationState =
                        FollowLocationStates.followTrainStopped;
                    stopFollowingLocation();
                    showToast(
                        message: Localize.of(context).mapFollowTrainStopped);
                    break;
                  case FollowLocationStates.followTrainStopped:
                    followLocationState = FollowLocationStates.followOff;
                    _moveMapToDefault(controller);
                    showToast(
                        message: Localize.of(context).mapToStartNoFollowing);
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
                MapSettings.setMapMenuVisible(!MapSettings.mapMenuVisible);
              });
            },
            heroTag: 'showMenuTag',
            child: MapSettings.mapMenuVisible
                ? const Icon(Icons.menu_open)
                : const Icon(Icons.menu),
          );
        }),
      ),
      if (kIsWeb)
        Positioned(
          left: 10,
          bottom: MapSettings.mapMenuVisible ? 250 : 100,
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
                  case FollowLocationStates.followOff:
                  case FollowLocationStates.followMeStopped:
                    followLocationState = FollowLocationStates.followTrain;
                    startFollowingTrainHead(controller);
                    showToast(message: Localize.of(context).mapFollowTrain);
                    break;
                  case FollowLocationStates.followTrain:
                    followLocationState =
                        FollowLocationStates.followTrainStopped;
                    stopFollowingLocation();
                    showToast(
                        message: Localize.of(context).mapFollowTrainStopped);
                    break;
                  case FollowLocationStates.followTrainStopped:
                    followLocationState = FollowLocationStates.followOff;
                    _moveMapToDefault(controller);
                    showToast(
                        message: Localize.of(context).mapToStartNoFollowing);
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
    ]);
  }

  ///Toggles between location tracking and view without user pos
  void _toggleLocationService() async {
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
    setState(() {
      followLocationState = FollowLocationStates.followMe;
    });
    ref.read(locationProvider).refresh(forceUpdate: true);
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

  void stopFollowingLocation() async {
    locationSubscription?.close();
    locationSubscription = null;
    setState(() {});
  }

  void _moveMapToDefault(MapController controller) {
    controller.move(defaultLatLng, controller.camera.zoom);
  }
}
