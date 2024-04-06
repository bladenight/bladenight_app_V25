import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../wamp/wamp_v2.dart';

part 'wamp_provider.g.dart';

@Riverpod(keepAlive: true)
class Wamp extends _$Wamp {
  @override
  WampV2 build() {
    return WampV2.instance;
  }
}

@Riverpod(keepAlive: true)
class WampEventStream extends _$WampEventStream {
  @override
  Stream build() {
    return ref.watch(wampProvider).eventStreamController.stream;
  }
}