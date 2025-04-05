import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';

import '../../app_settings/app_constants.dart';
import '../../helpers/wamp/message_types.dart';
import '../../wamp/bn_wamp_message.dart';
import '../../wamp/wamp_endpoints.dart';
import '../../wamp/wamp_exception.dart';
import '../../wamp/wamp_v2.dart';
import 'friend.dart';

part 'friends.mapper.dart';

@MappableClass()
class FriendsMessage with FriendsMessageMappable {
  @MappableField(key: 'fri')
  final Map<String, FriendMessage> friends;

  Exception? exception;

  FriendsMessage(this.friends, [this.exception]);

  static Future<FriendsMessage> getFriends(String deviceId) async {
    Completer completer = Completer();
    BnWampMessage bnWampMessage = BnWampMessage(
        WampMessageType.call, completer, WampEndpoint.getfriends, deviceId);
    var wampResult = await WampV2()
        .addToWamp<FriendsMessage>(bnWampMessage)
        .timeout(wampTimeout)
        .catchError((error, stackTrace) => error);
    if (wampResult is Map<String, dynamic>) {
      var value = MapperContainer.globals.fromMap<FriendsMessage>(wampResult);
      return value;
    }
    if (wampResult is FriendsMessage) {
      return wampResult;
    }
    if (wampResult is WampException) {
      return FriendsMessage(<String, FriendMessage>{});
    }
    if (wampResult is TimeoutException) {
      return FriendsMessage(<String, FriendMessage>{});
    }
    return FriendsMessage(<String, FriendMessage>{});
  }
}
