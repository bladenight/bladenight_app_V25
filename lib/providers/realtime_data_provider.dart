import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../helpers/logger.dart';
import '../helpers/wamp/subscribe_message.dart';
import '../models/realtime_update.dart';
import '../wamp/wamp_v2.dart';
import 'is_tracking_provider.dart';

part 'realtime_data_provider.g.dart';

@Riverpod(keepAlive: true)
class RealtimeData extends _$RealtimeData {
  int _maxFails = 3;
  int _maxSubscribeFails = 3;
  bool _isTracking = false;
  Timer? _timer;
  DateTime lastUpdate = DateTime(2000);
  StreamSubscription<RealtimeUpdate?>? _realtTimeDataStreamListener;
  int _realTimeDataSubscriptionId = 0;
  bool _isWampConnected = false;
  bool _isOnline = true;

  StreamSubscription<bool>? _wampConnectedListener;
  StreamSubscription<InternetStatus>? _onlineListener;

  @override
  RealtimeUpdate? build() {
    _wampConnectedListener =
        WampV2.instance.wampConnectedStreamController.stream.listen((event) {
      if (event) {
        //resubscribe after offline if not tracking
        _isWampConnected = event;
        _subscribeIfNeeded(_isTracking);
      }
    });
    _onlineListener =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          _isOnline = true;
          _maxSubscribeFails = 3;
          break;
        case InternetStatus.disconnected:
          _isOnline = false;
          break;
      }
    });

    _isTracking = ref.watch(isTrackingProvider);
    _realtTimeDataStreamListener =
        WampV2.instance.realTimeUpdateStreamController.stream.listen((event) {
      BnLog.debug(text: 'rtEvent $event');
      state = event;
      _reStartTimer();
    });

    ref.onDispose(() {
      BnLog.debug(text: 'rtProvide dispose');
      _wampConnectedListener?.cancel();
      _timer?.cancel();
      _realTimeDataSubscriptionId = 0;
      _realtTimeDataStreamListener?.cancel();
    });
    _subscribeIfNeeded(_isTracking);

    return stateOrNull;
  }

  void _subscribeIfNeeded(bool isTracking) async {
    if (!isTracking) {
      if (_maxSubscribeFails <= 0) {
        return;
      }
      var res = await _subscribe();
      if (res == false) {
        _maxSubscribeFails--;
      }
      _reStartTimer();
    } else {
      _maxSubscribeFails = 3;
      _unsubscribe();
      _stopTimer();
    }
  }

  //call timer if subscription fails
  void _reStartTimer() {
    _timer?.cancel();
    _timer = null;
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      var result = await refresh();
      if (result != null) {
        lastUpdate = result.timeStamp;
        state = result;
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  ///Update on location update
  update(RealtimeUpdate rtu) {
    state = rtu;
  }

  Future<RealtimeUpdate?> refresh({bool force = false}) async {
    var timeDiff = DateTime.now().difference(lastUpdate);
    BnLog.trace(
        text: '${timeDiff.inSeconds} Lastupdt: $lastUpdate',
        methodName: 'refresh',
        className: toString());
    if (!force && timeDiff < const Duration(seconds: 13)) {
      return state;
    }
    if (!_isOnline && timeDiff < const Duration(seconds: 50)) {
      BnLog.trace(
          text: '${timeDiff.inSeconds} not online < 50 sec. : $lastUpdate',
          methodName: 'refresh',
          className: toString());
      return state;
    } else if (!_isOnline) {
      BnLog.trace(
          text:
              '${timeDiff.inSeconds} not online more than 50 sec. : $lastUpdate',
          methodName: 'refresh',
          className: toString());
      return null;
    }

    var update = await RealtimeUpdate.wampUpdate();
    if (update.rpcException != null) {
      _maxFails--;
      if (_maxFails == 0) {
        //trigger only once a time
        BnLog.warning(text: 'RealtimeDataprovider exceed maximum ');
      }
      if (_maxFails <= 0) {
        return null;
      }
      return update;
    }
    _maxFails = 3;
    return update;
  }

  void _unsubscribe() async {
    if (WampV2.instance.subscriptions.contains(3589978069)) {
      await unSubscribeMessage(3589978069);
      _realTimeDataSubscriptionId = 0;
    }
  }

  Future<bool> _subscribe() async {
    if (!WampV2.instance.subscriptions.contains(3589978069) ||
        _realTimeDataSubscriptionId == 0) {
      _realTimeDataSubscriptionId = await subscribeMessage('RealtimeData');
      if (_realTimeDataSubscriptionId == 0) {
        return false;
        //workaround if subscription fails
        //LocationProvider.instance.refresh();
      }
    }
    return true;
  }
}
