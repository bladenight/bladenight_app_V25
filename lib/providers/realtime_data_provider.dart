import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/logger.dart';
import '../models/realtime_update.dart';
import 'location_provider.dart';

final realtimeDataProvider = StateProvider<RealtimeUpdate?>((ref) {
 var lp =ref.watch(locationProvider.select((lp) => lp.realtimeUpdate));
 BnLog.debug(text: 'update realtimeData');
 return lp;
});