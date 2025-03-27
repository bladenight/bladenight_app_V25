import 'dart:async';

import '../../app_settings/app_constants.dart';
import '../../wamp/bn_wamp_message.dart';
import '../../wamp/wamp_exception.dart';
import '../../wamp/wamp_v2.dart';

Future<int> subscribeMessage(String topic) async {
  Completer completer = Completer();
  var bnWampMessage = SubscribeWampMessage(completer, 'RealtimeData');

  var wampResult = await WampV2()
      .addToWamp<int>(bnWampMessage)
      .timeout(wampTimeout)
      .catchError((error, stackTrace) => WampException(error.toString()));
  if (wampResult is WampException) {
    return 0;
  }
  if (wampResult is TimeoutException) {
    return 0;
  }
  return wampResult ?? -1;
}

//[UNSUBSCRIBE, Request|id, SUBSCRIBED.Subscription|id]
Future<bool> unSubscribeMessage(int subscriptionId) async {
  Completer completer = Completer();
  var bnWampMessage = UnsubscribeWampMessage(completer, subscriptionId);

  var wampResult = await WampV2()
      .addToWamp(bnWampMessage)
      .timeout(wampTimeout)
      .catchError((error, stackTrace) => WampException(error.toString()));
  if (wampResult is WampException) {
    return false;
  }
  if (wampResult is TimeoutException) {
    return false;
  }
  if (wampResult == null) {
    return false;
  }
  return true;
}
