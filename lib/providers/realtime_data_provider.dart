import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../helpers/logger.dart';
import '../helpers/wamp/subscribe_message.dart';
import '../models/realtime_update.dart';
import '../wamp/wamp_v2.dart';
import 'is_tracking_provider.dart';
import 'location_provider.dart';

part 'realtime_data_provider.g.dart';

@Riverpod(keepAlive: true)
class RealtimeData extends _$RealtimeData {
  int _maxFails = 3;
  Timer? _timer;
  DateTime lastUpdate = DateTime(2000);
  StreamSubscription<RealtimeUpdate?>? _listener;
  int _realTimeDataSubscriptionId = 0;

  @override
  RealtimeUpdate? build() {
    var isTracking = ref.watch(isTrackingProvider);
    _listener =
        WampV2.instance.realTimeUpdateStreamController.stream.listen((event) {
      BnLog.debug(text: 'rtEvent $event');
      state = event;
      _reStartTimer();
    });

    ref.onDispose(() {
      BnLog.debug(text: 'rtProvide dispose');
      _timer?.cancel();
      _realTimeDataSubscriptionId = 0;
      _listener?.cancel();
    });

    if (!isTracking) {
      _subscribe();
      _reStartTimer();
    } else {
      _unsubscribe();
      _stopTimer();
    }
    return stateOrNull;
  }

  //call timer if subscription fails
  void _reStartTimer() {
    _timer?.cancel();
    _timer = null;
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      var result = await refresh();
      if (result != null) {
        lastUpdate = DateTime.now();
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

  Future _subscribe() async {
    if (!WampV2.instance.subscriptions.contains(3589978069) ||
        _realTimeDataSubscriptionId == 0) {
      _realTimeDataSubscriptionId = await subscribeMessage('RealtimeData');
      if (_realTimeDataSubscriptionId == 0) {
        //workaround if subscription fails
        LocationProvider.instance.refresh();
      }
    }
  }
}
