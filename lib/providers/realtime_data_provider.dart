import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/realtime_update.dart';
import 'location_provider.dart';
import 'wamp_provider.dart';

part 'realtime_data_provider.g.dart';

@Riverpod(keepAlive: true)
class RealtimeData extends _$RealtimeData {
  @override
  RealtimeUpdate? build() {
    var rtSubscription = ref.watch(wampEventStreamProvider);
    if (rtSubscription.hasValue && rtSubscription.value is RealtimeUpdate) {
      //ref.refresh(refreshTimerProvider.notifier).start();//crash not allowed during build
      return rtSubscription.value as RealtimeUpdate;
    }
    return ref.watch(locationProvider.select((lp) => lp.realtimeUpdate));
  }

  update(RealtimeUpdate rtu) {
    state = rtu;
  }
}
