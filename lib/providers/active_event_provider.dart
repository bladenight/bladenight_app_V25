import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/notification/notification_helper.dart';
import '../helpers/watch_communication_helper.dart';
import '../models/event.dart';

part 'active_event_provider.g.dart';

@Riverpod(keepAlive: true)
class ActiveEvent extends _$ActiveEvent {

  @override
  Event build() {
    state = HiveSettingsDB.getActualEvent;
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
          await Future.delayed(const Duration(milliseconds: 500));
          refresh(forceUpdate: true);
          //don't update
          return;
        }
        SendToWatch.updateEvent(rpcEvent);
        var oldEventInPrefs = HiveSettingsDB.getActualEvent;
        //get route points on event update to update Map
        if (oldEventInPrefs.compareTo(rpcEvent) != 0) {
          state = rpcEvent;
          HiveSettingsDB.setActualEvent(rpcEvent);
          if ((DateTime.now().difference(lastUpdate)).inSeconds > 60) {
            //avoid multiple notifications on force update
            if (!kIsWeb && state.status != EventStatus.finished) {
              NotificationHelper().updateNotifications(oldEventInPrefs, state);
            }
          }
        }
        state = rpcEvent;
      }
    } catch (e) {
      print(e);
      state = HiveSettingsDB.getActualEvent;
      SendToWatch.updateEvent(state);
    }
  }
}
