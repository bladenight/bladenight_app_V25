import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/notification/notification_helper.dart';
import '../helpers/watch_communication_helper.dart';
import '../models/event.dart';
import '../models/route.dart';
import '../wamp/wamp_exception.dart';
import '../wamp/wamp_v2.dart';
import 'app_start_and_router/go_router.dart';

part 'active_event_provider.g.dart';

@Riverpod(keepAlive: true)
class ActiveEvent extends _$ActiveEvent {
  StreamSubscription<Event>? _evtStream;
  bool _hasPushed = false;

  @override
  Event build() {
    state = HiveSettingsDB.getActualEvent
        .copyWith(rpcException: WampException('offline'));
    _evtStream =
        WampV2().eventUpdateStreamController.stream.listen((event) async {
      if (event.nodes == [] && event.status != EventStatus.noevent) {
        //get route points if not delivered
        var rn =
            await RoutePoints.getActiveRoutePointsByNameWamp(event.routeName);
        state = event.copyWith(nodes: rn.points);
        SendToWatch.updateEvent(event);
      } else {
        state = event;
        SendToWatch.updateEvent(event);
      }
      if (event.isActive && !_hasPushed) {
        _hasPushed = true;
        ref.read(goRouterProvider).goNamed(AppRoute.map.name);
      }
    });

    ref.onDispose(() {
      _evtStream?.cancel();
    });
    return state;
  }

  update(Event event) {
    state = event;
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
          state.rpcException = rpcEvent.rpcException;
          await Future.delayed(const Duration(milliseconds: 1000));
          refresh(forceUpdate: true);
          //don't update
          return;
        }

        var oldEventInPrefs = HiveSettingsDB.getActualEvent;
        if (oldEventInPrefs.compareTo(rpcEvent) != 0) {
          if (rpcEvent.nodes == [] && rpcEvent.status != EventStatus.noevent) {
            //get route points if not delivered
            var rn = await RoutePoints.getActiveRoutePointsByNameWamp(
                rpcEvent.routeName);
            state = rpcEvent.copyWith(nodes: rn.points);
          } else {
            state = rpcEvent;
          }

          SendToWatch.updateEvent(state);
          HiveSettingsDB.setActualEvent(state);
          if ((DateTime.now().difference(lastUpdate)).inSeconds > 60) {
            //avoid multiple notifications on force update
            if (!kIsWeb && state.status != EventStatus.finished) {
              NotificationHelper().updateNotifications(oldEventInPrefs, state);
            }
          }
        }
      }
    } catch (e) {
      print(e);
      state = HiveSettingsDB.getActualEvent;
      SendToWatch.updateEvent(state);
    }
  }
}
