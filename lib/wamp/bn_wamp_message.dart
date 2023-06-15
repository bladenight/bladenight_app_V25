import 'dart:async';

import '../helpers/wamp/message_types.dart';
import '../helpers/wamp/random_id.dart';

class BnWampMessage {
  final WampMessageType messageType;
  final String endpoint;
  final dynamic message;
  final Completer completer;
  final DateTime dateTime = DateTime.now();
  final String id = randomId();

  BnWampMessage(this.messageType, this.completer, this.endpoint,
      [this.message]);

  @override
  toString(){
    return '${messageType.toString()}, EP:$endpoint ,id:$id';

  }
}
