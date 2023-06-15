import 'package:device_info_plus/device_info_plus.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

import '../generated/l10n.dart';
import 'device_info_helper.dart';
import 'hive_box/hive_settings_db.dart';

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

    var isAndroidPlatformGreater09BuildQ = await DeviceHelper.isAndroidGreaterVNine();

    if (kIsWeb) {
      return LocationPermissionStatus.locationNotEnabled;
    }
    var permissionWithService = Permission.location;
    var locationPermission = await permissionWithService.status;

    if (locationPermission == PermissionStatus.denied) {
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

    var permissionWithService = Permission.location;
    var locationPermission = await permissionWithService.status;

    if (locationPermission == PermissionStatus.denied) {
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
    if (!kIsWeb) {
      FLog.info(
        text: 'requesting always permissions',
        className: toString(),
        methodName: 'requestAlwaysLocationPermission');
    }
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
      var permissionWithService = Permission.locationAlways;
      var res = await permissionWithService.request();
      if (res == PermissionStatus.granted) {
        return LocationPermissionStatus.always;
      }
      if (res == PermissionStatus.permanentlyDenied) {
        if (!kIsWeb) {
          FLog.warning(
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
              FLog.warning(
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
    var isAlways = await Permission.locationAlways.status;
    if (isAlways == PermissionStatus.granted) {
      return LocationPermissionStatus.always;
    }
    var whenInUse = await Permission.locationWhenInUse.status;
    if (whenInUse == PermissionStatus.granted) {
      return LocationPermissionStatus.whenInUse;
    }
    return LocationPermissionStatus.denied;
  }

  Future<MotionSensorPermissionStatus>
      getMotionSensorPermissionsStatus() async {
    var isMotionSensorEnabled = await Permission.sensors.status;
    if (isMotionSensorEnabled == PermissionStatus.granted) {
      return MotionSensorPermissionStatus.granted;
    }

    return MotionSensorPermissionStatus.denied;
  }

  Future<MotionSensorPermissionStatus> requestMotionSensorPermissions() async {
    var permissionWithService = Permission.activityRecognition;
    var res = await permissionWithService.request();

    if (res == PermissionStatus.granted) {
      return MotionSensorPermissionStatus.granted;
    }
    return MotionSensorPermissionStatus.denied;
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
          FLog.warning(
            text:
                'App settings could not opened while location permissions are permanently denied');
        }
        return false;
      }
      return true;
    }
    return false;
  }
  static Future<bool> openSystemSettings()async {
    var res = await openAppSettings();
    if (res == false) {
      Fluttertoast.showToast(msg: Localize.current.couldNotOpenAppSettings);
      if (!kIsWeb) {
        FLog.warning(
          text:
          'App settings could not opened while location permissions are permanently denied');
      }
      return false;
    }
    return true;
  }

}
