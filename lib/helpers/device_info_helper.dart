import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_io/io.dart';

import '../models/app_version.dart';

class DeviceHelper {
  static Future<bool> deviceIsIPad() async {
    //Ipad crash workaround - more than 2 buttons are crashing in FlutterPlatformAlert.showCustomAlert
    try {
      var dev = await DeviceInfoPlugin().deviceInfo;
      var device = dev as IosDeviceInfo;
      if (device.model == 'iPad') {
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  static Future<bool> platformIsIos14_5() async {
    if (!GetPlatform.isIOS) return false;
    double? platformVersion = 0.0;
    try {
      var dev = await DeviceInfoPlugin().deviceInfo;
      var device = dev as IosDeviceInfo;
      platformVersion = double.tryParse(device.systemVersion);
      if (platformVersion != null && platformVersion > 14.5) {
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  static Future<bool> isAndroidGreaterVNine() async {
    double? platformVersion;
    if (GetPlatform.isAndroid) {
      var androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
      platformVersion = double.tryParse(androidDeviceInfo.version.release);
    }
    return GetPlatform.isAndroid &&
        platformVersion != null &&
        platformVersion >= 10;
  }

  static Future<bool> isAndroidGreaterOrEqualVersion(int version) async {
    double? platformVersion;
    if (!GetPlatform.isAndroid){
      return true;
    }
    if (GetPlatform.isAndroid) {
      var androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
      platformVersion = double.tryParse(androidDeviceInfo.version.release);
    }
    return GetPlatform.isAndroid &&
        platformVersion != null &&
        platformVersion >= version;
  }

  static Future<AppVersion> getAppVersionsData() async{
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  var appName = packageInfo.appName;
  var packageName = packageInfo.packageName;
  var version = packageInfo.version;
  var buildNumber = packageInfo.buildNumber;
  return AppVersion(appName, packageName, version, buildNumber);
  }

  static Future<String> getOSInfo() async {
    var pf = Platform.operatingSystem;
    return pf;
  }
}
