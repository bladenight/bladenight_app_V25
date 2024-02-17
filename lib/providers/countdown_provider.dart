/*import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app_settings/app_constants.dart';
import 'location_provider.dart';

part 'countdown_provider.g.dart';
/*
@riverpod
double percentLeft(Pref ref) {
  return ref.watch(timerModelProvider.notifier).percentLeft;
}*/

@riverpod
double percentLeft(Ref ref) {
  return ref.watch(timerModelProvider.notifier).percentLeft;
}

final percentLeftProvider1 = Provider<double>((ref) {
  return ref.watch(timerModelProvider.notifier).percentLeft;
});

@Riverpod(keepAlive: true)
class TimerModel extends _$TimerModel {
  late int timeLeft = 0;
  late double percentLeft = 0.0;

  static const int _initialDuration = defaultRealtimeUpdateInterval;

  final Ticker _ticker = Ticker();
  StreamSubscription<int>? _tickerSubscription;

  static int _durationInSeconds(int duration) {
    return duration;
  }

  ///Start timer from external
  void start() {
    _startTimer();
  }

  void stop() {
    _tickerSubscription?.cancel();
    _tickerSubscription = null;
  }

  void _startTimer() {
    _tickerSubscription?.cancel();
    _tickerSubscription =
        _ticker.tick(ticks: _initialDuration).listen((duration) {
      //state = TimerModel(duration, duration / defaultRealtimeUpdateInterval);
    });

    _tickerSubscription?.onDone(() {
      //state = TimerModel(0, 0.0);
      _reset();
      return;
    });

    //state = TimerModel(_initialDuration, 1.0);
  }

  void _reset() {
    _tickerSubscription?.cancel();
    // state = _initialState;
    LocationProvider.instance.getLastRealtimeData();
    _startTimer();
  }

  @override
  Object? build() {
    return TimerModel();
  }
}

class Ticker {
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(
      const Duration(seconds: 1),
      (x) => ticks - x - 1,
    ).take(ticks);
  }
}
*/