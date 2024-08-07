part of 'hive_settings_db.dart';

extension LocationStore on HiveSettingsDB {
  static const String _userTrackPointsKey = 'utpJsonPref';

  ///get stored track points
  static List<UserGpxPoint> get userTrackPointsList {
    try {
      var dateString = DateTime.now().toDateOnlyString();
      var tp = HiveSettingsDB._locationHiveBox.get(_userTrackPointsKey + dateString);
      if (MapSettings.showOwnTrack == false || tp == null) {
        return [];
      }
      var utpPts = MapperContainer.globals.fromJson<UserTrackPoints>(tp);
      return utpPts.utps.toList();
    } catch (e) {
      return [];
    }
  }

  ///get stored track points
  static List<UserGpxPoint> getUserTrackPointsListByDate(DateTime dateTime) {
    try {
      var tp = HiveSettingsDB._locationHiveBox
          .get(_userTrackPointsKey + dateTime.toDateOnlyString());
      if (MapSettings.showOwnTrack == false || tp == null) {
        return [];
      }
      var keylist =  HiveSettingsDB._locationHiveBox.keys;
      var utpPts = MapperContainer.globals.fromJson<UserTrackPoints>(tp);
      return utpPts.utps.toList();
    } catch (e) {
      return [];
    }
  }

  ///set store track points
  static void saveUserTrackPointList(
      List<UserGpxPoint> val, DateTime dateTime) {
    try {
      if (MapSettings.showOwnTrack == false) {
        return;
      }
      BnLog.debug(
          text:
              'Saving user track points list with an amount of ${val.length}');
      var utp = UserTrackPoints(val);
      HiveSettingsDB._locationHiveBox
          .put(_userTrackPointsKey + dateTime.toDateOnlyString(), utp.toJson());
      setUserTrackPointsLastUpdate(DateTime.now());
    } catch (e) {
      BnLog.error(
          text: 'Error saveUserTrackPointList ${e.toString()}',
          methodName: 'saveUserTrackPointList');
    }
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

  ///helper to identify if data are stored yesterday
  static bool get storedDataAreFromToday {
    var dateString = DateTime.now().toDateOnlyString();
    if (HiveSettingsDB._locationHiveBox.containsKey(_userTrackPointsKey + dateString)) {
      return true;
    }
    return false;
  }

  static List<String> getTrackDates() {
    var dateList = <String>[];
    try {

      var keys = HiveSettingsDB._locationHiveBox.keys;
      for (var key in keys) {
        dateList.add(key.replace(_userTrackPointsKey));
      }
      if (dateList.isEmpty){
        dateList.add(DateTime.now().toDateOnlyString());
      }
      return dateList;
    } catch (e) {
      if (dateList.isEmpty){
        dateList.add(DateTime.now().toDateOnlyString());
      }
      dateList.add(DateTime.now().subtract(Duration(days: 1)).toDateOnlyString());
      dateList.add(DateTime.now().subtract(Duration(days: 2)).toDateOnlyString());
      return dateList;
    }
  }
}
