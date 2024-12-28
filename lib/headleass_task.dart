import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/hive_box/app_server_config_db.dart';
import 'helpers/hive_box/hive_settings_db.dart';
import 'helpers/logger.dart';
import 'helpers/notification/notification_helper.dart';
import 'helpers/time_converter_helper.dart';

/// Receive events from BackgroundGeolocation in Headless state.
@pragma('vm:entry-point')
void backgroundGeolocationHeadlessTask(bg.HeadlessEvent headlessEvent) async {
  print('📬 --> $headlessEvent');

  switch (headlessEvent.name) {
    case bg.Event.GEOFENCE:
      bg.GeofenceEvent geofenceEvent = headlessEvent.event;
      if (geofenceEvent.action != 'ENTER') {
        return;
      }
      headlessSetBladeguardOnSite();
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

@pragma('vm:entry-point')
Future<bool> headlessSetBladeguardOnSite() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(HiveSettingsDB.setOnsiteGeoFencingKey)) return false;
    if (prefs.getBool(HiveSettingsDB.setOnsiteGeoFencingKey) == false) {
      return false;
    }
    var eventConfirmed = prefs.getBool('eventConfirmed');
    var lastTimeStampDate =
        prefs.getString(HiveSettingsDB.bladeguardLastSetOnsiteKey);
    var nowDate = DateTime.now().toDateOnlyString();
    if (eventConfirmed != null &&
        eventConfirmed == true &&
        lastTimeStampDate != null &&
        lastTimeStampDate == nowDate) {
      return false;
    }
    //hive not working in an isolate

    var serverLink = prefs.getString(ServerConfigDb.restApiLinkKey);
    var email = prefs.getString(HiveSettingsDB.bladeguardEmailKey);
    if (email == null) return false;
    var birthday = prefs.getString(HiveSettingsDB.bladeguardBirthdayKey);
    if (birthday == null) return false;
    var oneSignalId = prefs.getString(HiveSettingsDB.oneSignalIdKey);
    oneSignalId ??= '';
    Map<String, dynamic> qParams = {
      'onSite': true,
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
  NotificationHelper().showString(
      id: DateTime.now().hashCode, text: 'Bladeguard vor Ort angemeldet');
  return true;
}
