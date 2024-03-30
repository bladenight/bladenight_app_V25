import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../generated/l10n.dart';
import '../../../helpers/background_location_helper.dart';
import '../../../helpers/distance_converter.dart';
import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../helpers/location_permission_dialogs.dart';
import '../../../providers/is_tracking_provider.dart';
import '../../../providers/location_provider.dart';
import '../../widgets/scroll_quick_alert.dart';
import 'open_street_map_copyright.dart';

///Shows a row at bottom with OSM copyright and GPS speed widget
class GPSInfoAndMapCopyright extends StatefulWidget {
  const GPSInfoAndMapCopyright({super.key, this.showOdoMeter = true});

  final bool showOdoMeter;

  @override
  State<StatefulWidget> createState() => _GPSInfoAndMapCopyright();
}

class _GPSInfoAndMapCopyright extends State<GPSInfoAndMapCopyright> {
  late final Stream<bg.Location?> _locationStream;
  late double currentUserSpeed = -1;
  late double currentUserOdoDriven = 0.0;

  @override
  void initState() {
    super.initState();
    if (!widget.showOdoMeter) {
      return;
    }
    _locationStream = LocationProvider.instance.userBgLocationStream;
    _locationStream.listen((location) {
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
                              if (context.watch(
                                      gpsLocationPermissionsStatusProvider) !=
                                  LocationPermissionStatus.denied) {
                                var alwaysPermissionGranted = (context.watch(
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
                                        context.watch(isTrackingProvider)
                                            ? alwaysPermissionGranted
                                                ? CupertinoTheme.of(context)
                                                    .barBackgroundColor
                                                    .withOpacity(0.6)
                                                : CupertinoColors.systemYellow
                                            : CupertinoTheme.of(context)
                                                .barBackgroundColor
                                                .withOpacity(0.4),
                                    foregroundColor:
                                        context.watch(isTrackingProvider)
                                            ? alwaysPermissionGranted
                                                ? CupertinoTheme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.9)
                                                : CupertinoColors.black
                                            : CupertinoColors.black,
                                    icon: Row(children: [
                                      Icon(CupertinoIcons.gauge,
                                          color: context.watch(isMovingProvider)
                                              ? CupertinoTheme.of(context)
                                                  .primaryContrastingColor
                                              : CupertinoTheme.of(context)
                                                  .primaryColor),
                                      context.watch(isUserParticipatingProvider)
                                          ? ImageIcon(
                                              const AssetImage(
                                                  'assets/images/skater_icon_256.png'),
                                              color: context
                                                      .watch(isMovingProvider)
                                                  ? CupertinoTheme.of(context)
                                                      .primaryContrastingColor
                                                  : CupertinoTheme.of(context)
                                                      .primaryColor,
                                            )
                                          : const Icon(Icons.gps_fixed_sharp),
                                    ]),
                                    label: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Text(
                                        '${currentUserSpeed == -1 || !context.watch(isTrackingProvider) ? '- km/h' : currentUserSpeed.formatSpeedKmH()}  ${HiveSettingsDB.useAlternativeLocationProvider ? '' : '${currentUserOdoDriven.toStringAsFixed(1)} km'} ${alwaysPermissionGranted ? "" : "!"}',
                                        style: CupertinoTheme.of(context)
                                            .textTheme
                                            .navTitleTextStyle,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (alwaysPermissionGranted) {
                                        await LocationProvider.instance
                                            .resetOdoMeterAndRoutePoints(context);
                                      } else {
                                        await ScrollQuickAlert.show(
                                            context: context,
                                            showCancelBtn: true,
                                            type: QuickAlertType.info,
                                            title: Localize.of(context)
                                                .openOperatingSystemSettings,
                                            text:
                                                '${alwaysPermissionGranted ? "" : "\n${Localize.of(context).onlyWhileInUse}"} \n'
                                                '${Localize.of(context).userSpeed} ${context.watch(realUserSpeedProvider) == null ? '- km/h' : currentUserSpeed.formatSpeedKmH()} \n'
                                                '${Localize.of(context).distanceDrivenOdo} ${HiveSettingsDB.useAlternativeLocationProvider ? '' : '${currentUserOdoDriven.toStringAsFixed(1)} km'}\n'
                                                '${Localize.of(context).resetLongPress}',
                                            confirmBtnText: Localize.of(context)
                                                .openOperatingSystemSettings,
                                            cancelBtnText:
                                                Localize.of(context).cancel,
                                            onConfirmBtnTap: () async {
                                              await LocationPermissionDialog
                                                  .openSystemSettings();
                                              if (!context.mounted) return;
                                              Navigator.of(context).pop();
                                            });

                                      }
                                    },
                                  ),
                                );
                              } else if (context.watch(
                                          gpsLocationPermissionsStatusProvider) ==
                                      LocationPermissionStatus.denied &&
                                  HiveSettingsDB
                                          .useAlternativeLocationProvider ==
                                      false) {
                                return FloatingActionButton.extended(
                                  onPressed: () async {
                                    await ScrollQuickAlert.show(
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
