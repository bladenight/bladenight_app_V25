import 'package:dart_mappable/dart_mappable.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/event.dart';
import '../models/friend.dart';
import '../models/image_and_link.dart';
import '../models/images_and_links.dart';

class PreferencesHelper {
  static const String _friendPref = 'friendlist';
  static const String _nextEventPref = 'nextevent';
  static const String _trackAutoStopPref = 'trackAutoStopPref';
  static const String _imagesAndLinksPref = 'imagesAndLinksPref';

  ///id for new friend increments automatic after get for deviceid
  static const String _friendId = 'friendid';

  ///Get friendlist from pref
  ///Return List or empty List on fail
  static Future<List<Friend>> getFriendsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonData = prefs.getString(_friendPref);
    if (jsonData != null) {
      return MapperContainer.globals.fromJson<List<Friend>>(jsonData);
    } else {
      return List<Friend>.empty();
    }
  }

  static void saveFriendsToPrefs(List<Friend> friendList) async {
    await saveFriendsToPrefsAsync(friendList);
  }

  static Future<bool> saveFriendsToPrefsAsync(List<Friend> friendlist) async {
    final prefs = await SharedPreferences.getInstance();
    String friendJson = MapperContainer.globals.toJson(friendlist);
    prefs.setString(_friendPref, friendJson);
    return true;
  }

  ///FriendId is App unique and connected by deviceId on server
  ///   get an new incremented [Friend.friendId]
  static Future<int> getNewFriendId() async {
    int finalFriendId = -1;
    final prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt(_friendId);
    if (id == null || id == 0) {
      //not set
      finalFriendId = 1;
    } else {
      finalFriendId = id + 1;
    }
    await prefs.setInt(_friendId, finalFriendId);
    return finalFriendId;
  }


  static Future<bool> getAutoStopFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? autoStop = prefs.getBool(_trackAutoStopPref);
    return autoStop ?? true;
  }

  static void saveAutoStopToPrefs(bool autoStop) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_trackAutoStopPref, autoStop);
  }

  static Future<ImageAndLinkList> getImagesAndLinksPref() async {
    if (!kIsWeb) FLog.trace(text: 'Prefs get images and links');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var val = prefs.getString(_imagesAndLinksPref);
      if (val == null) {
        return ImageAndLinkList(<ImageAndLink>[]);
      }
      var links = MapperContainer.globals.fromJson<ImageAndLinkList>(val);
      if (links.imagesAndLinks == null) {
        return ImageAndLinkList(<ImageAndLink>[]);
      }
      return Future.value(links);
    } catch (e) {
      if (!kIsWeb)
        FLog.error(text: 'Error Prefs get images and links', exception: e);
    }
    return ImageAndLinkList(<ImageAndLink>[]);
  }

  static void setImagesAndLinksPref(ImageAndLinkList ial) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var prefString = MapperContainer.globals.toJson(ial);
      prefs.setString(_imagesAndLinksPref, prefString);
    } catch (e) {
      if (!kIsWeb)
        FLog.error(text: 'Error Prefs set images and links', exception: e);
    }
  }
}
