import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app_settings/app_constants.dart';
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
     // return false;
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

@riverpod
class AutoStopTracking extends _$AutoStopTracking {
  @override
  bool build() {
    Hive.box(hiveBoxSettingDbName)
        .watch(key: HiveSettingsDB.autoStopTrackingEnabledKey)
        .listen((event) => state = event.value);
    return HiveSettingsDB.autoStopTrackingEnabled;
  }

  void setValue(bool val) {
    HiveSettingsDB.setAutoStopTrackingEnabled(val);
  }
}

@riverpod
class AutoStartTracking extends _$AutoStartTracking {
  @override
  bool build() {
    Hive.box(hiveBoxSettingDbName)
        .watch(key: HiveSettingsDB.autoStartTrackingEnabledKey)
        .listen((event) => state = event.value);
    return HiveSettingsDB.autoStartTrackingEnabled;
  }

  void setValue(bool val) {
    HiveSettingsDB.setAutoStartTrackingEnabled(val);
  }
}
