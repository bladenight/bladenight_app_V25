import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app_settings/app_constants.dart';
import '../helpers/enums/tracking_type.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../wamp/wamp_v2.dart';
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
  ///
  ///- set [trackingType] to [TrackingType.userParticipating]
  ///  if participant
  ///- set [trackingType] to [TrackingType.userNotParticipating]
  ///  if only in viewer-mode
  Future<bool> toggleTracking(TrackingType trackingType) async {
    if (LocationProvider().isTracking) {
      stopTracking();
    } else {
      _startTracking(trackingType);
    }
    return state;
  }

  ///starts location tracking when user is in procession
  ///
  ///- set [trackingType] to [TrackingType.userParticipating]
  ///  if participant
  ///- set [trackingType] to [TrackingType.userNotParticipating]
  ///  if only in viewer-mode
  Future<bool> _startTracking(TrackingType trackingType) async {
    if (trackingType == TrackingType.onlyTracking) {
      WampV2().stopWamp();
      MapSettings.setShowOwnTrack(true);
      MapSettings.setWasOpenStreetMapEnabledFlag(
          MapSettings.openStreetMapEnabled);
      MapSettings.setOpenStreetMapEnabled(true);
    } else {
      WampV2().startWamp();
    }
    HiveSettingsDB.setUserIsParticipant(
        trackingType == TrackingType.userParticipating);
    return LocationProvider().startTracking(trackingType);
  }

  Future<bool> stopTracking() async {
    return _stopTracking();
  }

  ///stops location tracking
  Future<bool> _stopTracking() async {
    if (LocationProvider().trackingType == TrackingType.onlyTracking) {
      MapSettings.setOpenStreetMapEnabled(
          MapSettings.wasOpenStreetMapEnabledFlag);
      WampV2().startWamp();
    }
    return LocationProvider().stopTracking();
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
