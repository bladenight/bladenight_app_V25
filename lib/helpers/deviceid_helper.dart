import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Create DeviceId in Format '920ecff0fb9b56577d44'
///
class DeviceId {
  static const int length = 20;
  static const String prefid = 'deviceid_key';

  static Future<String> get getId async {
    //await removeDeviceIdFromPrefs(); //for testing
    var id = await _readDeviceIdFromPrefs();
    if (id == null) {
      return await _generateAndSaveDeviceId();
    } else {
      return id;
    }
  }

  static Future<String> _generateAndSaveDeviceId() async {
    Random random = Random();
    String id = '';
    /*if (Device.get().isIos) {
      id += 'i';
    } else if (Device.get().isAndroid) {
      id += 'a';
    } else {
      id += 'u';
    }*/

    while (id.length < length) {
      id += (random.nextInt(16)).toRadixString(16);
    }
    var resultid = id.substring(0, length);
    await saveDeviceIdToPrefs(resultid);
    return resultid;
  }

  static Future<String?> _readDeviceIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(prefid);
  }

  ///Remove id from prefs, so it can be recreate next time.
  ///Warning friends will be lost
  static Future<bool> removeDeviceIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(prefid);
  }

  static Future<bool> saveDeviceIdToPrefs(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(prefid, id);
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
