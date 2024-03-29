import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/device_info_helper.dart';

final versionProvider = FutureProvider((ref) async {
  return  await DeviceHelper.getAppVersionsData();
});
