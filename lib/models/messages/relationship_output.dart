import 'dart:async';

import 'relationship_input.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../app_settings/app_constants.dart';
import '../../helpers/wamp/message_types.dart';
import '../../wamp/bn_wamp_message.dart';
import '../../wamp/wamp_endpoints.dart';
import '../../wamp/wamp_exception.dart';
import '../../wamp/wamp_v2.dart';

part 'relationship_output.mapper.dart';

@MappableClass()
class RelationshipOutputMessage with RelationshipOutputMessageMappable {
  @MappableField(key: 'fid')
  late final int friendId;
  @MappableField(key: 'rid')
  late final int requestId;

  Exception? rpcException;

  RelationshipOutputMessage(
      {required this.friendId, required this.requestId, this.rpcException});

  static RelationshipOutputMessage rpcError(Exception exception) {
    return RelationshipOutputMessage(
        friendId: 0, requestId: 0, rpcException: exception);
  }

  static Future<RelationshipOutputMessage?> getRelationShip(
      RelationshipInputMessage inputMessage) async {
    Completer completer = Completer();
    BnWampMessage bnWampMessage = BnWampMessage(WampMessageType.call, completer,
        WampEndpoint.createrelationship, inputMessage.toMap());
    var wampResult = await WampV2()
        .addToWamp<RelationshipOutputMessage>(bnWampMessage)
        .timeout(wampTimeout)
        .catchError(
            (error, stackTrace) => RelationshipOutputMessage.rpcError(error));
    if (wampResult is Map<String, dynamic>) {
      var update = MapperContainer.globals
          .fromMap<RelationshipOutputMessage>(wampResult);
      return update;
    }
    if (wampResult is RelationshipOutputMessage) {
      return wampResult;
    }
    if (wampResult is WampException) {
      return RelationshipOutputMessage.rpcError(wampResult);
    }
    if (wampResult is TimeoutException) {
      return RelationshipOutputMessage.rpcError(wampResult);
    }
    return RelationshipOutputMessage.rpcError(
        WampException(WampExceptionReason.unknown));
  }

  ///Get RelationshipOutputMessage (include RelationshipOutputMessage.rpcError)
  static Future<RelationshipOutputMessage?> createRelationShip(
      RelationshipInputMessage inputMessage) async {
    Completer completer = Completer();
    BnWampMessage bnWampMessage = BnWampMessage(WampMessageType.call, completer,
        WampEndpoint.createrelationship, inputMessage.toMap());
    var wampResult = await WampV2()
        .addToWamp<RelationshipOutputMessage>(bnWampMessage)
        .timeout(wampTimeout)
        .catchError((error, stackTrace) => error);
    if (wampResult is Map<String, dynamic>) {
      var update = MapperContainer.globals
          .fromMap<RelationshipOutputMessage>(wampResult);
      return update;
    }
    if (wampResult is RelationshipOutputMessage) {
      return wampResult;
    }
    if (wampResult is WampException) {
      return RelationshipOutputMessage.rpcError(wampResult);
    }
    if (wampResult is TimeoutException) {
      return RelationshipOutputMessage.rpcError(wampResult);
    }
    return RelationshipOutputMessage.rpcError(
        WampException(WampExceptionReason.unknown));
  }
}
