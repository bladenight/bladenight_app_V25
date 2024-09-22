import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../generated/l10n.dart';
import '../../../helpers/background_location_helper.dart';
import '../../../helpers/distance_converter.dart';
import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../helpers/location_permission_dialogs.dart';
import '../../../providers/is_tracking_provider.dart';
import '../../../providers/location_provider.dart';
import '../../../providers/map/compass_provider.dart';
import '../../../providers/map/map_settings_provider.dart';
import 'open_street_map_copyright.dart';
import 'tracking_icon_widget.dart';

///Shows a row at bottom with OSM copyright and GPS speed widget
class GPSInfoAndMapCopyright extends ConsumerStatefulWidget {
  const GPSInfoAndMapCopyright({super.key, this.showOdoMeter = true});

  final bool showOdoMeter;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GPSInfoAndMapCopyright();
}

class _GPSInfoAndMapCopyright extends ConsumerState<GPSInfoAndMapCopyright> {
  Stream<bg.Location?>? _locationStream;
  StreamSubscription<bg.Location?>? _locationStreamListener;
  double currentUserSpeed = -1;
  double currentUserOdoDriven = 0.0;

  @override
  void initState() {
    super.initState();
    if (!widget.showOdoMeter) {
      return;
    }
    _locationStream = LocationProvider().userBgLocationStream;
    _locationStreamListener = _locationStream?.listen((location) {
      setState(() {
        if (location == null) {
          return;
        }
        currentUserSpeed = location.coords.speed * 3.6;
        currentUserOdoDriven = location.odometer / 1000;
      });
    });
  }

  @override
  void dispose() {
    if (_locationStreamListener != null) {
      _locationStreamListener?.cancel();
      _locationStreamListener = null;
    }
    _locationStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? const Align(
            alignment: Alignment.bottomRight, child: OpenStreetMapCopyright())
        : Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                height: 30,
                width: double.infinity,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Expanded(
                    flex: 1,
                    child: OpenStreetMapCopyright(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: !widget.showOdoMeter
                        ? Container()
                        : SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
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
                                  child: FloatingActionButton.extended(
                                    backgroundColor:
                                        ref.watch(isTrackingProvider)
                                            ? alwaysPermissionGranted
                                                ? CupertinoTheme.of(context)
                                                    .barBackgroundColor
                                                    .withOpacity(0.6)
                                                : CupertinoColors.systemYellow
                                            : CupertinoTheme.of(context)
                                                .barBackgroundColor
                                                .withOpacity(0.4),
                                    foregroundColor:
                                        ref.watch(isTrackingProvider)
                                            ? alwaysPermissionGranted
                                                ? CupertinoTheme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.9)
                                                : CupertinoColors.black
                                            : CupertinoColors.black,
                                    icon: Row(children: [
                                      !kIsWeb && ref.watch(showCompassProvider)
                                          ? Builder(builder: (context) {
                                              var direction =
                                                  ref.watch(compassProvider);
                                              return Transform.rotate(
                                                angle: (direction *
                                                    (math.pi / 180) *
                                                    -1),
                                                child: Image.asset(
                                                    width: 30,
                                                    height: 30,
                                                    'assets/images/compass_3.png'),
                                              );
                                            })
                                          : Icon(CupertinoIcons.gauge,
                                              color: CupertinoTheme.of(context)
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
                                        style: CupertinoTheme.of(context)
                                            .textTheme
                                            .navTitleTextStyle,
                                      ),
                                    ),
                                    onPressed: () async {
                                      await LocationProvider()
                                          .resetOdoMeterAndRoutePoints(context);
                                      setState(() {});
                                    },
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
                                    );
                                  },
                                  backgroundColor: CupertinoColors.activeOrange,
                                  foregroundColor: CupertinoColors.white,
                                  tooltip:
                                      Localize.of(context).locationServiceOff,
                                  icon: const Row(children: [
                                    Icon(CupertinoIcons.location_slash_fill),
                                  ]),
                                  label: const Text(
                                    '',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
          );
  }
}
