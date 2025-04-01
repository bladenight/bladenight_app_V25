import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../generated/l10n.dart';
import '../../../helpers/background_location_helper.dart';
import '../../../helpers/distance_converter.dart';
import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../helpers/location_permission_dialogs.dart';
import '../../../helpers/logger/logger.dart';
import '../../../providers/is_tracking_provider.dart';
import '../../../providers/location_provider.dart';
import '../../../providers/map/map_settings_provider.dart';
import '../../widgets/common_widgets/shadow_box_widget.dart';
import 'map_tiles_copyright.dart';
import 'tracking_icon_widget.dart';

///Shows a row at bottom with OSM copyright and GPS speed widget
class GPSInfoAndMapCopyright extends ConsumerStatefulWidget {
  const GPSInfoAndMapCopyright(
      {super.key, this.showOdoMeter = true, this.showSpeed = true});

  final bool showOdoMeter;
  final bool showSpeed;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GPSInfoAndMapCopyright();
}

class _GPSInfoAndMapCopyright extends ConsumerState<GPSInfoAndMapCopyright>
    with WidgetsBindingObserver {
  StreamSubscription<bg.Location?>? _locationStreamListener;

  //StreamSubscription<CompassEvent>? _compassListener;
  double currentUserSpeed = -1;
  double currentUserOdoDriven = 0.0;

  @override
  void initState() {
    super.initState();
    _initListeners();
  }

  void _initListeners() {
    if (kIsWeb) return;
    _locationStreamListener =
        LocationProvider().userBgLocationStream.listen((location) {
      setState(() {
        currentUserSpeed = location.coords.speed * 3.6;
        if (!widget.showOdoMeter) {
          return;
        }
        currentUserOdoDriven = location.odometer / 1000;
      });
    });
    /*if (!kIsWeb) {
      _compassListener = FlutterCompass.events?.listen((event) {
        if (event.heading != null) {
          //avoid extreme rebuilds
          if ((_compassHeading - event.heading!).abs() < 2) return;
          setState(() {
            _compassHeading = event.heading!;
          });
        }
      });
    }*/
  }

  void _stopListeners() {
    print('stop_gps_info_listeners');
    _locationStreamListener?.cancel();
    _locationStreamListener = null;
    //_compassListener?.cancel();
    //_compassListener = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    BnLog.info(text: 'GPS-info didChangeAppLifecycleState $state');
    switch (state) {
      case AppLifecycleState.resumed:
        _initListeners();
        break;
      case AppLifecycleState.paused:
        _stopListeners();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _stopListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: kIsWeb || !widget.showSpeed
          ? const Align(
              alignment: Alignment.bottomRight, child: MapTilesCopyright())
          : Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: MapTilesCopyright(),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: !widget.showOdoMeter
                              ? Container()
                              : SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Builder(builder: (context) {
                                    if (ref.read(
                                            gpsLocationPermissionsStatusProvider) !=
                                        LocationPermissionStatus.denied) {
                                      var alwaysPermissionGranted = (ref.read(
                                              gpsLocationPermissionsStatusProvider) ==
                                          LocationPermissionStatus.always);
                                      return GestureDetector(
                                        onLongPress: () async {
                                          await BackgroundGeolocationHelper
                                              .resetOdoMeter(context);
                                          setState(() {});
                                        },
                                        child: ShadowBoxWidget(
                                          boxShadowColor:
                                              alwaysPermissionGranted
                                                  ? Colors.green
                                                  : Colors.yellow,
                                          child: FloatingActionButton.extended(
                                            backgroundColor: ref
                                                    .watch(isTrackingProvider)
                                                ? alwaysPermissionGranted
                                                    ? CupertinoTheme.of(context)
                                                        .barBackgroundColor
                                                        .withValues(alpha: 0.6)
                                                    : CupertinoTheme.of(context)
                                                        .barBackgroundColor
                                                        .withValues(alpha: 0.4)
                                                : CupertinoTheme.of(context)
                                                    .barBackgroundColor
                                                    .withValues(alpha: 0.4),
                                            foregroundColor: ref
                                                    .watch(isTrackingProvider)
                                                ? alwaysPermissionGranted
                                                    ? CupertinoTheme.of(context)
                                                        .primaryColor
                                                        .withValues(alpha: 0.9)
                                                    : CupertinoColors.black
                                                : CupertinoColors.black,
                                            icon: Row(children: [
                                              !kIsWeb &&
                                                      ref.watch(
                                                          showCompassProvider)
                                                  ? Container()
                                                  /*Builder(builder: (context) {
                                              var direction = _compassHeading;
                                              return Transform.rotate(
                                                angle: (direction *
                                                    (math.pi / 180) *
                                                    -1),
                                                child: Image.asset(
                                                    width: 30,
                                                    height: 30,
                                                    'assets/images/compass_3.png'),
                                              );
                                            })*/
                                                  : Icon(CupertinoIcons.gauge,
                                                      color: CupertinoTheme.of(
                                                              context)
                                                          .primaryColor),
                                              const TrackingIconWidget(
                                                innerIconSize: 12,
                                                radius: 12,
                                              ),
                                            ]),
                                            label: FittedBox(
                                              fit: BoxFit.fill,
                                              child: Text(
                                                '${currentUserSpeed == -1 || !ref.watch(isTrackingProvider) ? '- km/h' : currentUserSpeed.formatSpeedKmH()}  ${HiveSettingsDB.useAlternativeLocationProvider ? '' : '${currentUserOdoDriven.toStringAsFixed(1)} km'} ${alwaysPermissionGranted ? "" : "!"}',
                                                style:
                                                    CupertinoTheme.of(context)
                                                        .textTheme
                                                        .navTitleTextStyle,
                                              ),
                                            ),
                                            onPressed: () async {
                                              await LocationProvider()
                                                  .resetOdoMeterAndRoutePoints(
                                                      context);
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      );
                                    } else if (ref.watch(
                                                gpsLocationPermissionsStatusProvider) ==
                                            LocationPermissionStatus.denied &&
                                        HiveSettingsDB
                                                .useAlternativeLocationProvider ==
                                            false) {
                                      return FloatingActionButton.extended(
                                        onPressed: () async {
                                          await QuickAlert.show(
                                              context: context,
                                              showCancelBtn: true,
                                              type: QuickAlertType.warning,
                                              title: Localize.of(context)
                                                  .noLocationPermissionGrantedAlertTitle,
                                              text: Localize.of(context)
                                                  .locationServiceOff,
                                              onConfirmBtnTap: () {
                                                Geolocator
                                                    .openLocationSettings();
                                                context.pop();
                                              });
                                        },
                                        backgroundColor:
                                            CupertinoColors.activeOrange,
                                        foregroundColor: CupertinoColors.black,
                                        tooltip: Localize.of(context)
                                            .locationServiceOff,
                                        icon: Icon(
                                            CupertinoIcons.location_slash_fill),
                                        label: const Text(
                                          '',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),
                                ),
                        ),
                      ]),
                ),
              ),
            ),
    );
  }
}
