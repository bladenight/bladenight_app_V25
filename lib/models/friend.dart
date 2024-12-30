import 'dart:core';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import '../app_settings/app_configuration_helper.dart';
import '../generated/l10n.dart';
import '../pages/friends/widgets/friends_action_sheet.dart';
import 'color_mapper.dart';

part 'friend.mapper.dart';

/// Actions if edit a friend
///
enum FriendsAction {
  /// add a new friend
  addNew,

  /// link and add friend with received code
  addWithCode,

  /// send as nearby service advertiser
  addNearby,

  /// be browser and create a nearby connection
  acceptNearby,

  /// edit friend's data
  edit,

  /// remove friend and delete from server
  delete,
}

@MappableClass(includeCustomMappers: [ColorMapper()])
class Friend with FriendMappable {
  @MappableField()
  late String name;
  @MappableField(key: 'friendid')
  late int friendId;
  late bool isActive;
  @MappableField()
  late Color color;
  late bool isOnline;
  @MappableField()
  late int requestId = 0;
  late double speed = 0;
  @MappableField(key: 'rsp')
  late double realSpeed = 0.0;
  @MappableField(key: 'spv')
  late int specialValue = 0;
  late int? timestamp; // = DateTime.now().millisecondsSinceEpoch;
  late int? codeTimestamp;
  late double? latitude = defaultLatitude;
  late double? longitude = defaultLongitude;

  /// real time time to finish in procession
  int? relativeTime;

  ///driven distance from start
  int relativeDistance = 0;
  int absolutePosition = 0;

  ///positive when in front //negative when behind
  int? timeToUser;

  ///positive when in front //negative when behind
  int?
      distanceToUser; //position ${(friend.distanceToUser ?? 0).isNegative ? Localize.of(context).behindMe : Localize.of(context).aheadOfMe}

  ///friend has server entry
  bool hasServerEntry = true;

  Friend(
      {required this.name,
      required this.friendId,
      this.color = Colors.white24,
      this.isActive = false,
      this.requestId = 0,
      this.isOnline = false,
      this.speed = 0,
      this.longitude = 0.0,
      this.latitude = 0.0,
      this.relativeTime = 0,
      this.relativeDistance = 0,
      this.absolutePosition = 0,
      this.distanceToUser = 0,
      this.specialValue = 0,
      this.timeToUser = 0,
      this.timestamp = 0,
      this.codeTimestamp = 0,
      this.hasServerEntry = true}) {
    resetPositionData();
  }

  void resetPositionData() {
    relativeTime = null;
    relativeDistance = 0;
    absolutePosition = 0;
    latitude = null;
    longitude = null;
  }

  bool get codeExpired {
    if (codeTimestamp == null) return false;
    var codeDtTimeDiff = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(codeTimestamp!));
    if (codeTimestamp! > 0 && codeDtTimeDiff > const Duration(minutes: 59)) {
      return true;
    }
    return false;
  }

  String getFriendStatusText(BuildContext context) {
    String statustext = Localize.of(context).status_active;
    if (requestId > 0 && codeExpired) {
      return Localize.of(context).codeExpired;
    }
    if (requestId > 0) {
      return '${Localize.of(context).status_pending} ( Code: $requestId )';
    } else if (!isActive && hasServerEntry) {
      statustext = Localize.of(context).notVisibleOnMap;
    } else if (isActive && hasServerEntry) {
      statustext = Localize.of(context).ok;
    } else if (!hasServerEntry) {
      return Localize.of(context).notKnownOnServer;
    }

    if (isOnline) {
      statustext += ' | ${Localize.current.tracking}';
    } else {
      statustext += ' | ${Localize.current.noLocationAvailable}';
    }
    return statustext;
  }

  String formatDistance() {
    int meters = 0;
    meters = relativeDistance;
    String s = '- m';
    if (meters.abs() == 0) {
      return s;
    } else if (meters.abs() < 1000) {
      s = '$meters m';
    } else {
      double km = meters / 1000.0;
      s = '${km.toStringAsFixed(1)} km';
    }
    return s;
  }

  ///Compare two friends by [friend.name]
  ///returns 0 if equivalent
  int compareTo(Friend another) {
    if (name.toLowerCase().compareTo(another.name.toLowerCase()) != 0) {
      return 1;
    }
    if (friendId != another.friendId) {
      return 2;
    }
    return 0;
  }

  @override
  String toString() {
    return 'Friend name:$name,online: ${isOnline.toString()},color: $color,lat: $latitude,lon: $longitude,reldistance: $relativeDistance,active: ${isActive.toString()}';
  }
}

/*
@MappableClass()
class EditFriend with EditFriendMappable {
  @MappableField(key: 'action')
  late FriendsAction action;
  @MappableField(key: 'friend')
  late Friend? friend;
  @MappableField(key: 'name')
  late String? name;
  @MappableField(key: 'code')
  late int? code;
}*/
