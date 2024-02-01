import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/realtime_update.dart';
import 'location_provider.dart';

part 'realtime_data_provider.g.dart';

@Riverpod(keepAlive: true)
class RealtimeData extends _$RealtimeData {
  @override
  RealtimeUpdate? build() {
    return ref.watch(locationProvider.select((lp) => lp.realtimeUpdate));
  }
}
