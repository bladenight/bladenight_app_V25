import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:location2/location2.dart' as loc2;
import 'package:permission_handler/permission_handler.dart'
    hide PermissionStatus;

import '../generated/l10n.dart';
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
      var prominentDisclosureResult =
          await FlutterPlatformAlert.showCustomAlert(
              windowTitle: Localize.current.requestLocationPermissionTitle,
              text: isAndroidPlatformGreater09BuildQ
                  ? Localize.current
                      .prominentdisclosuretrackingprealertandroidFromAndroid_V11
                  : Localize.current
                      .prominentdisclosuretrackingprealertandroidToAndroid_V10x,
              iconStyle: IconStyle.information,
              positiveButtonTitle: Localize.current.change,
              negativeButtonTitle: Localize.current.deny);
      if (prominentDisclosureResult == CustomButton.negativeButton) {
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
      var prominentDisclosureResult =
          await FlutterPlatformAlert.showCustomAlert(
              windowTitle: Localize.current.requestLocationPermissionTitle,
              text: isAndroidPlatformGreater09BuildQ
                  ? Localize.current
                      .prominentdisclosuretrackingprealertandroidFromAndroid_V11
                  : Localize.current
                      .prominentdisclosuretrackingprealertandroidToAndroid_V10x,
              iconStyle: IconStyle.information,
              positiveButtonTitle: Localize.current.change,
              negativeButtonTitle: Localize.current.deny);
      if (prominentDisclosureResult == CustomButton.negativeButton) {
        return false;
      }
    }
    //permanently denied or unknown
    return true;
  }

  Future<LocationPermissionStatus> requestAlwaysLocationPermissions() async {
    BnLog.info(
        text: 'requesting always permissions',
        className: toString(),
        methodName: 'requestAlwaysLocationPermission');
    var permissions = getLocationPermissions();
    if (HiveSettingsDB.hasAskedAlwaysAllowLocationPermission) {
      return permissions;
    }
    HiveSettingsDB.setHasAskedAlwaysAllowLocationPermission(true);
    var prominentDisclosureResult = await FlutterPlatformAlert.showCustomAlert(
        windowTitle: Localize.current.onlyWhenInUseEnabled,
        text: Localize.current.enableAlwaysLocationInfotext,
        iconStyle: IconStyle.information,
        positiveButtonTitle: Localize.current.changetoalways,
        negativeButtonTitle: Localize.current.leavewheninuse);
    if (prominentDisclosureResult == CustomButton.negativeButton) {
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

        var permanentDeniedResult = await FlutterPlatformAlert.showCustomAlert(
            windowTitle: Localize.current.alwaysPermantlyDenied,
            text: Localize.current.tryOpenAppSettings,
            iconStyle: IconStyle.information,
            positiveButtonTitle: Localize.current.openOperatingSystemSettings,
            negativeButtonTitle: Localize.current.leavewheninuse);
        if (permanentDeniedResult == CustomButton.positiveButton) {
          var res = await openAppSettings();
          if (res == false) {
            Fluttertoast.showToast(
                msg: Localize.current.couldNotOpenAppSettings);
            if (!kIsWeb) {
              BnLog.warning(
                  text:
                      'App settings could not opened while always location permissions are permanentlyDenied');
            }
          }
        }
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
    var prominentMotionDisclosureResult =
        await FlutterPlatformAlert.showCustomAlert(
            windowTitle: Localize.current.fitnessPermissionInfoTextTitle,
            text: Localize.current.fitnessPermissionInfoText,
            iconStyle: IconStyle.information,
            positiveButtonTitle: Localize.current.forward,
            negativeButtonTitle: Localize.current.deny);
    if (prominentMotionDisclosureResult == CustomButton.negativeButton) {
      HiveSettingsDB.setIsMotionDetectionDisabled(true);
      return false;
    } else {
      HiveSettingsDB.setIsMotionDetectionDisabled(false);
      return true;
      //await requestMotionSensorPermissions();
    }
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
    var permanentDeniedResult = await FlutterPlatformAlert.showCustomAlert(
        windowTitle: Localize.current.noLocationPermissionGrantedAlertTitle,
        text: Localize.current.tryOpenAppSettings,
        iconStyle: IconStyle.information,
        positiveButtonTitle: Localize.current.yes,
        negativeButtonTitle: Localize.current.no);
    if (permanentDeniedResult == CustomButton.positiveButton) {
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
      if (!kIsWeb) {
        BnLog.warning(
            text:
                'App settings could not opened while location permissions are permanently denied');
      }
      return false;
    }
    return true;
  }
}
