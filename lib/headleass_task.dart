/*import 'package:background_fetch/background_fetch.dart';
import '../logger.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:hive_flutter/adapters.dart';
import 'package:latlong2/latlong.dart' as ll;

import 'helpers/deviceid_helper.dart';
import 'helpers/hive_box/hive_settings_db.dart';
import 'main.mapper.g.dart';
import 'models/location.dart';
import 'models/realtime_update.dart';
import 'providers/wamp_providers.dart';

/// Receive events from BackgroundGeolocation in Headless state.
@pragma('vm:entry-point')
void backgroundGeolocationHeadlessTask(bg.HeadlessEvent headlessEvent) async {
  if (!kIsWeb) FLog.info(text: '📬 --> $headlessEvent');
  print('📬 --> $headlessEvent');

  switch (headlessEvent.name) {
    case bg.Event.BOOT:
      bg.State state = await bg.BackgroundGeolocation.state;
      print('📬 didDeviceReboot: ${state.didDeviceReboot}');
      break;
    case bg.Event.TERMINATE:
      bg.State state = await bg.BackgroundGeolocation.state;
      if (state.stopOnTerminate == null) return;
      if (state.stopOnTerminate!) {
        // Don't request getCurrentPosition when stopOnTerminate: true
        return;
      }
      try {
        bg.Location location =
            await bg.BackgroundGeolocation.getCurrentPosition(
                samples: 1, extras: {'event': 'terminate', 'headless': true});
        _sendLocationWhenTracking(location);
        print('[getCurrentPosition] Headless: $location');
      } catch (error) {
        print('[getCurrentPosition] Headless ERROR: $error');
      }

      break;
    case bg.Event.HEARTBEAT:
      //DISABLED getCurrentPosition on heartbeat
      try {
        bg.Location location =
            await bg.BackgroundGeolocation.getCurrentPosition(
                samples: 1, extras: {'event': 'heartbeat', 'headless': true});
        _sendLocationWhenTracking(location);

        print('[getCurrentPosition] Headless: location');
      } catch (error) {
        print('[getCurrentPosition] Headless ERROR: $error');
      }
      break;
    case bg.Event.LOCATION:
      bg.Location location = headlessEvent.event;
      _sendLocationWhenTracking(location);
      print(location);
      break;
    case bg.Event.MOTIONCHANGE:
      bg.Location location = headlessEvent.event;
      _sendLocationWhenTracking(location);
      print(location);
      break;
    case bg.Event.GEOFENCE:
      bg.GeofenceEvent geofenceEvent = headlessEvent.event;
      print(geofenceEvent);
      break;
    case bg.Event.GEOFENCESCHANGE:
      bg.GeofencesChangeEvent event = headlessEvent.event;
      print(event);
      break;
    case bg.Event.SCHEDULE:
      bg.State state = headlessEvent.event;
      print(state);
      break;
    case bg.Event.ACTIVITYCHANGE:
      bg.ActivityChangeEvent event = headlessEvent.event;
      print(event);
      break;
    case bg.Event.HTTP:
      bg.HttpEvent response = headlessEvent.event;
      print(response);
      break;
    case bg.Event.POWERSAVECHANGE:
      bool enabled = headlessEvent.event;
      print(enabled);
      break;
    case bg.Event.CONNECTIVITYCHANGE:
      bg.ConnectivityChangeEvent event = headlessEvent.event;
      print(event);
      break;
    case bg.Event.ENABLEDCHANGE:
      bool enabled = headlessEvent.event;
      print(enabled);
      break;
    case bg.Event.AUTHORIZATION:
      bg.AuthorizationEvent event = headlessEvent.event;
      print(event);
      break;
  }
}

/// Receive events from BackgroundFetch in Headless state.
@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;

  // Is this a background_fetch timeout event?  If so, simply #finish and bail-out.
  if (task.timeout) {
    print('[BackgroundFetch] HeadlessTask TIMEOUT: $taskId');
    BackgroundFetch.finish(taskId);
    return;
  }

  print('[BackgroundFetch] HeadlessTask: $taskId');

  try {
    var location = await bg.BackgroundGeolocation.getCurrentPosition(
        samples: 1, extras: {'event': 'background-fetch', 'headless': true});
    _sendLocationWhenTracking(location);
    print('[bg_location] $location');
  } catch (error) {
    print('[_bglocation] ERROR: $error');
  }

  BackgroundFetch.finish(taskId);
}

Future<bool> _sendLocationWhenTracking(location) async {
  try {
    await Hive.initFlutter();
    await Hive.openBox('settings');
    var isTracking = HiveSettingsDB.trackingActive;
    if (!isTracking) return true;
    await WampRpcHandler.instance
        .callRpc<RealtimeUpdate>(
          WampRpcHandler.getrealtimeupdate,
          Mapper.toMap(
            LocationInfo(
                coords: ll.LatLng(
                    location.coords.latitude, location.coords.longitude),
                deviceId: await DeviceId.getId,
                isParticipating: HiveSettingsDB.userIsParticipant,
                specialFunction: HiveSettingsDB.wantSeeFullOfProcession
                    ? HiveSettingsDB.specialCodeValue
                    : null,
                realSpeed: location.coords.speed),
          ),
        )
        .timeout(const Duration(seconds: 15));
    HiveSettingsDB.setOdometerValue(location.odometer);
  } catch (e) {
    print('Error sendLocation $e');
  }
  return true;
}
*/
