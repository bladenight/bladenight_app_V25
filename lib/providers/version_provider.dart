import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../helpers/device_info_helper.dart';
import '../helpers/deviceid_helper.dart';

final versionProvider = FutureProvider((ref) async {
  return  await DeviceHelper.getAppVersionsData();
});
