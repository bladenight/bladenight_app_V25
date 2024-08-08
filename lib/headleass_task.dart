import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:dio/dio.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:hive_flutter/adapters.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings/app_constants.dart';
import 'generated/l10n.dart';
import 'helpers/deviceid_helper.dart';
import 'helpers/double_helper.dart';
import 'helpers/hive_box/app_server_config_db.dart';
import 'helpers/hive_box/hive_settings_db.dart';
import 'helpers/logger.dart';
import 'helpers/notification/notification_helper.dart';
import 'models/location.dart';
import 'models/realtime_update.dart';
import 'models/result_or_error.dart';

/// Receive events from BackgroundGeolocation in Headless state.
@pragma('vm:entry-point')
void backgroundGeolocationHeadlessTask(bg.HeadlessEvent headlessEvent) async {
  BnLog.info(text: '📬 --> $headlessEvent');
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
      NotificationHelper()
          .showString(id: DateTime.now().hashCode, text: 'Geofence erkannt');
      print(geofenceEvent);
      BnLog.info(text: 'geofenceEvent');

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
        samples: 1, extras: {'event': 'background-fetch', 'geofence': true});
    //_sendLocationWhenTracking(location);
    print('[bg_location] $location');
  } catch (error) {
    print('[_bglocation] ERROR: $error');
  }

  BackgroundFetch.finish(taskId);
}

Future<bool> headlessSetBladeguardOnSite(bool onSite) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.reload();
  if (!prefs.containsKey(HiveSettingsDB.setOnsiteGeoFencingKey)) return false;
  if (prefs.getBool(HiveSettingsDB.setOnsiteGeoFencingKey) == false) {
    return false;
  }
  //hive not working in an isolate
  try {
    var serverLink = prefs.getString(ServerConfigDb.restApiLinkKey);
    var email = prefs.getString(HiveSettingsDB.bladeguardEmailKey);
    if (email == null) return false;
    var birthday = prefs.getString(HiveSettingsDB.bladeguardBirthdayKey);
    if (birthday == null) return false;
    var oneSignalId = prefs.getString(HiveSettingsDB.oneSignalIdKey);
    oneSignalId ??= '';
    Map<String, dynamic> qParams = {
      'onSite': onSite,
      'code':
          sha512.convert(utf8.encode(email.trim().toLowerCase())).toString(),
      'email': email,
      'birth': birthday,
      'oneSignalId': oneSignalId
    };

    var options = BaseOptions(
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
        headers: {'Access-Control-Allow-Origin': '*'},
        sendTimeout: const Duration(seconds: 10));
    var dioClient = Dio(options);
    var host = serverLink;
    var apiLink = '$host/setOnsite';
    var response = await dioClient.get(apiLink, queryParameters: qParams);
    if (response.statusCode == 200) {
      if (response.data == '') {
        return false;
      }
      if (response.data is Map && response.data.keys.contains('isOnSite')) {
        return false;
      } else if (response.data is Map && response.data.keys.contains('fail')) {
        return false;
      }
    } else {
      BnLog.warning(
          text: response.statusCode.toString(),
          methodName: 'setBladeguardOnSite');
    }
  } on DioException catch (e) {
    BnLog.warning(text: e.toString(), methodName: 'setBladeguardOnSite $e');
    if (e.response == null) {
      return false;
    }
    return false;
  } catch (e) {
    BnLog.warning(text: e.toString(), methodName: 'setBladeguardOnSite');
  }
  return true;
}

Future<bool> _sendLocationWhenTracking(bg.Location location) async {
  return Future.value(false);
  try {
    //hive not working wit isolate
    await Hive.openBox(hiveBoxSettingDbName);
    var isTracking = HiveSettingsDB.trackingActive;
    if (!isTracking) return true;

    await RealtimeUpdate.wampUpdate(MapperContainer.globals.toMap(
      LocationInfo(
          //location creation timestamp
          locationTimeStamp:
              DateTime.now().millisecondsSinceEpoch - location.age,
          //6 digits => 1 m location accuracy
          coords: LatLng(location.coords.latitude.toShortenedDouble(6),
              location.coords.longitude.toShortenedDouble(6)),
          deviceId: DeviceId.appId,
          isParticipating: HiveSettingsDB.userIsParticipant,
          specialFunction: HiveSettingsDB.specialCodeValue != 0
              ? HiveSettingsDB.specialCodeValue
              : null,
          userSpeed: location.coords.speed < 0
              ? 0.0
              : location.coords.speed.toShortenedDouble(1),
          realSpeed: location.coords.speed < 0
              ? 0.0
              : (location.coords.speed * 3.6).toShortenedDouble(1),
          accuracy: location.coords.accuracy),
    ));
    HiveSettingsDB.setOdometerValue(location.odometer);
  } catch (e) {
    BnLog.error(text: 'Error sendLocation $e', className: 'headless_task');
  }
  return true;
}
