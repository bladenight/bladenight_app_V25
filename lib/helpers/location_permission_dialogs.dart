import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart'
    hide PermissionStatus;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../generated/l10n.dart';
import '../main.dart';
import 'device_info_helper.dart';
import 'hive_box/hive_settings_db.dart';
import 'logger/logger.dart';

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
  ///Request location permission from user
  ///returns [LocationPermission] status
  Future<LocationPermissionStatus> getLocationPermissions(
      BuildContext context) async {
    //get android version, on V11 you need 'always' permissions to use location, when app is not in Foreground
    var isAndroidPlatformGreater09BuildQ =
        await DeviceHelper.isAndroidGreaterVNine();
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      var denied = false;
      await QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
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
            return rootNavigatorKey.currentState?.pop();
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

    final locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      var acceptLocation = await QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
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
            return rootNavigatorKey.currentState?.pop(false);
          },
          onConfirmBtnTap: () {
            return rootNavigatorKey.currentState?.pop(true);
          });
      return acceptLocation ?? false;
    }
    return true;
  }

  Future<LocationPermissionStatus> requestAlwaysLocationPermissions() async {
    var context = rootNavigatorKey.currentContext!;
    BnLog.info(
        text: 'requesting always permissions',
        className: toString(),
        methodName: 'requestAlwaysLocationPermission');
    var permissions = getLocationPermissions(context);
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
      final res = await Geolocator.openLocationSettings();
      if (!res) {
        await QuickAlert.show(
            context: rootNavigatorKey.currentContext!,
            showCancelBtn: true,
            type: QuickAlertType.info,
            title: Localize.current.alwaysPermantlyDenied,
            text: Localize.current.tryOpenAppSettings,
            confirmBtnText: Localize.current.openOperatingSystemSettings,
            cancelBtnText: Localize.current.leavewheninuse,
            onConfirmBtnTap: () async {
              var res = await Geolocator.openAppSettings();
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

  ///Returns Location accuracy state
  Future<LocationAccuracyStatus> getLocationAccuracy() async {
    return Geolocator.getLocationAccuracy();
  }

  ///Check on Android/Ios  >14 low locationPrecision
  Future<bool> getLocationAccuracyIsPrecise() async {
    var precision = await getLocationAccuracy();
    return precision == LocationAccuracyStatus.precise;
  }

  Future<LocationAccuracyStatus> requestPreciseLocation() async {
    var context = rootNavigatorKey.currentContext!;
    BnLog.info(
        text: 'requesting precise location',
        className: toString(),
        methodName: 'requestPreciseLocation');
    if (await getLocationAccuracyIsPrecise()) {
      return LocationAccuracyStatus.precise;
    }
    if (HiveSettingsDB.hasAskedPreciseLocation) {
      return LocationAccuracyStatus.reduced;
    }
    HiveSettingsDB.setHasPreciseLocationAsked(true);
    var cancelPressed = false;
    if (!context.mounted) {
      return LocationAccuracyStatus.reduced;
    }
    await QuickAlert.show(
        context: context,
        showCancelBtn: true,
        type: QuickAlertType.confirm,
        title: Localize.current.onlyReducedLocationAccuracyTitle,
        text: Localize.current.onlyReducedLocationAccuracyText,
        confirmBtnText: Localize.current.openOperatingSystemSettings,
        cancelBtnText: Localize.current.cancel,
        onCancelBtnTap: () {
          cancelPressed = true;
        });
    if (cancelPressed) {
      return LocationAccuracyStatus.reduced;
    } else {
      return await Geolocator.requestTemporaryFullAccuracy(
          purposeKey: 'procession');
    }
  }

  ///Returns fitness activity state
  Future<bool> getMotionSensorStatus() async {
    var activityRecognitionStatus = await Permission.activityRecognition.status;
    if (activityRecognitionStatus.isDenied ||
        activityRecognitionStatus.isPermanentlyDenied) {
      return false;
    }
    return true;
  }

  Future<bool> showMotionSensorProminentDisclosure(BuildContext context) async {
    var prominentMotionDisclosureResult = true;
    await QuickAlert.show(
        context: context,
        showCancelBtn: true,
        type: QuickAlertType.info,
        title: Localize.current.fitnessPermissionInfoTextTitle,
        text: Localize.current.fitnessPermissionInfoText,
        confirmBtnText: Localize.current.forward,
        cancelBtnText: Localize.current.deny,
        onConfirmBtnTap: () {
          HiveSettingsDB.setIsMotionDetectionDisabled(false);
          prominentMotionDisclosureResult = false;
          return rootNavigatorKey.currentState?.pop();
        },
        onCancelBtnTap: () {
          HiveSettingsDB.setIsMotionDetectionDisabled(true);
          prominentMotionDisclosureResult = true;
          //if (!mounted) return;
          return rootNavigatorKey.currentState?.pop();
        });
    return prominentMotionDisclosureResult;
  }

  ///Returns [LocationPermissionStatus] of device
  Future<LocationPermissionStatus> getPermissionsStatus() async {
    Stopwatch sw = Stopwatch();
    sw.start();
    LocationPermission permission = await Geolocator.checkPermission();

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
    if (permission == LocationPermission.always) {
      return LocationPermissionStatus.always;
    }
    if (permission == LocationPermission.whileInUse) {
      return LocationPermissionStatus.whenInUse;
    }
    return LocationPermissionStatus.denied;
  }

  Future<bool> requestAndOpenAppSettings(BuildContext context) async {
    var permanentDeniedResult = true;

    await QuickAlert.show(
        context: context,
        showCancelBtn: true,
        type: QuickAlertType.info,
        title: Localize.current.noLocationPermissionGrantedAlertTitle,
        text: Localize.current.tryOpenAppSettings,
        confirmBtnText: Localize.current.yes,
        cancelBtnText: Localize.current.no,
        onConfirmBtnTap: () {
          permanentDeniedResult = true;
          return rootNavigatorKey.currentState?.pop();
        });
    if (permanentDeniedResult) {
      return await openAppSettings();
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
