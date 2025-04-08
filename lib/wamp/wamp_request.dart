import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';

import '../app_settings/app_constants.dart';
import '../helpers/logger/logger.dart';
import '../helpers/wamp/message_types.dart';
import 'bn_wamp_message.dart';
import 'wamp_endpoints.dart';
import 'wamp_exception.dart';
import 'wamp_rpc.dart';
import 'wamp_v2.dart';

mixin WampRequest<T> implements WampRpc<T> {
  ///Send a wamp Request with type call
  ///[message] if message empty get actual data
  Future<T> wampCall(WampEndpoint wampEndpoint, [dynamic message]) async {
    BnLog.debug(
      className: toString(),
      methodName: 'sendToWamp',
      text: message == null
          ? 'SendToWamp $wampEndpoint -> no message'
          : 'SendToWamp $wampEndpoint -> message: $message',
    );

    Completer? completer = Completer();
    BnWampMessage? bnWampMessage = BnWampMessage(
        WampMessageType.call, completer, wampEndpoint.toString(), message);
    try {
      var wampResult = await WampV2()
          .addToWamp(bnWampMessage)
          .timeout(wampTimeout)
          .catchError((error, stackTrace) => error);
      BnLog.debug(
        className: toString(),
        methodName: 'sendToWamp',
        text: wampResult == null
            ? 'SendToWamp $wampEndpoint -> no results'
            : 'SendToWamp $wampEndpoint -> result: $wampResult',
      );

      if (wampResult is Map<String, dynamic>) {
        var update = MapperContainer.globals.fromMap<T>(wampResult);
        return update;
      }
      if (wampResult is T) {
        return wampResult;
      }
      if (T is WampRpc) {}
      if (wampResult is WampException) {
        return (T as WampRpc).rpcError(wampResult);
      }
      if (wampResult is TimeoutException) {
        return (T as WampRpc).rpcError(wampResult);
      }
      return (T as WampRpc)
          .rpcError(WampException(WampExceptionReason.unknown));
    } catch (e) {
      BnLog.verbose(text: 'Error ${T.toString()} ${e.toString()}');
    }

    return (T as WampRpc).rpcError(WampException(WampExceptionReason.unknown));
  }

  @override
  Exception? rpcException;

  @override
  rpcError(Exception wampResult) {
    rpcException = wampResult;
  }

  @override
  DateTime get timeStamp => DateTime.now();
}
