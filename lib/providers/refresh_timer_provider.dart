import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_settings/app_constants.dart';
import 'location_provider.dart';

@immutable
class TimerModel {
  const TimerModel(this.timeLeft, this.percentLeft);

  final int timeLeft;
  final double percentLeft;
}

class TimerNotifier extends StateNotifier<TimerModel> {
  TimerNotifier() : super(_initialState);

  static const int _initialDuration = defaultRealtimeUpdateInterval;
  static final _initialState =
      TimerModel(_durationInSeconds(_initialDuration), 1.0);

  final Ticker _ticker = Ticker();
  StreamSubscription<int>? _tickerSubscription;

  static int _durationInSeconds(int duration) {
    return duration;
  }

  ///Start timer by external
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
      state = TimerModel(duration, duration / defaultRealtimeUpdateInterval);
    });

    _tickerSubscription?.onDone(() {
      state = TimerModel(state.timeLeft, 0.0);
      _reset();
      return;
    });

    state = const TimerModel(_initialDuration, 1.0);
  }

  void _reset() {
    _tickerSubscription?.cancel();
    state = _initialState;
    LocationProvider.instance.refresh();
    _startTimer();
  }

  @override
  void dispose() {
    _tickerSubscription?.cancel();
    super.dispose();
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

final refreshTimerProvider = StateNotifierProvider<TimerNotifier, TimerModel>(
  (ref) => TimerNotifier(),
);

final _timeLeftProvider = Provider<int>((ref) {
  return ref.watch(refreshTimerProvider).timeLeft;
});

final timeLeftProvider = Provider<int>((ref) {
  return ref.watch(_timeLeftProvider);
});

final percentLeftProvider = Provider<double>((ref) {
  return ref.watch(refreshTimerProvider).percentLeft;
});
