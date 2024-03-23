import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_settings/app_constants.dart';
import '../generated/l10n.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/logger.dart';
import '../helpers/wamp/message_types.dart';
import '../providers/friends_provider.dart';
import '../providers/location_provider.dart';
import '../wamp/bn_wamp_message.dart';
import '../wamp/wamp_endpoints.dart';
import '../wamp/wamp_error.dart';
import '../wamp/wamp_v2.dart';
import 'event.dart';
import 'friend.dart';
import 'messages/friend.dart';
import 'messages/friends.dart';
import 'moving_point.dart';

part 'realtime_update.mapper.dart';

/*[50,"FPWAUWMKX33D64BN",{"hea":{"pos":0,"spd":0,"rsp":0.0,"eta":0,"ior":false,"iip":false,"lat":0.0,"lon":0.0,"acc":0},
"tai":{"pos":0,"spd":0,"rsp":0.0,"eta":0,"ior":false,"iip":false,"lat":0.0,"lon":0.0,"acc":0},"fri":{"fri":{}},
"up":{"pos":0,"spd":0,"rsp":0.0,"eta":0,"ior":false,"iip":false,"lat":0.0,"lon":0.0,"acc":0},
"rle":15926.0,"rna":"West_test","sts":"CON","isa":true,"ust":1,"usr":0,"sht":false,"startTimeStamp":0}]*/

@MappableClass()
class RealtimeUpdate with RealtimeUpdateMappable {
  @MappableField(key: 'hea')
  final MovingPoint head;
  @MappableField(key: 'tai')
  final MovingPoint tail;
  @MappableField(key: 'up')
  final MovingPoint user;
  @MappableField(key: 'rle')
  final double runningLength;
  @MappableField(key: 'rna')
  final String routeName;

  ///State of event == EventStatus new feature 06_23
  @MappableField(key: 'sts')
  final EventStatus? eventState;
  ///Event == Event is active new feature 01_24 - default true for older Server
  @MappableField(key: 'isa')
  final bool eventIsActive;
  @MappableField(key: 'ust')
  final String usersTracking;
  @MappableField(key: 'usr')
  final String users;
  @MappableField(key: 'fri')
  final FriendsMessage friends;

  //Special function like is head Tail or see whole procession
  @MappableField(key: 'spf')
  final int? specialFunction;

  Exception? rpcException;
  final timeStamp = DateTime.now();

  ///All datas from server about actual procession
  RealtimeUpdate(
      {required this.head,
      required this.tail,
      required this.user,
      required this.runningLength,
      required this.routeName,
      required this.usersTracking,
      required this.users,
      required this.friends,
      this.specialFunction,
      this.rpcException,
      this.eventState,
      this.eventIsActive = true});

  static RealtimeUpdate rpcError(Exception exception) {
    return RealtimeUpdate(
        head: MovingPoint.movingPointEmpty(),
        tail: MovingPoint.movingPointEmpty(),
        user: MovingPoint.movingPointEmpty(),
        runningLength: 0,
        routeName: 'error',
        usersTracking: '0',
        users: '0',
        friends: FriendsMessage(<String, FriendMessage>{}),
        rpcException: exception);
  }

  ///Returns time as int in ms between head and tail
  int timeTrainComplete() {
    if (head.position == tail.position) return 0;
    int tailEta = tail.eta ?? 0;
    int headEta = head.eta ?? 0;
    if (tailEta == 0) return 0;
    return tailEta - headEta;
  }

  ///Returns time as int in ms between user and tail
  int timeUserToTail() {
    // issue solved by return 0 if eta 7536667 usr and eta 7125619 tail and head --> usr not on route
    if (!user.isOnRoute || head.position == tail.position) return 0;
    int tailEta = tail.eta ?? 0;
    int userEta = user.eta ?? 0;
    if (tailEta == 0) return 0;
    return -(userEta - tailEta); //show time as positive
  }

  ///Returns time as int in ms between head and user
  int timeUserToHead() {
    if (!user.isOnRoute || head.position == tail.position) return 0;
    int headEta = head.eta ?? 0;
    int userEta = user.eta ?? 0;
    if (headEta == 0 || userEta == 0) return 0;
    return userEta - headEta;
  }

  ///Returns length as int in meter between head and tail
  int distanceOfTrainComplete() {
    int tailPos = tail.position;
    int headPos = head.position;
    return headPos - tailPos;
  }

  ///Returns length as int in meter between user and tail
  int distanceOfUserToTail() {
    if (!user.isOnRoute || head.position == tail.position) return 0;
    int tailPos = tail.position;
    int userPos = user.position;
    return userPos - tailPos; //show time as positive
  }

  ///Returns length as int in meter between  head and user
  int distanceOfUserToHead() {
    if (!user.isOnRoute || head.position == tail.position) return 0;
    int headPos = head.position;
    int userPos = user.position;
    return headPos - userPos;
  }

  Iterable<Friend> mapPointFriends(FriendsMessage? rtFriends) {
    var updateFriends =
        ProviderContainer().read(friendsLogicProvider).friends.values;
    if (HiveSettingsDB.wantSeeFullOfProcession && rtFriends != null) {
      List<Friend> fList = <Friend>[];
      for (var f in rtFriends.friends.values) {
        if (f.specialValue == 0) continue; //normal friend added at last
        var fr = f.toFriend();
        if (fr.longitude != 0 && fr.latitude != 0) {
          if (fr.specialValue == 1) {
            fr.name = Localize.current.head;
          }
          if (fr.specialValue == 2) {
            fr.name = Localize.current.tail;
          }
          if (fr.specialValue == 99) {
            fr.name = Localize.current.participant;
          }
          fList.add(fr);
        }
      }
      fList.addAll(updateFriends.where((f) => f.isOnline && f.isActive));
      return fList;
    }
    return updateFriends.where((f) => f.isOnline && f.isActive);
  }

  Iterable<Friend> updateMapPointFriends(FriendsMessage rtFriends) {
    //update in Provider
    var userdata = ProviderContainer().read(locationProvider).userLatLng;
    var updatedFriends = ProviderContainer()
        .read(friendsLogicProvider)
        .updateFriendInProcession(rtFriends, user.position, user.eta ?? 0,
            userdata?.latitude, userdata?.longitude);
    //if (kDebugMode)return updateFriends.where((f) => f.name.isNotEmpty);
    return updatedFriends.where((f) => f.isOnline && f.isActive);
  }

  static Future<RealtimeUpdate> wampUpdate([dynamic message]) async {
    BnLog.debug(
      className: 'Future<RealtimeUpdate>  wampUpdate',
      methodName: 'sendLocation',
      text: 'will send:$message',
    );

    Completer completer = Completer();
    BnWampMessage bnWampMessage = BnWampMessage(WampMessageType.call, completer,
        WampEndpoint.getrealtimeupdate, message);
    var wampResult = await WampV2.instance
        .addToWamp<RealtimeUpdate>(bnWampMessage)
        .timeout(wampTimeout)
        .catchError((error, stackTrace) => RealtimeUpdate.rpcError(error));
    if (wampResult is Map<String, dynamic>) {
      var update = MapperContainer.globals.fromMap<RealtimeUpdate>(wampResult);
      return update;
    }
    if (wampResult is RealtimeUpdate) {
      return wampResult;
    }
    return RealtimeUpdate.rpcError(Exception(WampError('unknown')));
  }
}
