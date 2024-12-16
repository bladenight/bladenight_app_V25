import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:location2/location2.dart' as loc2;
import 'package:permission_handler/permission_handler.dart'
    hide PermissionStatus;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../generated/l10n.dart';
import '../main.dart';
import 'device_info_helper.dart';
import 'hive_box/hive_settings_db.dart';
import 'logger.dart';

enum LocationPermissionStatus {
  unknown,
  notDetermined,
  denied,
  whenInUse,
  always,
  locationNotEnabled,
  restricted,
  reduced
}

enum MotionSensorPermissionStatus {
  unknown,
  notDetermined,
  granted,
  restricted,
  denied
}

class LocationPermissions {
  late LocationPermissionStatus permissionStatus =
      LocationPermissionStatus.notDetermined;

  LocationPermissions(this.permissionStatus);
}

class LocationPermissionDialog {
  ///Request and returns [LocationPermissionStatus]
  Future<LocationPermissionStatus> getLocationPermissions() async {
    //get android version, on V11 you need 'always' permissions to use location, when app is not in Foreground

    var isAndroidPlatformGreater09BuildQ =
        await DeviceHelper.isAndroidGreaterVNine();

    if (kIsWeb) {
      return LocationPermissionStatus.locationNotEnabled;
    }
    final locationPermission = await loc2.getLocationPermissionStatus();
    if (locationPermission.locationPermissionId ==
        loc2.LocationPermission.denied.index) {
      var denied = false;
      await QuickAlert.show(
          context: navigatorKey.currentContext!,
          showCancelBtn: true,
          type: QuickAlertType.info,
          title: Localize.current.requestLocationPermissionTitle,
          text: isAndroidPlatformGreater09BuildQ
              ? Localize.current
                  .prominentdisclosuretrackingprealertandroidFromAndroid_V11
              : Localize.current
                  .prominentdisclosuretrackingprealertandroidToAndroid_V10x,
          confirmBtnText: Localize.current.change,
          cancelBtnText: Localize.current.deny,
          onCancelBtnTap: () {
            denied = true;
            return navigatorKey.currentState?.pop();
          });
      if (denied) {
        //user denies request
        return LocationPermissionStatus.denied;
      }
    }
    return getPermissionsStatus();
  }

  ///Shows Disclosure on Android and return true if positive or false on denied forever or negative answer
  Future<bool> showProminentAndroidDisclosure() async {
    double? platformVersion;
    if (GetPlatform.isAndroid) {
      var androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
      platformVersion = double.tryParse(androidDeviceInfo.version.release);
    } else {
      return true;
    }
    var isAndroidPlatformGreater09BuildQ = GetPlatform.isAndroid &&
        platformVersion != null &&
        platformVersion >= 10;

    final locationPermission = await loc2.getLocationPermissionStatus();
    if (locationPermission.locationPermissionId ==
        loc2.LocationPermission.denied.index) {
      var acceptLocation = await QuickAlert.show(
          context: navigatorKey.currentContext!,
          showCancelBtn: true,
          type: QuickAlertType.confirm,
          title: Localize.current.requestLocationPermissionTitle,
          text: isAndroidPlatformGreater09BuildQ
              ? Localize.current
                  .prominentdisclosuretrackingprealertandroidFromAndroid_V11
              : Localize.current
                  .prominentdisclosuretrackingprealertandroidToAndroid_V10x,
          confirmBtnText: Localize.current.change,
          cancelBtnText: Localize.current.deny,
          onCancelBtnTap: () {
            return navigatorKey.currentState?.pop(false);
          },
          onConfirmBtnTap: () {
            return navigatorKey.currentState?.pop(true);
          });
      return acceptLocation ?? false;
    }
    //permanently denied or unknown
    return true;
  }

  Future<LocationPermissionStatus> requestAlwaysLocationPermissions(
      BuildContext context) async {
    BnLog.info(
        text: 'requesting always permissions',
        className: toString(),
        methodName: 'requestAlwaysLocationPermission');
    var permissions = getLocationPermissions();
    if (HiveSettingsDB.hasAskedAlwaysAllowLocationPermission) {
      return permissions;
    }
    HiveSettingsDB.setHasAskedAlwaysAllowLocationPermission(true);
    var cancelPressed = false;
    await QuickAlert.show(
        context: context,
        showCancelBtn: true,
        type: QuickAlertType.info,
        title: Localize.current.onlyWhenInUseEnabled,
        text: Localize.current.enableAlwaysLocationInfotext,
        confirmBtnText: Localize.current.changetoalways,
        cancelBtnText: Localize.current.leavewheninuse,
        onCancelBtnTap: () {
          cancelPressed = true;
        });
    if (cancelPressed) {
      return getPermissionsStatus();
    } else {
      final res = await loc2
          .requestLocationPermission(loc2.LocationPermission.authorizedAlways);
      if (res == loc2.LocationPermission.authorizedAlways) {
        return LocationPermissionStatus.always;
      }
      if (res == loc2.LocationPermission.denied) {
        if (!kIsWeb) {
          BnLog.warning(
              text: 'requestAlwaysOnAndroid permissions permanentlyDenied');
        }

        await QuickAlert.show(
            context: navigatorKey.currentContext!,
            showCancelBtn: true,
            type: QuickAlertType.info,
            title: Localize.current.alwaysPermantlyDenied,
            text: Localize.current.tryOpenAppSettings,
            confirmBtnText: Localize.current.openOperatingSystemSettings,
            cancelBtnText: Localize.current.leavewheninuse,
            onConfirmBtnTap: () async {
              var res = await openAppSettings();
              if (res == false) {
                Fluttertoast.showToast(
                    msg: Localize.current.couldNotOpenAppSettings);
                BnLog.warning(
                    text:
                        'App settings could not opened while always location permissions are permanentlyDenied');
              }
              if (context.mounted) {
                return context.pop();
              }
            });
      }
    }
    return getPermissionsStatus();
  }

  ///Returns Fitnessactivity state
  Future<bool> getMotionSensorStatus() async {
    var activityRecognitionStatus = await Permission.activityRecognition.status;
    if (activityRecognitionStatus.isDenied ||
        activityRecognitionStatus.isPermanentlyDenied) {
      return false;
    }
    return true;
  }

  Future<bool> showMotionSensorProminentDisclosure() async {
    var prominentMotionDisclosureResult = true;
    await QuickAlert.show(
        context: navigatorKey.currentContext!,
        showCancelBtn: true,
        type: QuickAlertType.info,
        title: Localize.current.fitnessPermissionInfoTextTitle,
        text: Localize.current.fitnessPermissionInfoText,
        confirmBtnText: Localize.current.forward,
        cancelBtnText: Localize.current.deny,
        onConfirmBtnTap: () {
          HiveSettingsDB.setIsMotionDetectionDisabled(false);
          prominentMotionDisclosureResult = false;
          return navigatorKey.currentState?.pop();
        },
        onCancelBtnTap: () {
          HiveSettingsDB.setIsMotionDetectionDisabled(true);
          prominentMotionDisclosureResult = true;
          //if (!mounted) return;
          return navigatorKey.currentState?.pop();
        });
    return prominentMotionDisclosureResult;
  }

  ///Returns [LocationPermissionStatus] of device
  Future<LocationPermissionStatus> getPermissionsStatus() async {
    Stopwatch sw = Stopwatch();
    sw.start();
    final permissionStatus = await loc2.getLocationPermissionStatus();
    //hangs for 9 sec on app start
    //var isAlways = await Permission.locationAlways.status;
    if (!kIsWeb) {
      BnLog.info(
          className: 'locationProvider',
          methodName: 'init',
          text: 'init get permissions status ${sw.elapsedMicroseconds} micros');
    }
    if (kDebugMode) {
      print(
          'init get permissions status ${sw.elapsedMicroseconds} micros /${sw.elapsedMilliseconds}ms');
    }
    sw.stop();
    if (permissionStatus.locationPermissionId ==
        loc2.PermissionStatus.authorizedAlways.index) {
      return LocationPermissionStatus.always;
    }
    if (permissionStatus.locationPermissionId ==
        loc2.PermissionStatus.authorizedWhenInUse.index) {
      return LocationPermissionStatus.whenInUse;
    }
    return LocationPermissionStatus.denied;
  }

  Future<bool> requestAndOpenAppSettings() async {
    var permanentDeniedResult = true;

    await QuickAlert.show(
        context: navigatorKey.currentContext!,
        showCancelBtn: true,
        type: QuickAlertType.info,
        title: Localize.current.noLocationPermissionGrantedAlertTitle,
        text: Localize.current.tryOpenAppSettings,
        confirmBtnText: Localize.current.yes,
        cancelBtnText: Localize.current.no,
        onConfirmBtnTap: () {
          permanentDeniedResult = true;
          return navigatorKey.currentState?.pop();
        });
    if (permanentDeniedResult) {
      var res = await openAppSettings();
      if (res == false) {
        Fluttertoast.showToast(msg: Localize.current.couldNotOpenAppSettings);
        if (!kIsWeb) {
          BnLog.warning(
              text:
                  'App settings could not opened while location permissions are permanently denied');
        }
        return false;
      }
      return true;
    }
    return false;
  }

  static Future<bool> openSystemSettings() async {
    var res = await openAppSettings();
    if (res == false) {
      Fluttertoast.showToast(msg: Localize.current.couldNotOpenAppSettings);
      BnLog.warning(
          text:
              'App settings could not opened while location permissions are permanently denied');
      return false;
    }
    return true;
  }
}
