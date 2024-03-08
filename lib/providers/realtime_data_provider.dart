import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../helpers/logger.dart';
import '../models/realtime_update.dart';
import '../wamp/wamp_v2.dart';
import 'is_tracking_provider.dart';

part 'realtime_data_provider.g.dart';

@Riverpod(keepAlive: true)
class RealtimeData extends _$RealtimeData {
  int _maxFails = 3;
  Timer? _timer;
  DateTime lastUpdate = DateTime(2000);
  StreamSubscription<RealtimeUpdate?>? _listener;

  @override
  RealtimeUpdate? build() {
    var isTracking = ref.watch(isTrackingProvider);
    _listener =
        WampV2.instance.realTimeUpdateStreamController.stream.listen((event) {
      BnLog.info(text: 'rtevent $event');
      state = event;
      _timer?.cancel();
    });

    ref.onDispose(() {
      BnLog.info(text: 'rtprovide dispose');
      _timer?.cancel();
      _listener?.cancel();
    });

    if (!isTracking) {
      _reStartTimer();
    } else {
      _stopTimer();
    }
    return stateOrNull;
  }

  //call timer if subscription fails
  void _reStartTimer() {
    _timer?.cancel();
    _timer = null;
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      print('timer refresh ');
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
    print('${timeDiff.inSeconds} Lastupdt: $lastUpdate');
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
}
