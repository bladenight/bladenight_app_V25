import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app_settings/app_constants.dart';
import '../helpers/enums/tracking_type.dart';
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
    return isTracking;
  }

  ///toggles tracking when user is in procession
  ///set [userIsParticipant] to true if participant
  ///set [userIsParticipant] to false if only in viewer-mode
  Future<bool> toggleTracking(TrackingType trackingType) async {
    if (LocationProvider.instance.isTracking) {
      stopTracking();
    } else {
      startTracking(trackingType);
    }
    return state;
  }

  ///toggles tracking when user is in procession
  ///set [userIsParticipant] to true if participant
  ///set [userIsParticipant] to false if only in viewer-mode
  Future<bool> startTracking(TrackingType trackingType) async {
    if (trackingType == TrackingType.onlyTracking) {
      MapSettings.setShowOwnTrack(true);
      MapSettings.setWasOpenStreetMapEnabledFlag(
          MapSettings.openStreetMapEnabled);
      MapSettings.setOpenStreetMapEnabled(true);
    }
    HiveSettingsDB.setUserIsParticipant(
        trackingType == TrackingType.userParticipating);
    return await LocationProvider.instance.startTracking(trackingType);
  }

  Future<bool> stopTracking() async {
    if (LocationProvider.instance.trackingType == TrackingType.onlyTracking) {
      MapSettings.setOpenStreetMapEnabled(
          MapSettings.wasOpenStreetMapEnabledFlag);
    }
    return await LocationProvider.instance.stopTracking();
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
