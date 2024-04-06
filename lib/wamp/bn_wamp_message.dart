import 'dart:async';
import 'dart:convert';

import '../helpers/wamp/message_types.dart';
import '../helpers/wamp/random_id.dart';

class BnWampMessage {
  final String? endpoint;
  final WampMessageType messageType;
  final dynamic message;
  final Completer completer;
  final DateTime dateTime = DateTime.now();
  final int requestId = randomId();

  BnWampMessage(this.messageType, this.completer, this.endpoint,
      [this.message]);

  String get getMessageAsJson => json.encode([
        messageType.messageID,
        requestId,
        {}, //no options
        'http://bladenight.app/rpc/$endpoint',
        if (message != null) message
      ]);

  @override
  toString() {
    return '${messageType.toString()}, rid:$requestId, {},'
        ' EP:http://bladenight.app/rpc/$endpoint, message:$message';
  }
}

class UnsubscribeWampMessage extends BnWampMessage {
  final int subscriptionId;

  UnsubscribeWampMessage(completer, this.subscriptionId, [message])
      : super(WampMessageType.unsubscribe, completer, message);

  //    [UNSUBSCRIBE, Request|id, SUBSCRIBED.Subscription|id]
  @override
  String get getMessageAsJson {
    return json.encode([messageType.messageID, requestId, subscriptionId]);
  }

  @override
  toString() {
    return 'UnsubscribeWampMessage ${messageType.toString()}, id:$requestId, subscriptionId:$subscriptionId';
  }
}

class SubscribeWampMessage extends BnWampMessage {
  SubscribeWampMessage(completer, this.topic, [message])
      : super(WampMessageType.subscribe, completer, message);
  final String topic;

  //       [SUBSCRIBE, Request|id, Options|dict, Topic|uri]
  @override
  String get getMessageAsJson {
    return json.encode([
      messageType.messageID,
      requestId,
      {},
      topic,
    ]);
  }

  @override
  toString() {
    return 'SubscribeWampMessage ${messageType.toString()}, ,id:$requestId, {}, topic:$topic';
  }
}
