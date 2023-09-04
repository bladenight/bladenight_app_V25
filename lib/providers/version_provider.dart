import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../helpers/device_info_helper.dart';
import '../helpers/deviceid_helper.dart';
import '../models/app_version.dart';

final versionProvider = FutureProvider((ref) async {
  return  await DeviceHelper.getAppVersionsData();
});

final appIdProvider = FutureProvider((ref) async {
  return DeviceId.getId;
});

final oneSignalIdProvider = FutureProvider((ref) async {
  final status =  OneSignal.User.pushSubscription;
  final String osUserID = status.id ?? '';
  return osUserID;
});
