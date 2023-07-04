import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../helpers/deviceid_helper.dart';

class AppVersion {
  AppVersion(this.appName, this.packageName, this.version, this.buildNumber);

  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;
}

final versionProvider = FutureProvider((ref) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  var appName = packageInfo.appName;
  var packageName = packageInfo.packageName;
  var version = packageInfo.version;
  var buildNumber = packageInfo.buildNumber;
  return AppVersion(appName, packageName, version, buildNumber);
});

final appIdProvider = FutureProvider((ref) async {
  return DeviceId.getId;
});

final oneSignalIdProvider = FutureProvider((ref) async {
  final status = await OneSignal.shared.getDeviceState();
  final String osUserID = status?.userId ?? "-";
  return osUserID;
});
