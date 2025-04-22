import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/logger/logger.dart';
import '../helpers/notification/notification_helper.dart';
import '../helpers/watch_communication_helper.dart';
import '../main.dart';
import '../models/event.dart';
import '../models/route.dart';
import '../wamp/wamp_exception.dart';
import '../wamp/wamp_v2.dart';
import 'app_start_and_router/go_router.dart';

class ActiveEventProvider with ChangeNotifier {
  static ActiveEventProvider? _instance =
      ActiveEventProvider._privateConstructor();

  //instance factory
  factory ActiveEventProvider() {
    _instance ??= ActiveEventProvider._privateConstructor();
    return _instance!;
  }

  StreamSubscription<Event>? _evtStream;

  Event get event => _event;
  Event _event = Event.init;
  bool _mapPushed = false;
  int _fails = 0;

  ActiveEventProvider._privateConstructor() {
    runZonedGuarded(() async {
      await _init();
    }, errorHandler);
  }

  void errorHandler(Object error, StackTrace stack) {}

  @override
  void dispose() {
    _evtStream?.cancel();
    super.dispose();
  }

  Future<Event> _init() async {
    _event = HiveSettingsDB.getActualEvent
        .copyWith(rpcException: WampException(WampExceptionReason.offline));
    _evtStream =
        WampV2().eventUpdateStreamController.stream.listen((event) async {
      if (event.nodes == [] && event.status != EventStatus.noevent) {
        //get route points if not delivered
        var rn =
            await RoutePoints.getActiveRoutePointsByNameWamp(event.routeName);
        _event = event.copyWith(nodes: rn.points);
      } else {
        _event = event;
      }
      notifyListeners();
      SendToWatch.updateEvent(event);
      if (event.isRunning && !_mapPushed) {
        _mapPushed = true;
        rootNavigatorKey.currentContext?.goNamed(AppRoute.map.name);
      }
    });
    refresh(forceUpdate: true);
    notifyListeners();
    return _event;
  }

  update(Event event) {
    _event = event;
    notifyListeners();
  }

  ///Refresh [Event]
  Future<void> refresh({bool forceUpdate = false}) async {
    try {
      //avoid permanent trigger
      var lastUpdate = HiveSettingsDB.actualEventLastUpdate;
      var diffSec = DateTime.now().difference(lastUpdate).inSeconds;
      if (diffSec > 10 || forceUpdate) {
        var rpcEvent = await Event.getEventWamp(forceUpdate: forceUpdate);
        if (rpcEvent.rpcException != null) {
          _fails++;
          if (_fails < 3) {
            await Future.delayed(const Duration(milliseconds: 2000));
            if (forceUpdate) refresh(forceUpdate: true);
          } else {
            _event = rpcEvent;
            _fails = 0;
            notifyListeners();
          }
          return;
        }

        var oldEventInPrefs = HiveSettingsDB.getActualEvent;
        if (kIsWeb || oldEventInPrefs.compareTo(rpcEvent) != 0) {
          if (rpcEvent.nodes == [] && rpcEvent.status != EventStatus.noevent) {
            //get route points if not delivered
            var rn = await RoutePoints.getActiveRoutePointsByNameWamp(
                rpcEvent.routeName);
            _event = rpcEvent.copyWith(nodes: rn.points);
          } else {
            _event = rpcEvent;
          }
          notifyListeners();
          SendToWatch.updateEvent(_event);
          HiveSettingsDB.setActualEvent(_event);
          if ((DateTime.now().difference(lastUpdate)).inSeconds > 60) {
            //avoid multiple notifications on force update
            if (!kIsWeb && _event.status != EventStatus.finished) {
              NotificationHelper().updateNotifications(oldEventInPrefs, _event);
            }
          }
        }
        return; //avoid 2nd trigger
      }
    } catch (e) {
      BnLog.error(text: 'failed Refresh activeEvent', exception: e);
    }
    _event = HiveSettingsDB.getActualEvent;
    SendToWatch.updateEvent(_event);
    notifyListeners();
  }
}

final activeEventProviderInstance =
    ChangeNotifierProvider((ref) => ActiveEventProvider());

final activeEventProvider = Provider.autoDispose((ref) {
  return ref.watch(activeEventProviderInstance.select((ae) => ae.event));
});
