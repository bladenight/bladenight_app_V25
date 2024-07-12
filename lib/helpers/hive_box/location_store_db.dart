part of 'hive_settings_db.dart';

extension LocationStore on HiveSettingsDB {
  static const String _userTrackPointsKey = 'userTrackPointsJsonPref';

  ///get stored track points
  static List<UserGpxPoint> get userTrackPointsList {
    try {
      var tp = HiveSettingsDB._hiveBox.get(_userTrackPointsKey);
      if (MapSettings.showOwnTrack == false || tp == null) {
        return [];
      }
      var utpPts = MapperContainer.globals.fromJson<UserTrackPoints>(tp);
      return utpPts.utps.toList();
    } catch (e) {
      return [];
    }
  }

  ///set store track points
  static void saveUserTrackPointList(List<UserGpxPoint> val) {
    try {
      if (MapSettings.showOwnTrack == false) {
        return;
      }
      BnLog.debug(
          text:
              'Saving user track points list with an amount of ${val.length}');
      var utp = UserTrackPoints(val);
      HiveSettingsDB._hiveBox.put(_userTrackPointsKey, utp.toJson());
      setUserTrackPointsLastUpdate(DateTime.now());
    } catch (e) {
      BnLog.error(
          text: 'Error saveUserTrackPointList ${e.toString()}',
          methodName: 'saveUserTrackPointList');
    }
  }

  ///helper to clear tp store
  static void clearTrackPointStore() {
    HiveSettingsDB._hiveBox.delete(_userTrackPointsKey);
    setUserTrackPointsLastUpdate(DateTime.now());
  }

  static const String _userTrackPointsLastUpdate =
      'userTrackPointsLastUpdatePref';

  ///get UserTrackPointsstring DateTimeStamp
  static DateTime get userTrackPointsLastUpdate {
    return HiveSettingsDB._hiveBox.get(_userTrackPointsLastUpdate,
        defaultValue: DateTime(2000, 1, 1, 0, 0, 0));
  }

  ///set UserTrackPointsstring DateTimeStamp
  static void setUserTrackPointsLastUpdate(DateTime val) {
    HiveSettingsDB._hiveBox.put(_userTrackPointsLastUpdate, val);
  }

  ///helper to identify if data are stored yesterday
  static bool get storedDataAreFromToday {
    var lastDiff =
        DateTime.now().difference(userTrackPointsLastUpdate).inSeconds;
    if (lastDiff > 60 * 60 * 24) {
      return false;
    }
    return true;
  }
}
