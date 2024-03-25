import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../helpers/hive_box/hive_settings_db.dart';
import 'location_provider.dart';

part 'is_tracking_provider.g.dart';

@Riverpod(
    keepAlive: true) //important not auto disposing when tracking is restarted
class IsTracking extends _$IsTracking {
  @override
  bool build() {
    var isTracking = ref.watch(locationProvider.select((tp) => tp.isTracking));
    state = isTracking;
    return LocationProvider.instance.isTracking;
  }

  ///toggles tracking when user is in procession
  ///set [userIsParticipant] to true if participant
  ///set [userIsParticipant] to false if only in viewer-mode
  Future<bool> toggleTracking(bool userIsParticipant) async {
    if (kIsWeb) {
      return false;
    }
    HiveSettingsDB.setUserIsParticipant(userIsParticipant);
    if (LocationProvider.instance.isTracking) {
      await LocationProvider.instance.stopTracking();
    } else {
      await LocationProvider.instance.startTracking(userIsParticipant);
    }
    return state;
  }

  ///toggles tracking when user is in procession
  ///set [userIsParticipant] to true if participant
  ///set [userIsParticipant] to false if only in viewer-mode
  Future<bool> startTracking(bool userIsParticipant) async {
    if (kIsWeb) {
      return false;
    }
    HiveSettingsDB.setUserIsParticipant(userIsParticipant);
    state = await LocationProvider.instance.startTracking(userIsParticipant);
    return state;
  }
}
