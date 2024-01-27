import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../generated/l10n.dart';
import '../../helpers/background_location_helper.dart';
import '../../helpers/distance_converter.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/location_permission_dialogs.dart';
import '../../providers/location_provider.dart';

class UserSpeedAndOdometer extends StatefulWidget {
  const UserSpeedAndOdometer({super.key});

  @override
  State<StatefulWidget> createState() => _UserSpeedOdometer();
}

class _UserSpeedOdometer extends State<UserSpeedAndOdometer> {
  late final Stream<bg.Location?> _locationStream;
  late double currentUserSpeed;
  late double currentUserOdoDriven;

  @override
  void initState() {
    super.initState();
    _locationStream = LocationProvider.instance.userBgLocationStream;
    _locationStream.listen((location) {
      setState(() {
        if (location == null) {
          return;
        }
        currentUserSpeed = location.coords.speed;
        currentUserOdoDriven = location.odometer;
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
        ? Container()
        : Positioned(
            right: 5,
            bottom: 5,
            height: 30,
            width: MediaQuery.of(context).size.width * .60,
            child: Builder(builder: (context) {
              if (context.watch(gpsLocationPermissionsStatusProvider) !=
                  LocationPermissionStatus.denied) {
                var alwaysPermissionGranted =
                    (context.watch(gpsLocationPermissionsStatusProvider) ==
                        LocationPermissionStatus.always);
                return GestureDetector(
                  onLongPress: () async {
                    await BackgroundGeolocationHelper.resetOdoMeter(context);
                    setState(() {});
                  },
                  child: FloatingActionButton.extended(
                    backgroundColor: context.watch(isTrackingProvider)
                        ? alwaysPermissionGranted
                            ? CupertinoTheme.of(context)
                                .barBackgroundColor
                                .withOpacity(0.6)
                            : CupertinoColors.systemYellow
                        : CupertinoTheme.of(context)
                            .barBackgroundColor
                            .withOpacity(0.4),
                    foregroundColor: context.watch(isTrackingProvider)
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
                              : CupertinoTheme.of(context).primaryColor),
                      context.watch(isUserParticipatingProvider)
                          ? ImageIcon(
                              const AssetImage(
                                  'assets/images/skaterIcon_256.png'),
                              color: context.watch(isMovingProvider)
                                  ? CupertinoTheme.of(context)
                                      .primaryContrastingColor
                                  : CupertinoTheme.of(context).primaryColor,
                            )
                          : const Icon(Icons.gps_fixed_sharp),
                    ]),
                    label: FittedBox(
                      fit: BoxFit.fill,
                      child: Text(
                        '${currentUserSpeed == -1 ? '- km/h' : currentUserSpeed.formatSpeedKmH()}  ${HiveSettingsDB.useAlternativeLocationProvider ? '' : '${currentUserOdoDriven.toStringAsFixed(1)} km'} ${alwaysPermissionGranted ? "" : "!"}',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .navTitleTextStyle,
                      ),
                    ),
                    onPressed: () async {
                      if (alwaysPermissionGranted) {
                        await LocationProvider.instance
                            .resetOdoMeterAndRoutePoints();
                      } else {
                        var reqResult =
                            await FlutterPlatformAlert.showCustomAlert(
                                windowTitle: Localize.of(context)
                                    .openOperatingSystemSettings,
                                iconStyle: IconStyle.information,
                                text:
                                    '${alwaysPermissionGranted ? "" : "\n${Localize.of(context).onlyWhileInUse}"} \n'
                                    '${Localize.of(context).userSpeed} ${context.watch(realUserSpeedProvider) == null ? '- km/h' : currentUserSpeed.formatSpeedKmH()} \n'
                                    '${Localize.of(context).distanceDrivenOdo} ${HiveSettingsDB.useAlternativeLocationProvider ? '' : '${currentUserOdoDriven.toStringAsFixed(1)} km'}\n'
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
              } else if (context.watch(gpsLocationPermissionsStatusProvider) ==
                      LocationPermissionStatus.denied &&
                  HiveSettingsDB.useAlternativeLocationProvider == false) {
                return FloatingActionButton.extended(
                  onPressed: () async {
                    FlutterPlatformAlert.showAlert(
                        windowTitle: Localize.of(context)
                            .noLocationPermissionGrantedAlertTitle,
                        text: Localize.of(context).locationServiceOff,
                        iconStyle: IconStyle.warning);
                  },
                  backgroundColor: CupertinoColors.activeOrange,
                  foregroundColor: CupertinoColors.white,
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
          );
  }
}
