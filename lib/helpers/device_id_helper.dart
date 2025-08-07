import 'dart:async';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'hive_box/hive_settings_db.dart';

///Create DeviceId in Format '920ecff0fb9b56577d44'
///
class DeviceId {
  static const int length = 20;
  static const String prefid = 'deviceid_key';

  static Future<String> initAppId() async {
    if (HiveSettingsDB.appId.isEmpty || !HiveSettingsDB.firstStart) {
      var id = await _readDeviceIdFromPrefs();
      if (id != null) {
        await HiveSettingsDB.setAppId(id);
        HiveSettingsDB.setFirstStart(false);
        return id;
      } else {
        var resultAppId = generateDeviceIdSync();
        await HiveSettingsDB.setAppId(resultAppId);
        return resultAppId;
      }
    }
    return HiveSettingsDB.appId;
  }

  static String get appId {
    return HiveSettingsDB.appId;
  }

  static Future<String?> _readDeviceIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      prefid,
    );
  }

  static String generateDeviceIdSync() {
    Random random = Random();
    String id = '';

    while (id.length < length) {
      id += (random.nextInt(16)).toRadixString(16);
    }
    return id.substring(0, length);
  }

  ///Get manufacturer
  static String get deviceManufacturer {
    if (GetPlatform.isIOS) {
      return 'Apple';
    } else if (GetPlatform.isAndroid) {
      return 'Android';
    } else if (GetPlatform.isMacOS) {
      return 'MacOS';
    } else if (GetPlatform.isWeb) {
      return 'WebApp';
    } else {
      return 'unknown${GetPlatform()}';
    }
  }

  static Future<String> get getOSVersion async {
    try {
      if (kIsWeb) return 'WEB';
      var dev = await DeviceInfoPlugin().deviceInfo;
      if (dev is AndroidDeviceInfo) {
        var info = dev;
        return info.version.release;
      }
      if (dev is IosDeviceInfo) {
        var info = dev;
        return info.systemVersion;
      }
      return '0';
    } catch (e) {
      return '-1';
    }
  }

  //Return wheater platform is android and greater or equal buildQ
  static Future<bool> isAndroidPlatformGreater09BuildQ() async {
    double? platformVersion;
    if (GetPlatform.isAndroid) {
      var androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
      platformVersion = double.tryParse(androidDeviceInfo.version.release);
    }
    return GetPlatform.isAndroid &&
        platformVersion != null &&
        platformVersion >= 10;
  }

  static Future<String> get appBuildNumber async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }
}
