part of 'hive_settings_db.dart';

extension FriendsDb on HiveSettingsDB {
  static Box? _friendsDbBox;
  static const String friendDbName = 'friendsDb';
  static const String _friendsUpdateTimeStampKey = 'friendsUpdateTimeStampKey';

  void init() async {
    _friendsDbBox = await Hive.openBox(friendDbName);
  }

  ///get stored friends
  static Future<List<Friend>> getFriendsListAsync() async {
    try {
      _friendsDbBox ??= await Hive.openBox(friendDbName);
      List<Friend> friendList = [];
      for (var key in _friendsDbBox!.keys) {
        var friendJson = _friendsDbBox!.get(key);
        if (friendJson == null || friendJson is! String) continue;
        friendList.add(MapperContainer.globals.fromJson<Friend>(friendJson));
      }
      return friendList;
    } catch (e) {
      return [];
    }
  }

  static Future<int> get friendsCount async {
    try {
      _friendsDbBox ??= await Hive.openBox(friendDbName);
      return _friendsDbBox!.keys.length;
    } catch (e) {
      return 0;
    }
  }

  static Future<void> saveFriendsAsync(List<Friend> friends) async {
    try {
      _friendsDbBox ??= await Hive.openBox(friendDbName);
      for (var friend in friends) {
        _friendsDbBox!.put(friend.friendId, friend.toJson());
      }
    } catch (e) {
      BnLog.error(text: 'Error saveFriends ${e.toString()}', exception: e);
    }
  }

  static Future<void> addFriend(Friend friend) async {
    _friendsDbBox ??= await Hive.openBox(friendDbName);
    try {
      await _friendsDbBox!.put(friend.friendId, friend.toJson());
    } catch (e) {
      BnLog.error(text: 'Error addFriend ${e.toString()}', exception: e);
    }
  }

  static Future<void> setShowFriend(Friend friend, bool showFriend) async {
    _friendsDbBox ??= await Hive.openBox(friendDbName);
    try {
      var friendCopy = friend.copyWith(isActive: showFriend);
      return _friendsDbBox!.put(friend.friendId, friendCopy.toJson());
    } catch (e) {
      BnLog.error(text: 'Error addFriend ${e.toString()}', exception: e);
    }
  }

  static Future<bool> updateFriends(Friends friends) async {
    _friendsDbBox ??= await Hive.openBox(friendDbName);
    try {
      int lastUpdateTimestamp = await getLastFriendsUpdateTimestamp;
      int lastFromDBTimestamp = await getLastFriendsUpdateTimestamp;
      for (var friend in friends.friends) {
        updateFriend(friend);
      }
      //update timestamp
      var actualTs = DateTime.now().millisecondsSinceEpoch;
      var lts = max(lastUpdateTimestamp, lastFromDBTimestamp);
      if (lts > actualTs) {
        setLastFriendsUpdateTimestamp(actualTs);
      } else if (lts != 0) {
        setLastFriendsUpdateTimestamp(lts);
      }
      return true;
    } catch (e) {
      BnLog.error(text: 'Error addFriend ${e.toString()}', exception: e);
    }
    return false;
  }

  static Future<void> updateFriend(Friend friend) async {
    await _friendsDbBox!.put(friend.friendId, friend.toJson());
  }

  static Future<int> get getLastFriendsUpdateTimestamp async {
    try {
      _friendsDbBox ??= await Hive.openBox(friendDbName);
      return await _friendsDbBox!
          .get(_friendsUpdateTimeStampKey, defaultValue: 0);
    } catch (e) {
      BnLog.error(
          text: 'Error getLastFriendsUpdateTimestamp ${e.toString()}',
          exception: e);
    }
    return 0;
  }

  static Future<void> setLastFriendsUpdateTimestamp(
      int lastUpdateTimestamp) async {
    try {
      _friendsDbBox ??= await Hive.openBox(friendDbName);
      return await _friendsDbBox!
          .put(_friendsUpdateTimeStampKey, lastUpdateTimestamp);
    } catch (e) {
      BnLog.error(
          text: 'Error setLastFriendsUpdateTimestamp ${e.toString()}',
          exception: e);
    }
  }

  ///helper to clear friend store
  static Future<int> clearFriendsStore() async {
    _friendsDbBox ??= await Hive.openBox(friendDbName);
    return _friendsDbBox!.clear();
  }

  static Future<void> deleteFriend(Friend friend) async {
    _friendsDbBox ??= await Hive.openBox(friendDbName);
    //important to delete timestamp and reload friends new
    return _friendsDbBox!.delete(friend.friendId);
  }

  static void saveFriends(List<Friend> friendList) async {
    await saveFriendsAsync(friendList);
  }

  ///id for new friend increments automatic after get for deviceid
  static const String _friendId = 'friendIdKey';

  ///FriendId is App unique and connected by deviceId on server
  ///   get an new incremented [Friend.friendId]
  static Future<int> getNewFriendId() async {
    int finalFriendId = -1;
    int? id = await _getLastFriendId();
    if (id == null || id == 0) {
      //not set
      finalFriendId = 1;
    } else {
      finalFriendId = id + 1;
    }
    await saveFriendId(finalFriendId);
    return finalFriendId;
  }

  static Future<int> saveFriendId(int id) async {
    _friendsDbBox ??= await Hive.openBox(friendDbName);
    try {
      await _friendsDbBox!.put(_friendId, id);
      return id;
    } catch (e) {
      BnLog.error(text: 'Error addFriend ${e.toString()}', exception: e);
    }
    return -1;
  }

  static Future<int?> _getLastFriendId() async {
    _friendsDbBox ??= await Hive.openBox(friendDbName);
    try {
      return await _friendsDbBox!.get(_friendId);
    } catch (e) {
      BnLog.error(text: 'Error addFriend ${e.toString()}', exception: e);
    }
    return null;
  }
}
