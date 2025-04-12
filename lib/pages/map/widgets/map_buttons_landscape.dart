import 'dart:async';
import 'dart:core';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../app_settings/app_configuration_helper.dart';
import '../../../generated/l10n.dart';
import '../../../helpers/enums/tracking_type.dart';
import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../helpers/notification/toast_notification.dart';
import '../../../models/follow_location_state.dart';
import '../../../models/route.dart';
import '../../widgets/map/following_location_icon.dart';
import '../../../providers/app_start_and_router/go_router.dart';
import '../../../providers/images_and_links/live_map_image_and_link_provider.dart';
import '../../../providers/is_tracking_provider.dart';
import '../../../providers/location_provider.dart';
import '../../../providers/map/align_flutter_map_provider.dart';
import '../../../providers/map/camera_follow_location_provider.dart';
import '../../../providers/map/heading_marker_size_provider.dart';
import '../../../providers/map_button_visibility_provider.dart';
import '../../../providers/messages_provider.dart';
import '../../../providers/route_providers.dart';
import '../../widgets/map/align_map_icon.dart';
import '../../widgets/map/tracking_type_widget.dart';
import '../../widgets/common_widgets/positioned_visibility_opacity.dart';
import '../widgets/qr_create_page.dart';

class MapButtonsLandscapeLayer extends ConsumerStatefulWidget {
  const MapButtonsLandscapeLayer({super.key});

  @override
  ConsumerState<MapButtonsLandscapeLayer> createState() =>
      _MapButtonsLandscapeLayer();
}

class _MapButtonsLandscapeLayer extends ConsumerState<MapButtonsLandscapeLayer>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  StreamSubscription<LatLng?>? locationSubscription;
  AnimationController? animationController;
  Animation<double>? animation;
  final double bottomOffset = kIsWeb ? 30 : 40;
  final double rowDistOffset = 55;
  final double distanceOffset = 60;
  final double leftOffset = 10;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    animation = CurveTween(curve: Curves.easeIn).animate(animationController!);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    animationController = null;
    animation = null;
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    _removeOverlay();
    super.deactivate();
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraFollow followLocationState = ref.watch(cameraFollowLocationProvider);
    var trackingType = ref.watch(trackingTypeProvider);
    return SafeArea(
      child: Stack(fit: StackFit.passthrough, children: [
        //#######################################################################
        //Right side buttons
        //#######################################################################
        Positioned(
          right: 10,
          bottom: 40,
          child: Builder(builder: (context) {
            var isTracking = ref.watch(isTrackingProvider);
            var autoStop = ref.watch(autoStopTrackingProvider);
            var trackingWaitStatus = ref.watch(trackingWaitStatusProvider);

            //for future implementations - if (isActive == EventStatus.confirmed) {
            switch (trackingWaitStatus) {
              case TrackWaitStatus.starting:
                return FloatingActionButton(
                  onPressed: () {
                    LocationProvider().stopTracking();
                  },
                  child: CupertinoActivityIndicator(
                      color: CupertinoTheme.of(context).brightness ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black),
                );
              case TrackWaitStatus.stopping:
                return FloatingActionButton(
                  onPressed: () {
                    LocationProvider().stopTracking();
                  },
                  child: CupertinoActivityIndicator(
                      color: CupertinoTheme.of(context).brightness ==
                              Brightness.dark
                          ? Colors.red
                          : Colors.redAccent),
                );
              case TrackWaitStatus.none:
                break;
              case TrackWaitStatus.started:
                break;
              case TrackWaitStatus.stopped:
                break;
              case TrackWaitStatus.denied:
                break;
            }

            return GestureDetector(
              onLongPress: () async {
                kIsWeb ? null : LocationProvider().toggleAutoStop();
                await QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  title: Localize.of(context).autoStopTracking,
                  text: Localize.of(context).automatedStopInfo,
                  confirmBtnText: Localize.of(context).ok,
                );
              },
              child: FloatingActionButton(
                onPressed: () async {
                  switch (trackingType) {
                    case TrackingType.noTracking:
                      _toggleLocationService(TrackingType.userParticipating);
                      break;
                    case TrackingType.userParticipating:
                      await QuickAlert.show(
                          context: context,
                          showCancelBtn: true,
                          type: QuickAlertType.warning,
                          title: Localize.of(context).stopLocationTracking,
                          text: Localize.of(context).friendswillmissyou,
                          confirmBtnText: Localize.of(context).yes,
                          cancelBtnText: Localize.of(context).no,
                          onConfirmBtnTap: () async {
                            await _stopLocationService();
                            if (!context.mounted) return;
                            context.pop();
                          });
                      break;
                    case TrackingType.userNotParticipating:
                    case TrackingType.onlyTracking:
                      _stopLocationService();
                      break;
                  }
                },
                backgroundColor: isTracking && autoStop
                    ? CupertinoColors.systemYellow
                    : isTracking
                        ? CupertinoColors.systemRed
                        : CupertinoColors.activeGreen,
                heroTag: 'startStopTrackingBtnTag',
                child: Builder(builder: (context) {
                  var trackingType = ref.watch(trackingTypeProvider);
                  switch (trackingType) {
                    case TrackingType.noTracking:
                      return const Icon(CupertinoIcons.play_fill,
                          color: CupertinoColors.white);
                    case TrackingType.userParticipating:
                      return Icon(
                        isTracking && autoStop
                            ? Icons.pause
                            : isTracking
                                ? CupertinoIcons.stop_circle
                                : CupertinoIcons.play_fill,
                      );
                    case TrackingType.userNotParticipating:
                      return const ImageIcon(
                          AssetImage('assets/images/eyestop.png'));
                    case TrackingType.onlyTracking:
                      return const Icon(CupertinoIcons.stop_fill);
                  }
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
            visible:
                followLocationState == CameraFollow.followMe ? true : false,
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
                    ref.read(alignFlutterMapProvider.notifier).setState(
                        AlignFlutterMapState.alignDirectionAndPositionOnUpdate);
                    showToast(
                        message: '${Localize.of(context).mapFollowLocation} \n'
                            '${Localize.of(context).alignDirectionAndPositionOnUpdate}');
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
        Positioned(
          right: 10,
          bottom: 220,
          child: Builder(builder: (context) {
            return FloatingActionButton(
              heroTag: 'mapCompassHeroTag',
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: () {
                final controller = MapController.of(context);
                controller.rotate(0);
              },
              child: MapCompass(
                hideIfRotatedNorth: true,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                icon: Image.asset('assets/images/compass_2.png'),
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
        //if (ResponsiveBreakpoints.of(context).smallerThan(PHONE))
        if (!kIsWeb)
          Positioned(
            left: leftOffset,
            bottom: bottomOffset + rowDistOffset * 2,
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
            left: leftOffset,
            bottom: bottomOffset + rowDistOffset,
            height: 40,
            child: Builder(builder: (context) {
              var isTracking = ref.watch(isTrackingProvider);
              if (!isTracking) {
                return FloatingActionButton(
                  heroTag: 'viewerBtnTag',
                  //backgroundColor: Colors.blue,
                  onPressed: () async {
                    var res = await showCupertinoModalBottomSheet(
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
                            child: const TrackingTypeWidget(),
                          );
                        });
                    if (res != null) {
                      _toggleLocationService(res);
                    }
                  },
                  child: const Icon(
                    CupertinoIcons.play,
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
          Positioned(
            left: distanceOffset + leftOffset,
            bottom: bottomOffset + rowDistOffset,
            height: 40,
            child: Builder(builder: (context) {
              var messageProvider = ref.watch(messagesLogicProvider);
              return FloatingActionButton(
                  heroTag: 'messageBtnTag',
                  onPressed: () async {
                    ref
                        .read(goRouterProvider)
                        .pushNamed(AppRoute.messagesPage.name);
                  },
                  child: messageProvider.messages.isNotEmpty &&
                          messageProvider.readMessagesCount > 0
                      ? Badge(
                          label: Text(
                              messageProvider.readMessagesCount.toString()),
                          child: const Icon(Icons.mark_email_unread),
                        )
                      : const Icon(CupertinoIcons.envelope));
            }),
          ),
        if (!kIsWeb)
          PositionedVisibilityOpacity(
            left: 4 * distanceOffset + leftOffset,
            bottom: bottomOffset,
            //same height as qrcode in web
            height: 40,
            heroTag: 'resetBtnTag',
            //backgroundColor: Colors.blue,
            onPressed: () async {
              await LocationProvider().resetOdoMeterAndRoutePoints(context);
              setState(() {});
            },
            visibility: ref.watch(mapMenuVisibleProvider),
            child: const Icon(
              Icons.restart_alt,
              //color: Colors.white,
            ),
          ),
        PositionedVisibilityOpacity(
          left: 3 * distanceOffset + leftOffset,
          bottom: bottomOffset,
          height: 40,
          heroTag: 'zoomOutTagLandscape',
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
          heroTag: 'zoomInTagLandscape',
          left: 2 * distanceOffset + leftOffset,
          bottom: bottomOffset,
          height: 40,
          visibility: ref.watch(mapMenuVisibleProvider),
          onPressed: () {
            final controller = MapController.of(context);
            final camera = MapCamera.of(context);
            controller.move(controller.camera.center, camera.zoom + 0.5);
            //print('>Zoom ${controller.camera.zoom}');
            ref.read(headingMarkerSizeProvider.notifier).setSize(camera.zoom);
          },
          child: Icon(
            CupertinoIcons.zoom_in,
            semanticLabel: MapController.of(context).camera.zoom.toString(),
          ),
        ),
        PositionedVisibilityOpacity(
          left: distanceOffset + leftOffset,
          bottom: bottomOffset,
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
        //######################
        //# Menu button #########
        //######################
        Positioned(
          left: 10,
          bottom: bottomOffset,
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
        //#######################################################################
        //# Help buttons
        //#######################################################################
        // SafeArea(
        //child:
        Positioned(
          top: 15,
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
        // ),
      ]),
    );
  }

  //#######################################################################
  // Description overlay
  //#######################################################################

  OverlayState? overlayState;
  OverlayEntry? overlayEntry;

  void _removeOverlay() {
    if (overlayState != null) overlayEntry?.remove();
    overlayState = null;
  }

  void _showOverlay(BuildContext context, {required String text}) async {
    var bottomOffset = kIsWeb ? 10.0 : 10.0;

    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return SafeArea(
        maintainBottomViewPadding: true,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: kIsWeb ? 0 : 15,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    width: MediaQuery.sizeOf(context).width * 0.9,
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
                left: leftOffset,
                bottom: 150 + bottomOffset,
                height: 40,
                child: Builder(builder: (context) {
                  var isTracking = ref.watch(isTrackingProvider);
                  if (!isTracking) {
                    return Transform.rotate(
                      angle: -45,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: FadeTransition(
                          opacity: animation!,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              Localize.of(context).selectTrackingType,
                              style: TextStyle(
                                color: CupertinoTheme.of(context)
                                    .barBackgroundColor,
                                backgroundColor:
                                    CupertinoTheme.of(context).primaryColor,
                              ),
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
                left: leftOffset + 70,
                bottom: 130 + bottomOffset,
                height: 40,
                child: Builder(builder: (context) {
                  return Transform.rotate(
                    angle: -45,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: FadeTransition(
                        opacity: animation!,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            Localize.of(context).messages,
                            style: TextStyle(
                              color:
                                  CupertinoTheme.of(context).barBackgroundColor,
                              backgroundColor:
                                  CupertinoTheme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            if (!kIsWeb)
              Positioned(
                left: 250,
                bottom: 90 + bottomOffset,
                child: Transform.rotate(
                  angle: -45,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: FadeTransition(
                      opacity: animation!,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Reset Tacho',
                          style: TextStyle(
                            color:
                                CupertinoTheme.of(context).barBackgroundColor,
                            backgroundColor:
                                CupertinoTheme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 200,
              bottom: 80 + bottomOffset,
              child: Transform.rotate(
                angle: -45,
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
                          backgroundColor:
                              CupertinoTheme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 140,
              bottom: 80 + bottomOffset,
              child: Transform.rotate(
                angle: -45,
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
                          backgroundColor:
                              CupertinoTheme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 70,
              bottom: 110 + bottomOffset,
              child: Transform.rotate(
                angle: -45,
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
                          backgroundColor:
                              CupertinoTheme.of(context).primaryColor,
                        ),
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
                        Localize.of(context).mapAlign,
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
                      kIsWeb
                          ? Localize.of(context).startNoParticipationShort
                          : Localize.of(context).startParticipationShort,
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
                      Localize.of(context).mapFollow,
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
              left: 30,
              bottom: 70 + bottomOffset,
              child: Transform.rotate(
                angle: -45,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: FadeTransition(
                    opacity: animation!,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        Localize.of(context).menu,
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
          ],
        ),
      );
    });
    animationController!.addListener(() {
      overlayState?.setState(() {});
    });
    // inserting overlay entry
    overlayState?.insert(overlayEntry!);
    animationController!.forward();
    await Future.delayed(const Duration(seconds: 3)).whenComplete(() =>
            animationController!
                .reverse()
                .whenCompleteOrCancel(() => _removeOverlay())
        // removing overlay entry after stipulated time.
        );
  }

  ///Toggles between location tracking and view without user pos
  Future<bool> _toggleLocationService(TrackingType trackingType) async {
    return ref.read(isTrackingProvider.notifier).toggleTracking(trackingType);
  }

  Future<bool> _stopLocationService() async {
    MapController ctr = MapController.of(context);
    ctr.move(defaultLatLng, initialZoom);
    return ref.read(isTrackingProvider.notifier).stopTracking();
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
    locationSubscription?.cancel();
    locationSubscription = null;
    controller.move(defaultLatLng, controller.camera.zoom);
    locationSubscription = LocationProvider().trainHeadUpdateStream.listen(
      (value) {
        controller.move(value, controller.camera.zoom);
      },
    );
    ref.read(locationProvider).refreshRealtimeData(forceUpdate: true);
  }

  void startFollowingMeLocation() {
    final controller = MapController.maybeOf(context);
    final camera = MapCamera.maybeOf(context);
    if (controller == null || camera == null) {
      return;
    }
    locationSubscription?.cancel();
    locationSubscription = null;
    controller.move(
        LocationProvider().userLatLng ?? defaultLatLng, controller.camera.zoom);
    locationSubscription = LocationProvider().userLatLngStream.listen(
      (value) {
        controller.move(value, controller.camera.zoom);
      },
    );
    ref.read(locationProvider).refreshRealtimeData(forceUpdate: true);
  }

  void stopFollowingLocation() async {
    locationSubscription?.cancel();
    locationSubscription = null;
    setState(() {});
  }

  void _moveMapToDefault(MapController controller) {
    controller.move(defaultLatLng, controller.camera.zoom);
  }
}
