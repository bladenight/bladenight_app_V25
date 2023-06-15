import 'dart:math';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import '../friend.dart';

part 'friend.mapper.dart';

@MappableClass()
class FriendMessage with FriendMessageMappable {
  @MappableField(key: 'req')
  final int requestId;
  @MappableField(key: 'fid')
  final int friendId;
  @MappableField(key: 'onl')
  final bool online;
  @MappableField(key: 'spv')
  final int specialValue;

  //MovingPoint
  @MappableField(key: 'pos')
  final int position;
  @MappableField(key: 'spd')
  final double speed;
  @MappableField(key: 'rsp')
  final double? realSpeed;
  @MappableField(key: 'eta')
  final int? eta;
  @MappableField(key: 'ior')
  final bool isOnRoute;
  @MappableField(key: 'iip')
  final bool isInProcession;
  @MappableField(key: 'lat')
  final double? latitude;
  @MappableField(key: 'lon')
  final double? longitude;
  @MappableField(key: 'acc')
  final int? accuracy;

   FriendMessage({
    required this.requestId,
    required this.online,
    required this.specialValue,
    this.eta,
    required this.isOnRoute,
    required this.isInProcession,
    this.latitude,
    this.longitude,
    this.accuracy,
    this.realSpeed,
    required this.position,
    required this.speed,
    required this.friendId,
  });

  Friend toFriend() {
    var fr = Friend(name: friendId.toString(), friendId: friendId);
    //Reset position data on create
    fr.latitude = latitude;
    fr.longitude = longitude;
    fr.realSpeed = realSpeed ?? 0.0;
    fr.specialValue = specialValue;
    fr.speed = speed;
    fr.isOnline = online;
    fr.relativeDistance = 0;
    fr.relativeTime = 0;
    fr.absolutePosition = position;
    fr.distanceToUser = 0;
    fr.timeToUser = 0;
    fr.timestamp = DateTime.now().microsecondsSinceEpoch;
    fr.color = Colors.primaries[Random().nextInt(friendId + 1)];
    return fr;
  }
}
