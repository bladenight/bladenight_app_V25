import 'dart:core';
import 'dart:math' as math;

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quickalert/models/quickalert_type.dart';
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
import '../../../providers/map/compass_provider.dart';
import '../../../providers/map/heading_marker_size_provider.dart';
import '../../../providers/map/map_settings_provider.dart';
import '../../../providers/map_button_visibility_provider.dart';
import '../../../providers/messages_provider.dart';
import '../../../providers/route_providers.dart';
import '../../messages/messages_page.dart';
import '../../widgets/align_map_icon.dart';
import '../../widgets/positioned_visibility_opacity.dart';
import '../../widgets/scroll_quick_alert.dart';
import '../widgets/qr_create_page.dart';

class MapButtonsLayer extends ConsumerStatefulWidget {
  const MapButtonsLayer({super.key});

  @override
  ConsumerState<MapButtonsLayer> createState() => _MapButtonsOverlay();
}

class _MapButtonsOverlay extends ConsumerState<MapButtonsLayer>
    with SingleTickerProviderStateMixin {
  ProviderSubscription<AsyncValue<LatLng?>>? locationSubscription;
  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    animation = CurveTween(curve: Curves.easeIn).animate(animationController!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CameraFollow followLocationState = ref.watch(cameraFollowLocationProvider);
    return Stack(fit: StackFit.passthrough, children: [
      //#######################################################################
      //Right side buttons
      //#######################################################################
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
              await ScrollQuickAlert.show(
                context: context,
                type: QuickAlertType.warning,
                title: Localize.of(context).autoStopTracking,
                text: Localize.of(context).automatedStopInfo,
                confirmBtnText: Localize.of(context).ok,
              );
            },
            child: FloatingActionButton(
              onPressed: () async {
                if (isTracking && !userParticipating) {
                  _toggleViewerLocationService();
                } else if (isTracking) {
                  if (kIsWeb) {
                    _toggleViewerLocationService();
                    return;
                  }
                  //&& !autoStop
                  await ScrollQuickAlert.show(
                      context: context,
                      showCancelBtn: true,
                      type: QuickAlertType.warning,
                      title: Localize.of(context).stopLocationTracking,
                      text: Localize.of(context).friendswillmissyou,
                      confirmBtnText: Localize.of(context).yes,
                      cancelBtnText: Localize.of(context).no,
                      onConfirmBtnTap: () {
                        _toggleLocationService();
                        if (!mounted) return;
                        Navigator.of(context).pop();
                      }); //no neutral button on android
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
      //if (!kIsWeb)
      Positioned(
        right: 10,
        height: 40,
        bottom: 160,
        child: Visibility(
          visible: followLocationState == CameraFollow.followMe ? true : false,
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
      // if (!kIsWeb)
      Positioned(
        right: 10,
        bottom: 110,
        height: 40,
        child: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              var mapController = MapController.maybeOf(context);
              if (mapController == null) return;
              var nextState =
                  ref.read(cameraFollowLocationProvider.notifier).setNext();
              switch (nextState) {
                case CameraFollow.followOff:
                  _moveMapToDefault(mapController);
                  showToast(
                      message: Localize.of(context).mapToStartNoFollowing);
                  break;
                case CameraFollow.followMe:
                  if (ref.read(alignFlutterMapProvider) ==
                      AlignFlutterMapState.alignNever) {
                    showToast(
                        message: '${Localize.of(context).mapFollowLocation} \n'
                            '${Localize.of(context).alignNever}');
                  } else {
                    showToast(message: Localize.of(context).mapFollowLocation);
                  }
                  break;
                case CameraFollow.followMeStopped:
                  stopFollowingLocation();
                  showToast(message: Localize.of(context).mapFollowStopped);
                  mapController.rotate(0);
                  break;
                case CameraFollow.followTrain:
                  startFollowingTrainHead(mapController);
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

      if (!kIsWeb && ref.watch(showCompassProvider))
        Positioned(
          right: 10,
          bottom: 220,
          child: Builder(builder: (context) {
            var direction = ref.watch(compassProvider);
            return FloatingActionButton(
              heroTag: 'compassHeroTag',
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: () {
                final controller = MapController.of(context);
                controller.rotate(0);
              },
              child: Transform.rotate(
                angle: (direction * (math.pi / 180) * -1),
                child: Image.asset('assets/images/compass.png'),
              ),
            );
          }),
        ),

      //Left located button web
      /* if (kIsWeb)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          left: 10,
          bottom: ref.watch(mapMenuVisibleProvider) ? 250 : 100,
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
        ),*/
      //#######################################################################
      //Left side buttons
      //#######################################################################
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
                          ref.read(liveMapImageAndLinkProvider).link);
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
          bottom: ref.watch(mapMenuVisibleProvider) ? 300 : 90,
          height: 40,
          child: Builder(builder: (context) {
            var isTracking = ref.watch(isTrackingProvider);
            if (!isTracking) {
              return FloatingActionButton(
                heroTag: 'viewerBtnTag',
                //backgroundColor: Colors.blue,
                onPressed: () {
                  _toggleViewerLocationService();
                },
                child: const Icon(
                  CupertinoIcons.eye_solid,
                  //color: CupertinoColors.white
                ),
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
      if (!kIsWeb)
        PositionedVisibilityOpacity(
          left: 10,
          bottom: 250,
          //same height as qrcode in web
          height: 40,
          heroTag: 'resetBtnTag',
          //backgroundColor: Colors.blue,
          onPressed: () async {
            await LocationProvider.instance
                .resetOdoMeterAndRoutePoints(context);
          },
          visibility: ref.watch(mapMenuVisibleProvider),
          child: const Icon(
            Icons.restart_alt,
            //color: Colors.white,
          ),
        ),

      PositionedVisibilityOpacity(
        left: 10,
        bottom: 190,
        height: 40,
        heroTag: 'zoomOutTag',
        onPressed: () {
          final controller = MapController.maybeOf(context);
          final camera = MapCamera.maybeOf(context);
          if (controller == null || camera == null) {
            return;
          }
          controller.move(controller.camera.center, camera.zoom - 0.5);
          ref.read(headingMarkerSizeProvider.notifier).setSize(camera.zoom);
        },
        visibility: ref.watch(mapMenuVisibleProvider),
        child: Icon(
          CupertinoIcons.zoom_out,
          semanticLabel: MapController.of(context).camera.zoom.toString(),
        ),
      ),
      PositionedVisibilityOpacity(
        heroTag: 'zoomInTag',
        left: 10,
        bottom: 140,
        height: 40,
        visibility: ref.watch(mapMenuVisibleProvider),
        onPressed: () {
          final controller = MapController.of(context);
          final camera = MapCamera.of(context);
          controller.move(controller.camera.center, camera.zoom + 0.5);
          ref.read(headingMarkerSizeProvider.notifier).setSize(camera.zoom);
        },
        child: Icon(
          CupertinoIcons.zoom_in,
          semanticLabel: MapController.of(context).camera.zoom.toString(),
        ),
      ),
      PositionedVisibilityOpacity(
        left: 10,
        bottom: 90,
        height: 40,
        visibility: ref.watch(mapMenuVisibleProvider),
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
      ),
      Positioned(
        left: 10,
        bottom: 40,
        height: 40,
        child: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              setState(() {
                MapSettings.setMapMenuVisible(!MapSettings.mapMenuVisible);
              });
            },
            tooltip: 'Menu',
            heroTag: 'showMenuTag',
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: ref.watch(mapMenuVisibleProvider)
                  ? const Icon(
                      Icons.menu_open,
                      key: ValueKey<int>(1),
                    )
                  : const Icon(
                      Icons.menu,
                      key: ValueKey<int>(2),
                    ),
            ),
          );
        }),
      ),
      Positioned(
        top: kIsWeb ? 10 : kToolbarHeight,
        right: kIsWeb ? 10 : 10,
        height: 30,
        child: Builder(builder: (context) {
          return GestureDetector(
              onTap: () {
                setState(() {
                  MapSettings.setMapMenuVisible(true);
                });
                _showOverlay(context, text: '');
              },
              child: const AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: Icon(
                    Icons.help,
                  )));
        }),
      ),
      Positioned(
        bottom: ref.watch(mapMenuVisibleProvider) ? 350 : 140,
        left: kIsWeb ? 10 : 10,
        height: 30,
        child: Builder(builder: (context) {
          var messageProvider = context.watch(messagesLogicProvider);
          return FloatingActionButton(
              heroTag: 'messageBtnTag',
              onPressed: () async {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const MessagesPage(),
                    fullscreenDialog: false,
                  ),
                );
              },
              child: messageProvider.messages.isNotEmpty &&
                      messageProvider.readMessages > 0
                  ? Badge(
                      label: Text(messageProvider.readMessages.toString()),
                      child: const Icon(Icons.mark_email_unread),
                    )
                  : const Icon(CupertinoIcons.envelope));
        }),
      ),
    ]);
  }

  void _showOverlay(BuildContext context, {required String text}) async {
    var bottomOffset =
        kIsWeb ? kBottomNavigationBarHeight : kBottomNavigationBarHeight + 38;

    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return Stack(
        children: [
          Positioned(
            left: 00,
            top: kIsWeb ? 0 : kToolbarHeight,
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 180.0,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: CupertinoTheme.of(context).primaryColor,
                          width: 4.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_upward,
                  color: CupertinoTheme.of(context).primaryColor,
                ),
                Text(
                  Localize.of(context).actualInformations,
                  style: TextStyle(
                      color: CupertinoTheme.of(context).primaryColor,
                      backgroundColor:
                          CupertinoTheme.of(context).barBackgroundColor),
                ),
              ],
            ),
          ),
          if (!kIsWeb)
            Positioned(
              left: 70,
              bottom: ref.watch(mapMenuVisibleProvider)
                  ? 290 + bottomOffset
                  : 80 + bottomOffset,
              height: 40,
              child: Builder(builder: (context) {
                var isTracking = ref.watch(isTrackingProvider);
                if (!isTracking) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: FadeTransition(
                      opacity: animation!,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          Localize.of(context)
                              .startLocationWithoutParticipating,
                          style: TextStyle(
                            color:
                                CupertinoTheme.of(context).barBackgroundColor,
                            backgroundColor:
                                CupertinoTheme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
            ),
          if (!kIsWeb)
            Positioned(
              left: 70,
              bottom: 250 + bottomOffset,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: FadeTransition(
                  opacity: animation!,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Reset Tacho',
                      style: TextStyle(
                        color: CupertinoTheme.of(context).barBackgroundColor,
                        backgroundColor:
                            CupertinoTheme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            left: 70,
            bottom: 190 + bottomOffset,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: FadeTransition(
                opacity: animation!,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Zoom -',
                    style: TextStyle(
                      color: CupertinoTheme.of(context).barBackgroundColor,
                      backgroundColor: CupertinoTheme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 70,
            bottom: 140 + bottomOffset,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: FadeTransition(
                opacity: animation!,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Zoom +',
                    style: TextStyle(
                      color: CupertinoTheme.of(context).barBackgroundColor,
                      backgroundColor: CupertinoTheme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 70,
            bottom: 90 + bottomOffset,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: FadeTransition(
                opacity: animation!,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    Localize.of(context).setDarkMode,
                    style: TextStyle(
                      color: CupertinoTheme.of(context).barBackgroundColor,
                      backgroundColor: CupertinoTheme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          //if (!kIsWeb)
          Positioned(
            right: 70,
            bottom: 160 + bottomOffset,
            child: Visibility(
              visible: ref.read(cameraFollowLocationProvider) ==
                      CameraFollow.followMe
                  ? true
                  : false,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: FadeTransition(
                  opacity: animation!,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Kartenausrichtung',
                      style: TextStyle(
                        color: CupertinoTheme.of(context).barBackgroundColor,
                        backgroundColor:
                            CupertinoTheme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // if (!kIsWeb)
          Positioned(
            right: 70,
            bottom: 45 + bottomOffset,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: FadeTransition(
                opacity: animation!,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Teilnahme starten',
                    style: TextStyle(
                      color: CupertinoTheme.of(context).barBackgroundColor,
                      backgroundColor: CupertinoTheme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            //right: kIsWeb ? null : 70,
            //left: kIsWeb ? 70 : null,
            right: 70,
            bottom: 115 + bottomOffset,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: FadeTransition(
                opacity: animation!,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Auf Karte verfolgen',
                    style: TextStyle(
                      color: CupertinoTheme.of(context).barBackgroundColor,
                      backgroundColor: CupertinoTheme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (kIsWeb)
            Positioned(
              left: 70,
              bottom: 45 + bottomOffset,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: FadeTransition(
                  opacity: animation!,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: CupertinoTheme.of(context).barBackgroundColor,
                        backgroundColor:
                            CupertinoTheme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
    animationController!.addListener(() {
      overlayState.setState(() {});
    });
    // inserting overlay entry
    overlayState.insert(overlayEntry);
    animationController!.forward();
    await Future.delayed(const Duration(seconds: 3)).whenComplete(() =>
            animationController!
                .reverse()
                .whenCompleteOrCancel(() => overlayEntry.remove())
        // removing overlay entry after stipulated time.
        );
  }

  ///Toggles between location tracking and view without user pos
  void _toggleLocationService() async {
    ref.read(isTrackingProvider.notifier).toggleTracking(true);
  }

  ///Toggles between user position and view with user pos
  void _toggleViewerLocationService() async {
    if (ref.read(isTrackingProvider)) {
      ref.read(isTrackingProvider.notifier).toggleTracking(false);
      return;
    }
    await ScrollQuickAlert.show(
        context: context,
        showCancelBtn: true,
        type: QuickAlertType.warning,
        title: Localize.of(context).startLocationWithoutParticipating,
        text: Localize.of(context).startLocationWithoutParticipatingInfo,
        confirmBtnText: Localize.of(context).yes,
        cancelBtnText: Localize.of(context).no,
        onConfirmBtnTap: () {
          ref.read(isTrackingProvider.notifier).toggleTracking(false);
          if (!mounted) return;
          Navigator.of(context).pop();
        });
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
                qrCodeText: link ?? liveMapLink,
                headerText: Localize.of(context).liveMapInBrowserInfoHeader,
                infoText: Localize.of(context).liveMapInBrowser),
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
