import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../helpers/hive_box/hive_settings_db.dart';
import 'location_provider.dart';

part 'is_tracking_provider.g.dart';

@riverpod
class IsTracking extends _$IsTracking {
  @override
  bool build() {
    return LocationProvider.instance.isTracking;
    //return false;
  }

  setValue(bool value) {
    state = value;
  }

  ///toggles tracking when user is in procession
  ///set [userIsParticipant] to true if participant
  ///set [userIsParticipant] to false if only in viewer-mode
  Future<bool> toggleTracking(bool userIsParticipant) async {
    if (kIsWeb) {
      return false;
    }
    HiveSettingsDB.setUserIsParticipant(userIsParticipant);
    if (state) {
      state = await ref.read(locationProvider.notifier).stopTracking();
    } else {
      state = await ref
          .read(locationProvider.notifier)
          .startTracking(userIsParticipant);
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
    state = await ref
        .read(locationProvider.notifier)
        .startTracking(userIsParticipant);
    return state;
  }
}
