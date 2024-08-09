part of 'hive_settings_db.dart';

extension LocationStore on HiveSettingsDB {
  static const String _userTrackPointsKey = 'utpJsonPref';

  ///get stored track points
  static List<UserGpxPoint> get userTrackPointsList {
    try {
      var dateString = DateTime.now().toDateOnlyString();
      var tp =
          HiveSettingsDB._locationHiveBox.get(_userTrackPointsKey + dateString);
      if (MapSettings.showOwnTrack == false || tp == null) {
        return [];
      }
      var utpPts = MapperContainer.globals.fromJson<UserGPXPoints>(tp);
      return utpPts.userGPXPointList.toList();
    } catch (e) {
      return [];
    }
  }

  ///get stored track points
  static List<UserGpxPoint> getUserGpxPointsListByDate(DateTime dateTime) {
    try {
      var tp = HiveSettingsDB._locationHiveBox
          .get(_userTrackPointsKey + dateTime.toDateOnlyString());
      if (tp == null) {
        return [];
      }
      var utpPts = MapperContainer.globals.fromJson<UserGPXPoints>(tp);
      return utpPts.userGPXPointList.toList();
    } catch (e) {
      return [];
    }
  }

  static UserGPXPoints getUserTrackPointsListByDate(DateTime dateTime) {
    try {
      var tp = HiveSettingsDB._locationHiveBox
          .get(_userTrackPointsKey + dateTime.toDateOnlyString());
      if (tp == null) {
        return UserGPXPoints([]);
      }
      var utpPts = MapperContainer.globals.fromJson<UserGPXPoints>(tp);
      return utpPts;
    } catch (e) {
      BnLog.error(text: e.toString(),methodName:'getUserTrackPointsListByDate' );
      return UserGPXPoints([]);
    }
  }

  ///set store track points
  static Future<bool> saveUserTrackPointList  (
      List<UserGpxPoint> val, DateTime dateTime) async {
    try {
      if (MapSettings.showOwnTrack == false) {
        return Future.value(false);
      }
      var utp = UserGPXPoints(val);
      await HiveSettingsDB._locationHiveBox
          .put(_userTrackPointsKey + dateTime.toDateOnlyString(), utp.toJson());
      setUserTrackPointsLastUpdate(DateTime.now());
      BnLog.info(
          text:
          'Saved user track points list with an amount of ${val.length}');
    } catch (e) {
      BnLog.error(
          text: 'Error saveUserTrackPointList ${e.toString()}',
          methodName: 'saveUserTrackPointList');
      return Future.value(false);
    }
    return Future.value(true);
  }

  static void clearTrackPointStoreForDate(DateTime dateTime) {
    HiveSettingsDB._locationHiveBox
        .delete(_userTrackPointsKey + dateTime.toDateOnlyString());
    setUserTrackPointsLastUpdate(DateTime.now());
  }

  ///helper to clear tp store
  static void clearTrackPointStore() {
    HiveSettingsDB._locationHiveBox.clear();
    setUserTrackPointsLastUpdate(DateTime.now());
  }

  static const String _userTrackPointsLastUpdate =
      'userTrackPointsLastUpdatePref';

  ///get UserTrackPointsstring DateTimeStamp
  static DateTime get userTrackPointsLastUpdate {
    return HiveSettingsDB._locationHiveBox.get(_userTrackPointsLastUpdate,
        defaultValue: DateTime(2000, 1, 1, 0, 0, 0));
  }

  ///set UserTrackPointsstring DateTimeStamp
  static void setUserTrackPointsLastUpdate(DateTime val) {
    HiveSettingsDB._locationHiveBox.put(_userTrackPointsLastUpdate, val);
  }

  ///helper to identify if data are stored today
  static bool get dataTodayAvailable {
    var dateString = DateTime.now().toDateOnlyString();
    if (HiveSettingsDB._locationHiveBox
        .containsKey(_userTrackPointsKey + dateString)) {
      return true;
    }
    return false;
  }

  ///Returns a datelist (not empty) hich dates has availible trackingdata
  static List<String> getTrackDates() {
    var dateList = <String>[];
    try {
      var keys = HiveSettingsDB._locationHiveBox.keys;
      for (var key in keys) {
        if (key.compareTo(_userTrackPointsLastUpdate) == 0) {
          continue;
        }
        dateList.add(key.replaceAll(_userTrackPointsKey, ''));
      }
      if (dateList.isEmpty) {
        dateList.add(DateTime.now().toDateOnlyString());
      }
      return dateList;
    } catch (e) {
      if (dateList.isEmpty) {
        dateList.add(DateTime.now().toDateOnlyString());
      }
      return dateList;
    }
  }
}
