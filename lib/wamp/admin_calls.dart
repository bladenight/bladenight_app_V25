import 'dart:async';

import '../app_settings/app_constants.dart';
import '../helpers/wamp/message_types.dart';
import '../pages/admin/widgets/admin_password_dialog.dart';
import 'bn_wamp_message.dart';
import 'wamp_endpoints.dart';
import 'wamp_error.dart';
import 'wamp_v2.dart';

class AdminCalls {
  static Future<bool> setActiveStatus(Map<String, dynamic> message) async {
    Completer completer = Completer();
    BnWampMessage bnWampMessage = BnWampMessage(WampMessageType.call, completer,
        WampEndpoint.setactivestatus, message);

    var wampResult = await WampV2.instance
        .addToWamp(bnWampMessage)
        .timeout(wampTimeout)
        .catchError((error, stackTrace) => WampError(error.toString()));
    if (wampResult is WampError) {
      return false;
    }
    return true;
  }

  static Future<bool> setActiveRoute(Map<String, dynamic> message) async {
    Completer completer = Completer();
    BnWampMessage bnWampMessage = BnWampMessage(WampMessageType.call, completer,
        WampEndpoint.setactiveroute, message);

    var wampResult = await WampV2.instance
        .addToWamp(bnWampMessage)
        .timeout(wampTimeout)
        .catchError((error, stackTrace) => WampError(error.toString()));
    if (wampResult is WampError) {
      return false;
    }
    return true;
  }

  static Future<bool> killServer(Map<String, dynamic> message) async {
    Completer completer = Completer();
    BnWampMessage bnWampMessage = BnWampMessage(
        WampMessageType.call, completer, WampEndpoint.killserver, message);

    var wampResult = await WampV2.instance
        .addToWamp(bnWampMessage)
        .timeout(wampTimeout)
        .catchError((error, stackTrace) => WampError(error.toString()));
    if (wampResult is WampError) {
      return false;
    }
    return true;
  }

  static Future<String> verifyAdminPassword(
      Map<String, dynamic> message) async {
    Completer completer = Completer();
    BnWampMessage bnWampMessage = BnWampMessage(
      WampMessageType.call,
      completer,
      WampEndpoint.verifyadminpassword,
      message,
    );

    var wampResult = await WampV2.instance
        .addToWamp(bnWampMessage)
        .timeout(wampTimeout)
        .catchError((error, stackTrace) => WampError(error.toString()));
    if (wampResult is String) {
      return wampResult;
    }
    return kInvalidPassword;
  }
}
