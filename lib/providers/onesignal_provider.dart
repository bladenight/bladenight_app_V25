import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onesignal_provider.g.dart';

@riverpod
FutureOr<String?> onesignalId(Ref ref) async {
  var res = await OneSignal.User.getOnesignalId();
  return res;
}
