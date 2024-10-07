import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../generated/l10n.dart';
import '../helpers/deviceid_helper.dart';
import '../helpers/location_bearing_distance.dart';
import '../helpers/logger.dart';
import '../helpers/preferences_helper.dart';
import '../main.dart';
import '../models/friend.dart';
import '../models/messages/friends.dart';
import '../models/messages/relationship_input.dart';
import '../models/messages/relationship_output.dart';
import '../wamp/wamp_exception.dart';

final friendsProvider =
    Provider((ref) => ref.watch(friendsLogicProvider).friends.values.toList());

final friendByIdProvider = Provider.family((ref, int id) =>
    ref.watch(friendsLogicProvider.select((l) => l.friends[id])));

final friendsLogicProvider =
    ChangeNotifierProvider((ref) => FriendsLogic.instance);

class FriendsLogic with ChangeNotifier {
  static final FriendsLogic instance = FriendsLogic._();

  FriendsLogic._() {
    _loadFriends();
  }

  final Map<int, Friend> friends = {};

  Future<void> _loadFriends() async {
    var friends = await PreferencesHelper.getFriendsFromPrefs();
    this.friends.clear();
    for (var friend in friends) {
      this.friends[friend.friendId] = friend;
    }
    notifyListeners();
    refreshFriends();
  }

  Future<void> reloadFriends() async {
    await _loadFriends();
  }

  Future<void> refreshFriends() async {
    try {
      var deviceId = DeviceId.appId;

      var result = await FriendsMessage.getFriends(deviceId);
      if (result.exception != null) {
        BnLog.warning(text: 'refreshFriends read failed ${result.exception}');
        return;
      }

      var serverFriends = result.friends;
      //no server friends //when no data will is error thrown
      if (serverFriends.isEmpty) {
        //empty list set all inactive
        for (var friend in friends.values) {
          friend.isActive = false;
          friend.hasServerEntry = false;
          // dont update when not seen friend.timestamp = DateTime.now().millisecondsSinceEpoch;
        }
        if (!kIsWeb) {
          BnLog.info(
              className: 'friendsProvider',
              methodName: 'refreshFriends',
              text: 'Friendlist is empty');
        }
        notifyListeners();
        return;
      }

      //find serverfriend in local friends, remove from list and update
      for (var friend in friends.values) {
        var serverFriend = serverFriends.remove(friend.friendId.toString());
        if (serverFriend != null) {
          friend.isActive = true;
          friend.isOnline = serverFriend.online;
          friend.requestId = serverFriend.requestId;
          friend.realSpeed = serverFriend.realSpeed ?? 0.0;
          friend.hasServerEntry = true;
          //not used
          // friend.relativeTime = serverFriend.eta;
          //friend.absolutePosition = serverFriend.position;
        } else {
          friend.isActive = false;
          friend.hasServerEntry = false;
          friend.resetPositionData();
        }
        if (friend.isOnline) {
          friend.timestamp = DateTime.now().millisecondsSinceEpoch;
        }
      }

      //left friends on server will created local
      /*for (var friend in serverFriends.values) {
        friends[friend.friendId] = Friend(
          name: '${Localize.current.friend} ${friend.friendId}',
          friendId: friend.friendId,
          isActive: true,
          requestId: friend.requestId,
        )
          ..isOnline = friend.online
          ..relativeTime = friend.eta
          ..absolutePosition = friend.position
          ..realSpeed = friend.realSpeed ?? 0.0
          ..hasServerEntry = true;
      }*/
    } on WampException catch (e) {
      BnLog.error(
          className: 'friendsProvider',
          methodName: 'refreshFriends_WampError',
          text: e.toString());
    } on Exception catch (e) {
      BnLog.error(
          className: 'friendsProvider',
          methodName: 'refreshFriends_exception',
          text: e.toString());
    } finally {
      notifyListeners();
    }
  }

  List<Friend> updateFriendInProcession(FriendsMessage realtimeUpdateFriends,
      int upPos, int upTime, double? userLat, double? userLon) {
    for (var f in friends.values) {
      //iterate all friends
      var rtfEntry = realtimeUpdateFriends.friends.entries
          .where((fr) => fr.key == f.friendId.toString());

      //friend not in update
      if (rtfEntry.isEmpty) {
        f.isOnline = false;
        //remove from map
        continue;
      }
      var rtf = rtfEntry.first.value; //find friend with id
      //set realtimedatas
      f.isOnline = true;
      f.relativeDistance = rtf.position;
      f.relativeTime = rtf.eta;
      f.absolutePosition = rtf.position;
      f.speed = rtf.speed;
      f.realSpeed = rtf.realSpeed ?? 0.0;
      int rtfEstimatedTimeOfArrivalOnRoute = rtf.eta ?? 0;
      f.timeToUser = upTime -
          rtfEstimatedTimeOfArrivalOnRoute; //friend eta = 20000ms to finish - up eta(uptime)=> 10000 ms => 10000-20000 -> -10000ms /friend behind = -10000ms
      f.longitude = rtf.longitude;
      f.latitude = rtf.latitude;
      if (userLat != null &&
          userLon != null &&
          f.latitude != null &&
          f.longitude != null &&
          userLat > 0 &&
          userLon > 0 &&
          f.latitude! > 0 &&
          f.longitude! > 0) {
        var dist = GeoLocationHelper.haversine(
            userLat, userLon, f.latitude!, f.longitude!);
        f.distanceToUser = dist.toInt();
      } else {
        f.distanceToUser = rtf.position -
            upPos; //friend pos = driven m - up driven m 1000-2000 -> -1000 /friend behind = -1000
      }
      f.timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    }
    notifyListeners();
    PreferencesHelper.saveFriendsToPrefs(friends.values.toList());
    return friends.values.toList();
  }

  Future<Friend?> addNewFriend(String name, Color color) async {
    var id = await PreferencesHelper.getNewFriendId();
    var friend = Friend(name: name, friendId: id, color: color);

    var deviceId = DeviceId.appId;

    var getFriendRelationshipResult =
        await RelationshipOutputMessage.createRelationShip(
            RelationshipInputMessage(
                deviceId: deviceId, friendId: id, requestId: 0));
    if (getFriendRelationshipResult == null ||
        getFriendRelationshipResult.rpcException != null) {
      QuickAlert.show(
          context: navigatorKey.currentContext!,
          type: QuickAlertType.error,
          title: Localize.current.addnewfriend,
          text: Localize.current.failed);
      return null;
    }
    friend.requestId = getFriendRelationshipResult.requestId;
    friend.codeTimestamp = DateTime.now().millisecondsSinceEpoch;
    friends[friend.friendId] = friend;
    PreferencesHelper.saveFriendsToPrefs(friends.values.toList());
    notifyListeners();
    return friend;
  }

  Future<dynamic> addFriendWithCode(
      String name, Color color, String code) async {
    var id = await PreferencesHelper.getNewFriendId();
    var friend = Friend(
        name: name, friendId: id, color: color, requestId: int.parse(code));

    var getFriendRelationshipResult =
        await RelationshipOutputMessage.getRelationShip(
      RelationshipInputMessage(
          deviceId: DeviceId.appId, friendId: id, requestId: friend.requestId),
    );
    if (getFriendRelationshipResult == null ||
        getFriendRelationshipResult.rpcException != null) {
      var ex = getFriendRelationshipResult?.rpcException;
      if (ex is WampException && ex.message != null) {
        if (ex.message!.startsWith('Not a valid pending relationship id')) {
          return Localize.current.noValidPendingRelationShip;
        }
        if (ex.message!.startsWith('Relationship with self is not allowed')) {
          return Localize.current.noSelfRelationAllowed;
        }
        if (ex.message!.startsWith('Devices are already connected')) {
          return Localize.current.devicesAlreadyConnected;
        }
      }
      return Localize.current.unknownerror;
    }
    friend.friendId = getFriendRelationshipResult.friendId;
    friend.isActive = true;
    friend.requestId = 0;

    friends[friend.friendId] = friend;
    PreferencesHelper.saveFriendsToPrefs(friends.values.toList());
    notifyListeners();
    return friend;
  }

  Future<void> deleteRelationShip(int id) async {
    friends.remove(id);
    notifyListeners();
    var deviceId = DeviceId.appId;
    PreferencesHelper.saveFriendsToPrefs(friends.values.toList());
    var getFriendRelationshipResult =
        await RelationshipOutputMessage.getRelationShip(
      RelationshipInputMessage(deviceId: deviceId, friendId: id, requestId: 0),
    );
    if (getFriendRelationshipResult == null ||
        getFriendRelationshipResult.rpcException != null) {
      BnLog.error(
          text: 'Error deleting friend on Server',
          exception: getFriendRelationshipResult?.rpcException);
      return;
    }
  }

  Future<bool> updateFriendName(int friendId, String name) async {
    var currFriend = friends[friendId];
    if (currFriend != null) {
      currFriend.name = name;
      PreferencesHelper.saveFriendsToPrefs(friends.values.toList());
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateFriend(Friend friend) async {
    var currFriend = friends[friend.friendId];
    if (currFriend != null) {
      friends[friend.friendId] = friend;
      PreferencesHelper.saveFriendsToPrefs(friends.values.toList());
      notifyListeners();
      return true;
    }
    return false;
  }
}

final filteredFriends = Provider<List<Friend>>((ref) {
  final friends = ref.watch(friendsProvider);
  final searchStringProvider = ref.watch(friendNameProvider);

  if (searchStringProvider.isEmpty) {
    return friends;
  }

  var filteredFriendsList = friends.where(
      (f) => f.name.toLowerCase().contains(searchStringProvider.toLowerCase()));

  return filteredFriendsList.toList();
});

final friendNameProvider = StateProvider<String>((value) => '');
