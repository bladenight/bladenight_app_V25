import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/hive_box/hive_settings_db.dart';
import '../models/event.dart';
import 'network_connection_provider.dart';

///Get all [Events] from server
final allEventsProvider = FutureProvider((ref) {
  var res = ref.read(networkAwareProvider).connectivityStatus;
  if (res != ConnectivityStatus.online) {
    if (HiveSettingsDB.eventsJson.isNotEmpty) {
      var events = HiveSettingsDB.eventsJson;
      return Future(() => EventsMapper.fromJson(events));
    } else {
      return Future(() => Events.rpcError(Exception('offline')));
    }
  }

  return Events.getAllEventsWamp();
});
