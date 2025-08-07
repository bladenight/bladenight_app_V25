import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:universal_io/io.dart';

import '../headleass_task.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/location_permission_dialogs.dart';
import '../helpers/logger/logger.dart';
import '../helpers/preferences_helper.dart';
import '../main.dart';
import '../models/event.dart';
import '../models/geofence_point.dart' as gfp;
import '../providers/active_event_provider.dart';
import '../providers/images_and_links/geofence_image_and_link_provider.dart';
import '../providers/location_provider.dart';
import '../providers/rest_api/onsite_state_provider.dart';

class GeofenceHelper {
  static GeofenceHelper? _instance;

  GeofenceHelper._privateConstructor();

  @pragma('vm:entry-point')
  //instance factory
  factory GeofenceHelper() {
    _instance ??= GeofenceHelper._privateConstructor();
    return _instance!;
  }

  Stream<bg.GeofenceEvent> get geoFenceEventStream =>
      _geoFenceEventStreamController.stream;

  final _geoFenceEventStreamController =
      StreamController<bg.GeofenceEvent>.broadcast();

  ///Starts or stops geofencing
  Future<void> startStopGeoFencing() async {
    if (kIsWeb || HiveSettingsDB.useAlternativeLocationProvider) return;

    if (!HiveSettingsDB.useAlternativeLocationProvider) {
      var state =
          await LocationProvider().ensureBackgroundGeolocationInitialized();
      if (state == false) {
        return;
      }
    }

    //stop geofencing if not Bladeguard
    if (!HiveSettingsDB.bgSettingVisible ||
        !HiveSettingsDB.isBladeGuard ||
        !HiveSettingsDB.geoFencingActive) {
      if (!LocationProvider().isTracking) {
        await bg.BackgroundGeolocation.stop().catchError((error) {
          BnLog.error(text: 'Stopping geofence error: $error');
          return bg.State({'err': error});
        });
      }
      return;
    }
    try {
      var gpsLocationPermissionsStatus =
          await LocationPermissionDialog().getPermissionsStatus();
      if (gpsLocationPermissionsStatus == LocationPermissionStatus.denied) {
        return;
      }
      if (!kIsWeb && !HiveSettingsDB.hasAskedAlwaysAllowLocationPermission) {
        if (gpsLocationPermissionsStatus != LocationPermissionStatus.always &&
            rootNavigatorKey.currentContext!.mounted) {
          await LocationPermissionDialog()
              .getGeofenceAlways(rootNavigatorKey.currentContext!);
          BnLog.warning(
              text:
                  'startGeoFencing not possible - LocationPermission is $gpsLocationPermissionsStatus');
        }
      }
      _setGeoFence();
    } catch (e) {
      BnLog.error(text: 'startGeoFencing failed: $e');
    }
  }

  void _setGeoFence() async {
    if (kIsWeb || HiveSettingsDB.useAlternativeLocationProvider) {
      return;
    }
    if (!HiveSettingsDB.bgSettingVisible ||
        !HiveSettingsDB.isBladeGuard ||
        !HiveSettingsDB.geoFencingActive) {
      return;
    }
    var geofenceListToSet =
        await ProviderContainer().read(geofencePointsProvider.future);
    var currentGeofencePoints =
        gfp.GeofencePoints.getGeofenceList(geofenceListToSet);

    await bg.BackgroundGeolocation.removeGeofences();
    await bg.BackgroundGeolocation.addGeofences(currentGeofencePoints)
        .then((bool success) {
      BnLog.info(text: '[addGeofence] success');
    }).catchError((dynamic error) {
      BnLog.warning(text: '[addGeofence] FAILURE: $error');
    });
    await bg.BackgroundGeolocation.stop().catchError((error) {
      BnLog.error(text: 'Stopping location for Geofence error: $error');
      return bg.State({'err': error});
    });
    await bg.BackgroundGeolocation.startGeofences().catchError((error) {
      BnLog.error(text: 'Starting Geofence error: $error');
      return bg.State({'err': error});
    });
    bg.BackgroundGeolocation.removeListener(_onGeoFenceEvent);
    // Listen to geofence events.
    bg.BackgroundGeolocation.onGeofence((bg.GeofenceEvent event) {
      _onGeoFenceEvent(event);
    });
  }

  @pragma('vm:entry-point')
  void _onGeoFenceEvent(bg.GeofenceEvent event) async {
    if (HiveSettingsDB.isBladeGuard && HiveSettingsDB.geoFencingActive) {
      BnLog.info(text: '_geofenceEvent recognized ${event.toString()}');
      if (event.action != 'DWELL') {
        return;
      }
      var lastTimeStamp = HiveSettingsDB.bladeguardLastSetOnsite;
      var now = DateTime.now();
      var diff = now.difference(lastTimeStamp);
      var minTimeDiff =
          kDebugMode ? const Duration(seconds: 5) : const Duration(hours: 1);
      if (diff < minTimeDiff || ActiveEventProvider().event.isRunning) {
        return;
      }
      if (ActiveEventProvider().event.status != EventStatus.confirmed) {
        return;
      }
      final repo = ProviderContainer().read(bladeGuardApiRepositoryProvider);
      var res = await repo.checkBladeguardIsOnSite();
      //is is already onsite do nothing
      if (res.result != null && res.result == true) {
        return;
      }
      //set onsite and notify user
      var _ = await ProviderContainer()
          .read(bgIsOnSiteProvider.notifier)
          .setOnSiteState(true, triggeredByGeofence: true);
      //invalidate provider to reload state
      _geoFenceEventStreamController.sink.add(event);
      await PreferencesHelper.setLastGeoFenceResult(
          '${DateTime.now().toIso8601String()} GeofenceEvent erkannt');
    }
  }

  Future<bool> activateGeofencing() async {
    if (Platform.isAndroid && HiveSettingsDB.geoFencingActive) {
      if (!await LocationProvider().ensureBackgroundGeolocationInitialized()) {
        return false;
      }
      // Register BackgroundGeolocation headless-task
      var locationPermissions = await Geolocator.checkPermission();
      if (locationPermissions != LocationPermission.always) {
        return false;
      }
      return await BackgroundFetch.registerHeadlessTask(
          backgroundGeolocationHeadlessTask);
    }
    return false;
  }

  void deActivateGeofencing() async {
    BackgroundFetch.stop();
    if (kDebugMode) headlessSetBladeguardOnSite();
  }
}

final geoFenceEventProvider =
    StreamProvider.autoDispose<bg.GeofenceEvent>((ref) {
  return GeofenceHelper().geoFenceEventStream.map((event) {
    return event;
  });
});
