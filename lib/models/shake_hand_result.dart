import 'dart:async';

import '../wamp/wamp_endpoints.dart';
import 'shake_hands.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../app_settings/app_constants.dart';
import '../helpers/deviceid_helper.dart';
import '../helpers/wamp/message_types.dart';
import '../wamp/bn_wamp_message.dart';
import '../wamp/wamp_error.dart';
import '../wamp/wamp_v2.dart';
part 'shake_hand_result.mapper.dart';

@MappableClass()
class ShakeHandResult with ShakeHandResultMappable{
  @MappableField(key: 'sta')
  final bool status;
  @MappableField(key: 'mbu')
  final int minBuild;

  Exception? rpcException;

  /// Get result of ShakeHand
  /// [status] = [true] -> App not outdated
  /// [status] = [false] -> App is outdated
  /// [minBuild] = Minimum required Buildnumber
  ShakeHandResult(
      {required this.status, required this.minBuild, this.rpcException});

  static Future<ShakeHandResult> shakeHandsWamp() async {
    Completer completer = Completer();
    BnWampMessage bnWampMessage = BnWampMessage(
      WampMessageType.call,
      completer,
      WampEndpoint.shakeHand,
      {
        'bui': await DeviceId.appBuildNumber,
        'did': await DeviceId.getId,
        'man': DeviceId.deviceManufacturer,
        'mod': 'unused',
        'rel': await DeviceId.getOSVersion
      },
    );
    var wampResult = await WampV2.instance
        .addToWamp<ShakeHand>(bnWampMessage)
        .timeout(wampTimeout)
        .catchError((error, stackTrace) =>
            ShakeHandResult(status: true, minBuild: 1, rpcException: error));
    if (wampResult is Map<String, dynamic>) {
      var shkRes = MapperContainer.globals.fromMap<ShakeHandResult>(wampResult);
      return shkRes;
    }
    if (wampResult is ShakeHandResult) {
      return wampResult;
    }
    return ShakeHandResult(
        status: true,
        minBuild: 1,
        rpcException: Exception(WampError('unknown')));
  }
}
