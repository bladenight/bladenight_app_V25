import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app_settings/server_connections.dart';
import '../helpers/enums/tracking_type.dart';
import '../helpers/logger.dart';
import '../helpers/wamp/subscribe_message.dart';
import '../models/realtime_update.dart';
import '../wamp/wamp_v2.dart';
import 'location_provider.dart';
import 'network_connection_provider.dart';

part 'realtime_data_provider.g.dart';

@Riverpod(keepAlive: true)
class RealtimeData extends _$RealtimeData {
  int _maxFails = 3;
  int _maxSubscribeFails = 3;
  TrackingType _trackingType = TrackingType.noTracking;
  Timer? _timer;
  DateTime lastUpdate = DateTime(2000);
  StreamSubscription<RealtimeUpdate?>? _realTimeDataStreamListener;
  int _realTimeDataSubscriptionId = 0;
  bool _isOnline = true;

  StreamSubscription<bool>? _wampConnectedListener;
  StreamSubscription<InternetStatus>? _onlineListener;

  @override
  RealtimeUpdate? build() {
    _wampConnectedListener = WampV2
        .instance.wampConnectedStreamController.stream
        .listen((event) async {
      if (event) {
        await (Future.delayed(const Duration(seconds: 10)));
        _maxSubscribeFails = 3;
        _subscribeIfNeeded(_trackingType);
      } else {
        _realTimeDataSubscriptionId = 0;
      }
    });
    var networkProviderStatus =
        ref.watch(networkAwareProvider).connectivityStatus;
    switch (networkProviderStatus) {
      case ConnectivityStatus.online:
        _isOnline = true;
        break;
      case ConnectivityStatus.error:
        _isOnline = false;
        _realTimeDataSubscriptionId = 0;
        break;
      case ConnectivityStatus.serverReachable:
        _isOnline = true;
        break;
      case ConnectivityStatus.serverNotReachable:
      case ConnectivityStatus.disconnected:
        _isOnline = false;
        _realTimeDataSubscriptionId = 0;
        break;
      case ConnectivityStatus.unknown:
        break;
    }

    _trackingType = ref.watch(trackingTypeProvider);
    _realTimeDataStreamListener =
        WampV2.instance.realTimeUpdateStreamController.stream.listen((event) {
      if (event != null && event.rpcException != null) {
        return;
      }
      BnLog.debug(text: 'rtEvent $event');
      state = event;
      _reStartTimer();
    });

    ref.onDispose(() {
      BnLog.debug(text: 'rtProvider dispose');
      _wampConnectedListener?.cancel();
      _timer?.cancel();
      _realTimeDataSubscriptionId = 0;
      _realTimeDataStreamListener?.cancel();
      _onlineListener?.cancel();
    });
    _subscribeIfNeeded(_trackingType);

    return stateOrNull;
  }

  void _subscribeIfNeeded(TrackingType trackingType) async {
    if (trackingType == TrackingType.noTracking) {
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
      _stopTimer(); //realtimeDataUpdate in LocationProvider handled
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
        text: 'LastRealtimeUpdate ${timeDiff.inSeconds}s ago at: $lastUpdate',
        methodName: 'refresh',
        className: toString());
    if (!force && timeDiff < const Duration(seconds: 13)) {
      return state;
    }
    if (!_isOnline && timeDiff < const Duration(seconds: 50)) {
      BnLog.trace(
          text: '${timeDiff.inSeconds}s not online < 50 sec. : $lastUpdate',
          methodName: 'refresh',
          className: toString());
      return state;
    } else if (!_isOnline) {
      BnLog.trace(
          text:
              '${timeDiff.inSeconds}s not online more than 50 sec. : $lastUpdate',
          methodName: 'refresh',
          className: toString());
      return null;
    }

    var update = await RealtimeUpdate.realtimeDataUpdate();
    if (update.rpcException != null) {
      _maxFails--;
      if (_maxFails == 0) {
        //trigger only once a time
        BnLog.warning(text: 'RealtimeDataprovider exceed maximum ');
        await Future.delayed(const Duration(seconds: 15));
        _maxFails = 3;
      }
      if (_maxFails <= 0) {
        return null;
      }
      return update;
    }
    _maxFails = 3;
    WampV2.instance.subscriptions.clear();
    _subscribeIfNeeded(_trackingType);
    return update;
  }

  void _unsubscribe() async {
    for (var subscriptionId in WampV2.instance.subscriptions) {
      await unSubscribeMessage(subscriptionId);
    }
    _realTimeDataSubscriptionId = 0;
  }

  Future<bool> _subscribe() async {
    for (var subscr in WampV2.instance.subscriptions) {
      if (subscr == realtimeSubscriptionId) return true;
    }
    _realTimeDataSubscriptionId = await subscribeMessage('RealtimeData');
    //3589978069
    if (_realTimeDataSubscriptionId == 0) {
      return false;
      //workaround if subscription fails
      //LocationProvider.instance.refresh();
    }
    return true;
  }
}
