import 'dart:async';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:go_router/go_router.dart';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/quickalert.dart';
import 'package:universal_io/io.dart';
import 'package:vector_math/vector_math.dart' show radians;
import 'package:wakelock_plus/wakelock_plus.dart';

import '../app_settings/app_configuration_helper.dart';
import '../app_settings/app_constants.dart';
import '../app_settings/server_connections.dart';
import '../generated/l10n.dart';
import '../helpers/average_list.dart';
import '../helpers/device_info_helper.dart';
import '../helpers/device_id_helper.dart';
import '../helpers/distance_converter.dart';
import '../helpers/double_helper.dart';
import '../helpers/enums/tracking_type.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/home_widget_helper.dart';
import '../helpers/location2_to_bglocation.dart';
import '../helpers/location_permission_dialogs.dart';
import '../helpers/logger/logger.dart';
import '../helpers/notification/notification_helper.dart';
import '../helpers/speed_to_color.dart';
import '../helpers/uuid_helper.dart';
import '../helpers/wamp/subscribe_message.dart';
import '../helpers/watch_communication_helper.dart';
import '../main.dart';
import '../models/event.dart';
import '../models/geofence_point.dart' as gfp;
import '../models/location.dart';
import '../models/realtime_update.dart';
import '../models/route.dart';
import '../models/user_speed_point.dart';
import '../models/user_gpx_point.dart';
import '../wamp/multiple_request_exception.dart';
import '../wamp/wamp_exception.dart';
import '../wamp/wamp_v2.dart';
import 'active_event_provider.dart';
import 'images_and_links/geofence_image_and_link_provider.dart';
import 'rest_api/onsite_state_provider.dart';

///[LocationProvider] gets actual procession of BladeNight
///when tracking is active is result included users position and friends
///is tracking inactive result contains only head,tail and route data
class LocationProvider with ChangeNotifier {
  static LocationProvider? _instance = LocationProvider._privateConstructor();

  LocationProvider._privateConstructor() {
    _init();
  }

  //instance factory
  factory LocationProvider() {
    _instance ??= LocationProvider._privateConstructor();
    return _instance!;
  }

  int _maxFails = 3;
  AverageList<double> realtimeSpeedAvgList = AverageList(maxLength: 5);

  bg.State? _state;
  StreamSubscription<geolocator.Position>? _locationSubscription;
  StreamSubscription<geolocator.ServiceStatus>? _geolocatorServiceStatusStream;
  bool locationRequested = false;
  bool _isInBackground = false;
  bool _wakelockDisabled = false;

  static DateTime _lastRealtimedataUpdate = DateTime(2022, 1, 1, 0, 0, 0);
  static DateTime _lastRealtimedataSendToServer = DateTime(2022, 1, 1, 0, 0, 0);
  static DateTime _lastForceStop = DateTime(2022, 1, 1, 0, 0, 0);
  static DateTime _lastSendLocationToServerRequest =
      DateTime(2022, 1, 1, 0, 0, 0);
  static DateTime _lastUITrackUpdate = DateTime(2022, 1, 1, 0, 0, 0);
  static DateTime _lastHomeWidgetUpdate = DateTime(2022, 1, 1, 0, 0, 0);

  DateTime? _userReachedFinishDateTime, _startedTrackingTime;
  Timer? _updateRealtimedataIfTrackingTimer,
      _saveLocationsTimer,
      _startTrackingCheckTimer;

  bool _autoTrackingStarted = false;
  String _lastRouteName = '';
  EventStatus? _eventState;

  EventStatus? get eventState => _eventState;

  DateTime get lastRealtimedataUpdate => _lastRealtimedataUpdate;

  bool _eventIsActive = false;

  bool get eventIsActive => _eventIsActive;

  bool _isMoving = false;

  bool get isMoving => _isMoving;

  ///Location service is active
  bool get isTracking => _trackingType != TrackingType.noTracking;

  TrackingType _trackingType = TrackingType.noTracking;

  TrackingType get trackingType => _trackingType;
  bool _hasLocationPermissions = false;

  bool get hasLocationPermissions => _hasLocationPermissions;

  bool _gpsGranted = false;

  bool get gpsGranted => _gpsGranted;

  LocationPermissionStatus _gpsLocationPermissionsStatus =
      LocationPermissionStatus.unknown;

  LocationPermissionStatus get gpsLocationPermissionsStatus =>
      _gpsLocationPermissionsStatus;

  bool _userIsParticipant = false;

  ///flag for user is participant or not
  bool get userIsParticipant => _userIsParticipant;

  bool _autoStopTracking = true;

  bool get autoStopTracking => _autoStopTracking;

  bool _autoStartTracking = false;

  bool get autoStartTracking => _autoStartTracking;

  bool _trackingWasActive = false;

  ///Tracking was active last time where app was running
  bool get trackingWasActive => _trackingWasActive;

  LatLng? _userLatLng;

  ///Users position LatLng
  LatLng? get userLatLng => _userLatLng;

  List<LatLng> _userLatLngList = <LatLng>[];

  ///Users position LatLng
  List<LatLng> get userLatLngList => _userLatLngList;

  double? _realUserSpeedKmh;

  ///User's speed in km/h
  double? get realUserSpeedKmh => _realUserSpeedKmh;

  double _odometer = 0.0;

  ///odometer in km/h
  double get odometer => _odometer;

  int _rtUpdateIntervalInMs = 15000;

  ///odometer in km/h
  int get updateIntervalInMs => _rtUpdateIntervalInMs;

  RealtimeUpdate? _realtimeUpdate;

  RealtimeUpdate? get realtimeUpdate => _realtimeUpdate;

  bg.Location? _lastKnownPoint;
  bool _isHead = false;

  bool get isHead => _isHead;

  bool _isTail = false;

  bool get isTail => _isTail;

  UserSpeedPoints _userSpeedPoints = UserSpeedPoints([]);

  UserSpeedPoints get userSpeedPoints => _userSpeedPoints;

  bool _locationIsPrecise = true;

  bool get locationIsPrecise => _locationIsPrecise;

  final _userGpxPoints = <UserGpxPoint>[];

  List<UserGpxPoint> get userGpxPoints => _userGpxPoints;

  //Stream controllers private
  final _userPositionStreamController =
      StreamController<bg.Location>.broadcast();

  final _userLatLngStreamController = StreamController<LatLng>.broadcast();

  final _geoFenceEventStreamController =
      StreamController<bg.GeofenceEvent>.broadcast();

  final _trainHeadStreamController = StreamController<LatLng>.broadcast();
  final _userTrackPointsStreamController =
      StreamController<UserGpxPoint>.broadcast();
  final _userLocationMarkerPositionStreamController =
      StreamController<LocationMarkerPosition>.broadcast();
  final _userLocationMarkerHeadingStreamController =
      StreamController<LocationMarkerHeading>.broadcast();

  //Stream controllers public
  Stream<bg.Location> get userBgLocationStream =>
      _userPositionStreamController.stream;

  Stream<LatLng> get userLatLngStream => _userLatLngStreamController.stream;

  Stream<bg.GeofenceEvent> get geoFenceEventStream =>
      _geoFenceEventStreamController.stream;

  Stream<LatLng> get trainHeadUpdateStream => _trainHeadStreamController.stream;

  Stream<UserGpxPoint> get userTrackPointsControllerStream =>
      _userTrackPointsStreamController.stream;

  Stream<LocationMarkerPosition> get userLocationMarkerPositionStream =>
      _userLocationMarkerPositionStreamController.stream;

  Stream<LocationMarkerHeading> get userLocationMarkerHeadingStream =>
      _userLocationMarkerHeadingStreamController.stream;

  StreamSubscription<bool>? _wampConnectedSubscription;

  late geolocator.LocationSettings locationSettings;

  @override
  void dispose() {
    LocationStore.saveUserTrackPointList(_userGpxPoints, DateTime.now());
    _userTrackPointsStreamController.close();
    _trainHeadStreamController.close();
    _userPositionStreamController.close();
    _userLatLngStreamController.close();
    _wampConnectedSubscription?.cancel();
    _userLocationMarkerPositionStreamController.close();
    _userLocationMarkerHeadingStreamController.close();
    _startTrackingCheckTimer?.cancel();
    _saveLocationsTimer?.cancel();
    _updateRealtimedataIfTrackingTimer?.cancel();
    super.dispose();
  }

  void _init() async {
    startRealtimeUpdateSubscriptionIfNotTracking();
    if (kIsWeb) {
      HiveSettingsDB.useAlternativeLocationProvider;
      notifyListeners();
      return;
    }

    if (!HiveSettingsDB.useAlternativeLocationProvider) {
      _state = await _startBackgroundGeolocation();
      if (_state == null) {
        BnLog.error(text: 'bg-locationState is null');
        _gpsGranted = false;
        notifyListeners();
        return;
      }
      startStopGeoFencing();
    }

    _autoStopTracking = HiveSettingsDB.autoStopTrackingEnabled;
    _autoStartTracking = HiveSettingsDB.autoStartTrackingEnabled;

    _gpsLocationPermissionsStatus =
        await LocationPermissionDialog().getPermissionsStatus();

    _hasLocationPermissions =
        _gpsLocationPermissionsStatus == LocationPermissionStatus.whenInUse ||
            _gpsLocationPermissionsStatus == LocationPermissionStatus.always;
    if (!_hasLocationPermissions) {
      _gpsGranted = false;
      notifyListeners();
      return;
    }

    _gpsGranted = true;
    _trackingWasActive = HiveSettingsDB.trackingActive;
    _userIsParticipant = HiveSettingsDB.userIsParticipant;
    _odometer = HiveSettingsDB.odometerValue;

    notifyListeners();
    _autoStartTrackingUpdateTimer();
    BnLog.verbose(
        className: 'locationProvider',
        methodName: 'init',
        text: 'init finished');
  }

  void setToBackground(bool value) {
    _isInBackground = value;
    if (value) {
      stopRealtimedataSubscription();
      if (_trackingType == TrackingType.noTracking ||
          _trackingType == TrackingType.onlyTracking) {
        WampV2().stopWamp();
      }
    } else {
      if (_trackingType == TrackingType.noTracking ||
          _trackingType == TrackingType.onlyTracking) {
        WampV2().startWamp();
      }
      if (_trackingType == TrackingType.noTracking) {
        _reStartRealtimeUpdateTimer();
      }
    }
  }

  ///Initializes BackgroundLocationPlugin
  Future<bg.State?> _startBackgroundGeolocation() async {
    try {
      bg.BackgroundGeolocation.onLocation(_onLocation, _onLocationError);
      bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
      bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
      bg.BackgroundGeolocation.onHeartbeat(_onHeartBeat);
      bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
      bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);
      bg.BackgroundGeolocation.onGeofence(_onGeoFence);

      var isMotionDetectionDisabled = HiveSettingsDB.isMotionDetectionDisabled;

      if (Platform.isAndroid) {
        return bg.BackgroundGeolocation.ready(bg.Config(
          locationAuthorizationRequest: 'Any',
          fastestLocationUpdateInterval: 1000,
          reset: true,
          debug: false,
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
          allowIdenticalLocations: false,
          distanceFilter: 2,
          heartbeatInterval: 60,
          disableMotionActivityUpdates: isMotionDetectionDisabled,
          logMaxDays: 0,
          persistMode: bg.Config.PERSIST_MODE_NONE,
          stopAfterElapsedMinutes: 3600,
          preventSuspend: true,
          stopOnTerminate: true,
          startOnBoot: false,
          logLevel: bg.Config.LOG_LEVEL_OFF,
          // bgLogLevel,
          //bg.Config.LOG_LEVEL_VERBOSE,//
          //locationUpdateInterval: 1000, not used - distance filter must be 0
          stopTimeout: 3,
          //20 minutes
          // <-- a very long stopTimeout
          //disableStopDetection: true,
          // <-- Don't interrupt location updates when Motion API says "still"

          backgroundPermissionRationale: bg.PermissionRationale(
              title: Localize.current.requestAlwaysPermissionTitle,
              message: Localize.current.noBackgroundlocationLeaveAppOpen,
              positiveAction: Localize.current.openOperatingSystemSettings,
              negativeAction: Localize.current.cancel),
        )).then((bg.State state) {
          _isMoving = state.isMoving ?? false;
          notifyListeners();
          return state;
        });
      }
      if (Platform.isIOS) {
        return bg.BackgroundGeolocation.ready(bg.Config(
          locationAuthorizationRequest: 'Any',
          reset: true,
          debug: false,
          fastestLocationUpdateInterval: 1000,
          //ALL
          logLevel: bg.Config.LOG_LEVEL_OFF,
          //logLevel: bgLogLevel,
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
          distanceFilter: 2,
          disableMotionActivityUpdates: isMotionDetectionDisabled,
          logMaxDays: 0,
          heartbeatInterval: 60,
          stopDetectionDelay: 1,
          persistMode: bg.Config.PERSIST_MODE_NONE,
          // Activity Recognition
          activityRecognitionInterval: 3000,
          allowIdenticalLocations: false,
          showsBackgroundLocationIndicator: true,
          preventSuspend: true,
          //locationUpdateInterval: 1000, not used - distance filter must be 0
          stopTimeout: 3,
          // <-- a very long stopTimeout
          //disableStopDetection: false,
          // <-- Don't interrupt location updates when Motion API says "still"

          //request Always permissions
          backgroundPermissionRationale: bg.PermissionRationale(
              title: Localize.current.requestAlwaysPermissionTitle,
              message: Localize.current.noBackgroundlocationLeaveAppOpen,
              positiveAction: Localize.current.openOperatingSystemSettings,
              negativeAction: Localize.current.cancel),
          //iOS only
          locationAuthorizationAlert: {
            'titleWhenNotEnabled':
                Localize.current.noLocationPermissionGrantedAlertTitle,
            'titleWhenOff': Localize.current.locationServiceOff,
            'instructions': Localize.current.enableAlwaysLocationInfotext,
            'cancelButton': Localize.current.cancel,
            'settingsButton': Localize.current.setOpenSystemSettings
          },
          notification: bg.Notification(
              title: Localize.current.bgNotificationTitle,
              text: Localize.current.bgNotificationText,
              smallIcon: 'drawable/ic_bg_service_small'),
        )).then((bg.State state) {
          _isMoving = state.isMoving ?? false;
          notifyListeners();
          return state;
        });
      }
    } catch (error) {
      BnLog.error(text: '_startBackgroundGeolocation', exception: error);
    }

    BnLog.warning(
        text: 'No valid device for bg.BackgroundGeolocation',
        className: toString(),
        methodName: '_startBackgroundGeolocation');

    return null;
  }

  void _onLocation(bg.Location location) {
    BnLog.verbose(
        text:
            '_onLocation ${location.coords} battery: ${location.battery.level}%');
    updateUserLocation(location);
    if (location.battery.level != -1) {
      checkWakeLock(location.battery.level, location.battery.isCharging);
    }
  }

  ///Update user location and track points list
  void updateUserLocation(bg.Location location) {
    if (!isTracking) return;
    _isMoving = true;
    HomeWidgetHelper.updateRealtimeData(location);

    _userPositionStreamController.add(location);
    _userLatLngStreamController
        .add(LatLng(location.coords.latitude, location.coords.longitude));
    _userLocationMarkerPositionStreamController.sink.add(LocationMarkerPosition(
        latitude: location.coords.latitude,
        longitude: location.coords.longitude,
        accuracy: location.coords.accuracy));
    _userLocationMarkerHeadingStreamController.sink.add(LocationMarkerHeading(
        heading: radians(location.coords.heading),
        accuracy: location.coords.accuracy));
    _userLatLng = LatLng(location.coords.latitude, location.coords.longitude);

    realtimeSpeedAvgList
        .add(location.coords.speed <= 0 ? 0.0 : location.coords.speed * 3.6);
    _realUserSpeedKmh = realtimeSpeedAvgList.getAverage();

    _realUserSpeedKmh = _realUserSpeedKmh!.toShortenedDouble(2);
    _odometer = location.odometer / 1000;

    var diff = DateTime.now().difference(_lastHomeWidgetUpdate);
    if (diff < const Duration(milliseconds: 60000)) {
      //notifyListeners();
      //return;
    }

    if (_lastKnownPoint != null) {
      var headingDiff =
          (_lastKnownPoint!.coords.heading - location.coords.heading).abs();

      if (headingDiff < 2) {
        //update last track point
        userLatLngList.removeLast();
        _userLatLngList
            .add(LatLng(location.coords.latitude, location.coords.longitude));
        notifyListeners();
        return;
      }
    }
    _lastKnownPoint = location;
    _lastUITrackUpdate = DateTime.now();
    //update ui tracked lines only every 4 secs
    // if (MapSettings.showOwnTrack && !MapSettings.showOwnColoredTrack) {
    _userLatLngList
        .add(LatLng(location.coords.latitude, location.coords.longitude));
    // }
    if (MapSettings.showOwnTrack) {
      var userTrackingPoint = UserGpxPoint(
          location.coords.latitude,
          location.coords.longitude,
          _realUserSpeedKmh!,
          location.coords.heading,
          location.coords.altitude,
          odometer,
          DateTime.now());
      if (_userGpxPoints.isNotEmpty) {
        var userLastPoint = _userGpxPoints.last;
        var lon = location.coords.longitude;
        var lat = location.coords.latitude;
        if (userLastPoint.latitude != lat && userLastPoint.longitude != lon) {
          _userGpxPoints.add(userTrackingPoint);
        }
      } else {
        _userGpxPoints.add(userTrackingPoint);
      }
    }

    SendToWatch.setUserSpeed('${_realUserSpeedKmh!.toStringAsFixed(1)} km/h');

    //Create poly lines for user tracking
    int maxSize = 300;
    if (MapSettings.showOwnTrack && !MapSettings.showOwnColoredTrack) {
      if (_userGpxPoints.length > maxSize) {
        var smallTrackPointList = <LatLng>[];
        var divider = _userGpxPoints.length ~/ maxSize;

        for (var counter = 0; counter < _userGpxPoints.length - divider;) {
          smallTrackPointList.add(LatLng(_userGpxPoints[counter].latitude,
              _userGpxPoints[counter].longitude));
          counter = counter + divider.toInt();
        }
        //avoid jumping of tracking if list is large
        //var lastUserGpxPoints = _userGpxPoints.last;
        var last5 = _userGpxPoints.reversed.take(5).toList();
        for (var i = last5.length - 1; i < 0; i--) {
          smallTrackPointList
              .add(LatLng(last5[i].latitude, last5[i].longitude));
        }
        _userLatLngList = smallTrackPointList;
        last5.clear();
      } else {
        _userLatLngList
            .add(LatLng(location.coords.latitude, location.coords.longitude));
      }
    } else if (MapSettings.showOwnTrack && MapSettings.showOwnColoredTrack) {
      if (_userSpeedPoints.latLngList.isEmpty) {
        //first point
        UserSpeedPoint userSpeedPoint = UserSpeedPoint(
          location.coords.latitude,
          location.coords.longitude,
          _realUserSpeedKmh!,
          LatLng(location.coords.latitude, location.coords.longitude),
        );
        _userSpeedPoints.addUserSpeedPoint(userSpeedPoint);
      } else if (_userGpxPoints.length > maxSize) {
        //decrease numbers of poly lines
        var smallTrackPointList = UserSpeedPoints([]);
        var divider = _userGpxPoints.length ~/ maxSize;
        LatLng? lastLatLng;
        for (var counter = 0; counter < _userGpxPoints.length - divider;) {
          if (counter == 0) {
            //no followed polylinePoint first line has same endpoint
            smallTrackPointList.add(
                _userGpxPoints[counter].latitude,
                _userGpxPoints[counter].longitude,
                _userGpxPoints[counter].realSpeedKmh,
                _userGpxPoints[counter].latLng);
            lastLatLng = _userGpxPoints[counter].latLng;
          } else {
            smallTrackPointList.add(
                _userGpxPoints[counter].latitude,
                _userGpxPoints[counter].longitude,
                _userGpxPoints[counter].realSpeedKmh,
                lastLatLng!);
            lastLatLng = _userGpxPoints[counter].latLng;
          }
          counter = counter + divider.toInt();
        }
        //avoid jumping of tracking if list is large
        //changed to add only last single point to list
        var last5 = _userGpxPoints.reversed.take(6).toList();
        for (var i = last5.length - 2; i < 0; i--) {
          smallTrackPointList.add(last5[i].latitude, last5[i].longitude,
              last5[i].realSpeedKmh, last5[i + 1].latLng);
        }
        _userSpeedPoints = smallTrackPointList;
        last5.clear();
      } else {
        UserSpeedPoint userSpeedPoint = UserSpeedPoint(
          location.coords.latitude,
          location.coords.longitude,
          _realUserSpeedKmh!,
          _userSpeedPoints.lastSpeedPointLatLng,
        );
        _userSpeedPoints.addUserSpeedPoint(userSpeedPoint);
      }
    }

    if (!_isInBackground) {
      notifyListeners();
    }
  }

  void _onLocationError(bg.LocationError error) {
    if (!kIsWeb) BnLog.verbose(text: 'Location error reason: $error');
    if (_lastKnownPoint != null) {
      //sendLocation(_lastKnownPoint!);
    }
  }

  void _onMotionChange(bg.Location location) {
    BnLog.verbose(
        text: '_onMotionChange ${location.coords} ${location.battery.level}% ');
    _isMoving = location.isMoving;
    if (!_isInBackground) {
      notifyListeners();
    }
    //sendLocation(location); //dont send!!
  }

  void _onActivityChange(bg.ActivityChangeEvent event) {
    BnLog.verbose(text: '_onActivityChangeEvent ${event.activity}');
    //_subToUpdates();
  }

  void _onHeartBeat(bg.HeartbeatEvent event) {
    BnLog.verbose(text: '_onHeartbeatEvent  ${event.location}');
    _getHeartBeatLocation();
  }

  _onConnectivityChange(bg.ConnectivityChangeEvent event) {
    BnLog.verbose(text: '_onConnectivityChange  $event');
    //_networkConnected = event.connected;
  }

  void _getHeartBeatLocation() async {
    if (!isTracking) return;
    BnLog.verbose(text: '_getHeartBeatLocation');
    try {
      await bg.BackgroundGeolocation.getCurrentPosition(
        timeout: 2,
        maximumAge: 60000,
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        samples: 2, // How many location samples to attempt.
      );
      //triggers update
    } catch (e) {
      BnLog.warning(
          className: toString(),
          methodName: '_subToUpdates',
          text: '_subUpdates Failed: ${e.toString()}');
    }
  }

  _onProviderChange(bg.ProviderChangeEvent event) {
    BnLog.info(text: '_onProviderChangeEvent  ${event.toString()}');
    switch (event.status) {
      case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_NOT_DETERMINED:
        _gpsLocationPermissionsStatus = LocationPermissionStatus.notDetermined;
        break;
      case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_RESTRICTED:
        _gpsLocationPermissionsStatus = LocationPermissionStatus.restricted;
        break;
      case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_DENIED:
        _gpsLocationPermissionsStatus = LocationPermissionStatus.denied;
        stopTracking();
        break;
      case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS:
        _gpsLocationPermissionsStatus = LocationPermissionStatus.always;
        break;
      case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE:
        _gpsLocationPermissionsStatus = LocationPermissionStatus.whenInUse;
        bg.BackgroundGeolocation.ready(
            bg.Config(disableLocationAuthorizationAlert: true));
        break;
    }
    notifyListeners();
  }

  _onGeoFence(bg.GeofenceEvent event) {
    _onGeoFenceEvent(event);
  }

  void _onGeoFenceEvent(bg.GeofenceEvent event) async {
    if (HiveSettingsDB.isBladeGuard && HiveSettingsDB.onsiteGeoFencingActive) {
      BnLog.info(text: '_geofenceEvent recognized ${event.toString()}');
      if (event.action != 'ENTER') {
        return;
      }
      var lastTimeStamp = HiveSettingsDB.bladeguardLastSetOnsite;
      var now = DateTime.now();
      var diff = now.difference(lastTimeStamp);
      var minTimeDiff =
          kDebugMode ? const Duration(seconds: 5) : const Duration(hours: 1);
      if (diff < minTimeDiff || eventIsActive) {
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
    }
  }

  void toggleAutoStop() async {
    _autoStopTracking = !_autoStopTracking;
    notifyListeners();
    HiveSettingsDB.setAutoStopTrackingEnabled(_autoStopTracking);
  }

  Future<bool> stopTracking() async {
    setRealtimedataUpdateTimerIfTracking(false);
    if (HiveSettingsDB.useAlternativeLocationProvider) {
      _trackingStopped();
      await startRealtimeUpdateSubscriptionIfNotTracking();
    } else {
      bg.BackgroundGeolocation.stop().then((bg.State state) async {
        _trackingStopped();
        await startStopGeoFencing();
        await WakelockPlus.disable();
        await startRealtimeUpdateSubscriptionIfNotTracking();
      }).catchError((error) {
        BnLog.error(text: 'Stopping location error: $error');
      });
    }

    return isTracking;
  }

  void _trackingStopped() {
    BnLog.info(
        text: 'location tracking stopped',
        className: 'location_provider',
        methodName: '_stopTracking');
    _locationSubscription?.cancel();
    _geolocatorServiceStatusStream?.cancel();
    _locationSubscription = null;
    _lastKnownPoint = null;
    _realUserSpeedKmh = null;
    _userLatLng = null;
    _trackingType = TrackingType.noTracking;
    //reset autostart
    //avoid second autostart on an event , reset after end
    var activeEventData = ProviderContainer().read(activeEventProvider);
    if (_startedTrackingTime != null &&
        DateTime.now().difference(_startedTrackingTime!).inMinutes >
            activeEventData.duration.inMinutes) {
      _startedTrackingTime = null;
    }
    SendToWatch.setIsLocationTracking(false);
    HiveSettingsDB.setTrackingActive(false);
    LocationStore.saveUserTrackPointList(_userGpxPoints, DateTime.now());
    notifyListeners();
  }

  ///Starts or stops geofencing
  Future<void> startStopGeoFencing() async {
    //stop geofencing if not Bladeguard
    if (!HiveSettingsDB.bgSettingVisible ||
        !HiveSettingsDB.isBladeGuard ||
        !HiveSettingsDB.onsiteGeoFencingActive) {
      if (!isTracking) {
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
      if (gpsLocationPermissionsStatus != LocationPermissionStatus.always) {
        BnLog.warning(
            text:
                'startGeoFencing not possible - LocationPermission is $gpsLocationPermissionsStatus');
      }
      setGeoFence();
      bg.BackgroundGeolocation.startGeofences().catchError((error) {
        BnLog.error(text: 'start Geofence error: $error');
        return bg.State({'err': error});
      });
    } catch (e) {
      BnLog.error(text: 'startGeoFencing failed: $e');
    }
  }

  void setGeoFence() async {
    if (!HiveSettingsDB.bgSettingVisible ||
        !HiveSettingsDB.isBladeGuard ||
        !HiveSettingsDB.onsiteGeoFencingActive) {
      return;
    }
    var points = await ProviderContainer().read(geofencePointsProvider.future);
    var geofencePoints = gfp.GeofencePoints.getGeofenceList(points);
    bg.BackgroundGeolocation.addGeofences(geofencePoints).then((bool success) {
      BnLog.info(text: '[addGeofence] success');
    }).catchError((dynamic error) {
      BnLog.warning(text: '[addGeofence] FAILURE: $error');
    });
  }

  /// Starts location tracking with set values
  ///
  /// Returns false if no location-permissions given or fails
  Future<bool> startTracking(TrackingType trackingType) async {
    var context = rootNavigatorKey.currentContext!;
    //if (kIsWeb) return false;
    _trackingType = trackingType;
    _userIsParticipant = trackingType == TrackingType.userParticipating;
    _isHead = HiveSettingsDB.specialCodeValue == 1 ||
        HiveSettingsDB.specialCodeValue == 5;
    _isTail = HiveSettingsDB.specialCodeValue == 2 ||
        HiveSettingsDB.specialCodeValue == 6;

    var permissionWithService = Permission.location;
    var locationPermission = await permissionWithService.status;
    if (HiveSettingsDB.hasShownProminentDisclosure == false ||
        locationPermission.isPermanentlyDenied ||
        locationPermission.isDenied) {
      var acceptLocation =
          await LocationPermissionDialog().showProminentAndroidDisclosure();

      if (!acceptLocation) {
        BnLog.warning(
            text: 'No positive prominent disclosure or always denied');
        return false;
      }
      if (Platform.isAndroid &&
          await DeviceHelper.isAndroidGreaterVNine() &&
          context.mounted) {
        await LocationPermissionDialog()
            .showMotionSensorProminentDisclosure(context);
      }
      HiveSettingsDB.setHasShownProminentDisclosure(true);
    }

    if (locationPermission == PermissionStatus.permanentlyDenied) {
      Fluttertoast.showToast(
          msg: Localize.current.noLocationPermitted,
          backgroundColor: Colors.orange);

      BnLog.warning(
          text: 'location permanentlyDenied by os',
          className: 'location_provider',
          methodName: '_startTracking');
      if (context.mounted) {
        return LocationPermissionDialog().requestAndOpenAppSettings(context);
      }
      return false;
    }

    //Check precise Location once
    _locationIsPrecise =
        await LocationPermissionDialog().requestPreciseLocation() ==
            geolocator.LocationAccuracyStatus.precise;

    if (HiveSettingsDB.trackingFirstStart &&
        HiveSettingsDB.autoStartTrackingEnabled &&
        context.mounted) {
      await QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          showCancelBtn: true,
          confirmBtnColor: Colors.orange,
          title: Localize.current.autoStartTrackingInfo,
          text: Localize.current.autoStartTrackingInfoTitle,
          onConfirmBtnTap: () {
            HiveSettingsDB.setAutoStartTrackingEnabled(true);
            rootNavigatorKey.currentState?.pop();
          },
          onCancelBtnTap: () {
            HiveSettingsDB.setAutoStartTrackingEnabled(false);
            rootNavigatorKey.currentState?.pop();
          },
          confirmBtnText: 'Auto-Start',
          cancelBtnText: Localize.current.no);
      HiveSettingsDB.setTrackingFirstStart(false);
    }

    _userReachedFinishDateTime == null;
    if (_userGpxPoints.length <= 1 &&
        MapSettings.showOwnTrack &&
        LocationStore.dataTodayAvailable) {
      //reload data
      _userGpxPoints.clear();
      _userGpxPoints.addAll(LocationStore.userTrackPointsList);
      _userSpeedPoints.clear();
      for (int i = 0; i < _userGpxPoints.length - 1; i++) {
        if (i == 0) {
          _userSpeedPoints.add(
            _userGpxPoints[0].latitude,
            _userGpxPoints[0].longitude,
            _userGpxPoints[0].realSpeedKmh,
            _userGpxPoints[0].latLng,
          );
        } else {
          _userSpeedPoints.add(
            _userGpxPoints[i].latitude,
            _userGpxPoints[i].longitude,
            _userGpxPoints[i].realSpeedKmh,
            _userGpxPoints[i - 1].latLng,
          );
        }
      }
    }

    if (!kIsWeb && HiveSettingsDB.wakeLockEnabled) {
      await WakelockPlus.enable();
    }

    if (kIsWeb || HiveSettingsDB.useAlternativeLocationProvider) {
      BnLog.info(
          text: 'alternative location tracking started',
          className: 'location_provider',
          methodName: '_startTracking');
      if (kIsWeb) {
        HiveSettingsDB.setUseAlternativeLocationProvider(true);
        var permissionWithService = Permission.location;
        var locationPermission = await permissionWithService.request();

        if (locationPermission == PermissionStatus.granted ||
            locationPermission == PermissionStatus.limited) {
          _gpsLocationPermissionsStatus = LocationPermissionStatus.always;
          _hasLocationPermissions = true;
        } else {
          _gpsLocationPermissionsStatus = LocationPermissionStatus.denied;
          _hasLocationPermissions = false;
        }
      } else {
        _gpsLocationPermissionsStatus =
            await LocationPermissionDialog().getPermissionsStatus();

        _hasLocationPermissions = _gpsLocationPermissionsStatus ==
                LocationPermissionStatus.whenInUse ||
            _gpsLocationPermissionsStatus == LocationPermissionStatus.always;
        if (HiveSettingsDB.useAlternativeLocationProvider &&
            _hasLocationPermissions) {
          _gpsLocationPermissionsStatus =
              _gpsLocationPermissionsStatus == LocationPermissionStatus.always
                  ? LocationPermissionStatus.always
                  : LocationPermissionStatus.whenInUse;
        }
        if (_gpsLocationPermissionsStatus ==
            LocationPermissionStatus.whenInUse) {
          await LocationPermissionDialog().requestAlwaysLocationPermissions();
        }
      }
      _listenLocationWithAlternativePackage();
      _trackingType = trackingType;
      stopRealtimedataSubscription();
      setRealtimedataUpdateTimerIfTracking(true);
      _startedTrackingTime = DateTime.now();
      ProviderContainer()
          .read(activeEventProvider.notifier)
          .refresh(forceUpdate: true);
      notifyListeners();
      var loc = await _updateLocation();
      if (loc != null) {
        _getRealtimeDataWithLocation(loc);
      }
      SendToWatch.setIsLocationTracking(isTracking);
      HiveSettingsDB.setTrackingActive(isTracking);
    }
    //####################################################
    //# use Transistorsoft geolocator for Android and iOS
    //####################################################
    else {
      _geolocatorServiceStatusStream?.cancel();
      await bg.BackgroundGeolocation.start()
          .then((bg.State bgGeoLocState) async {
        BnLog.info(
            text: 'location tracking started',
            className: 'location_provider',
            methodName: '_startTracking');
        _startedTrackingTime = DateTime.now();
        _trackingType =
            bgGeoLocState.enabled ? trackingType : TrackingType.noTracking;
        stopRealtimedataSubscription();
        setRealtimedataUpdateTimerIfTracking(true);
        ProviderContainer()
            .read(activeEventProvider.notifier)
            .refresh(forceUpdate: true);
        notifyListeners();
        var loc = await _updateLocation();
        if (loc != null) {
          _getRealtimeDataWithLocation(loc);
        }
        HiveSettingsDB.setTrackingActive(isTracking);
        SendToWatch.setIsLocationTracking(isTracking);
      }).catchError((error) {
        BnLog.error(text: 'LocStarting ERROR: $error');
        HiveSettingsDB.setTrackingActive(false);
        trackingType = TrackingType.noTracking;
        setRealtimedataUpdateTimerIfTracking(false);
        startRealtimeUpdateSubscriptionIfNotTracking();
        SendToWatch.setIsLocationTracking(false);
        notifyListeners();
        //re-update on error

        return null;
      });
      await bg.BackgroundGeolocation.setConfig(bg.Config(
          distanceFilter: 0,
          locationUpdateInterval: 1000,
          stopTimeout: 1000, // <-- a very long stopTimeout
          disableStopDetection:
              true // <-- Don't interrupt location updates when Motion API says "still"
          ));
      await bg.BackgroundGeolocation.changePace(true);
    }
    return isTracking;
  }

  Future<bool> saveLocationToDB() async {
    return await LocationStore.saveUserTrackPointList(
        _userGpxPoints, DateTime.now());
  }

  ///set [enabled] = true  or reset [enabled] = false location updates if tracking is enabled
  void startSaveLocationsUpdateTimer(bool enabled) {
    BnLog.verbose(text: 'init startSaveLocationsUpdateTimer to $enabled');
    _saveLocationsTimer?.cancel();
    if (enabled) {
      _saveLocationsTimer = Timer.periodic(
        const Duration(minutes: 5),
        (timer) async {
          if (!isTracking) {
            return;
          }
          await saveLocationToDB();
        },
      );
    } else {
      _saveLocationsTimer = null;
    }
  }

  ///Send [RealtimeData] included [location] to server
  Future<void> _getRealtimeDataWithLocation(bg.Location location) async {
    if (!isTracking || _trackingType == TrackingType.onlyTracking) return;
    //only result of this message contains friend position -
    //requested [RealTimeUpdates] with
    RealtimeUpdate? update =
        await RealtimeUpdate.realtimeDataUpdate(MapperContainer.globals.toMap(
      LocationInfo(
          //location creation timestamp
          locationTimeStamp:
              DateTime.now().millisecondsSinceEpoch - location.age,
          //6 digits => 1 m location accuracy
          coords: LatLng(location.coords.latitude.toShortenedDouble(6),
              location.coords.longitude.toShortenedDouble(6)),
          deviceId: DeviceId.appId,
          isParticipating: _userIsParticipant,
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
    if (update.rpcException != null) {
      return;
    }
    _lastRealtimedataSendToServer = DateTime.now();
    HiveSettingsDB.setOdometerValue(odometer);
    //rt update by stream
    var friendList = update.updateMapPointFriends(update.friends);
    var friends = friendList.where((x) => x.specialValue == 0).toList();
    SendToWatch.updateFriends(MapperContainer.globals.toJson(friends));
    _updateWatchData();
    checkUserFinishedOrEndEvent();
    _setRealtimeUpdate(update, notify: !_isInBackground);
  }

  ///Get Location updates if tracking is enabled
  ///[enabled] = true
  ///[enabled] = false stop timer
  void setRealtimedataUpdateTimerIfTracking(bool enabled) {
    BnLog.verbose(text: 'init setLocationTimer to $enabled');
    _updateRealtimedataIfTrackingTimer?.cancel();
    _saveLocationsTimer?.cancel();
    if (enabled) {
      startSaveLocationsUpdateTimer(true);
      _rtUpdateIntervalInMs = defaultLocationUpdateInterval;
      _updateRealtimedataIfTrackingTimer = Timer.periodic(
        //realtimeUpdateProvider reads data on send-location -
        //so it must not updated all 10 secs
        const Duration(milliseconds: defaultLocationUpdateInterval),
        (timer) {
          refreshRealtimeData(forceUpdate: _realtimeUpdate == null);
        },
      );
    } else {
      _updateRealtimedataIfTrackingTimer = null;
      _saveLocationsTimer = null;
    }
  }

  ///Start timer to autostart tracking on event start every minute
  void _autoStartTrackingUpdateTimer() {
    BnLog.verbose(text: 'init startTrackingUpdateTimer');
    _startTrackingCheckTimer?.cancel();
    _startTrackingCheckTimer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) async {
        await _autoStartTimerCallBack();
      },
    );
    _autoStartTimerCallBack();
  }

  ///Autostart tracking
  Future<void> _autoStartTimerCallBack() async {
    if (isTracking ||
        !HiveSettingsDB.autoStartTrackingEnabled ||
        _autoTrackingStarted) {
      return;
    }
    await ProviderContainer()
        .read(activeEventProvider.notifier)
        .refresh(forceUpdate: true);
    _eventIsActive = ProviderContainer().read(activeEventProvider).status ==
            EventStatus.running ||
        (_realtimeUpdate != null && _realtimeUpdate!.eventIsActive);
    if (_eventIsActive) {
      startTracking(TrackingType.userParticipating);
      _autoTrackingStarted = true;
      BnLog.verbose(
          text: '_autoStartTimerCallBack autostart tracking via timer');
      if (_isInBackground) {
        NotificationHelper().showString(
            id: DateTime.now().hashCode,
            text: Localize.current.autoStartTracking);
      } else {
        QuickAlert.show(
            context: rootNavigatorKey.currentContext!,
            type: QuickAlertType.info,
            title: Localize.current.autoStartTrackingTitle,
            text: Localize.current.autoStartTracking);
      }
    }
    if (!_eventIsActive) {
      _autoTrackingStarted = false; //reset auto tracking start
    }
  }

  Future<void> _listenLocationWithAlternativePackage() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = geolocator.AndroidSettings(
          accuracy: geolocator.LocationAccuracy.high,
          distanceFilter: 10,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 5),
          timeLimit: Duration(seconds: 2),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: geolocator.ForegroundNotificationConfig(
            notificationText: Localize.current.bgNotificationText,
            notificationTitle: Localize.current.bgNotificationTitle,
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = geolocator.AppleSettings(
          accuracy: geolocator.LocationAccuracy.high,
          activityType: geolocator.ActivityType.fitness,
          distanceFilter: 10,
          pauseLocationUpdatesAutomatically: true,
          // Only set to true if our app will be started up in the background.
          showBackgroundLocationIndicator: true,
          timeLimit: Duration(seconds: 2));
    } else if (kIsWeb) {
      locationSettings = geolocator.WebSettings(
          accuracy: geolocator.LocationAccuracy.high,
          distanceFilter: 20,
          maximumAge: Duration(minutes: 1),
          timeLimit: Duration(seconds: 2));
    } else {
      locationSettings = geolocator.LocationSettings(
          accuracy: geolocator.LocationAccuracy.high,
          distanceFilter: 20,
          timeLimit: Duration(seconds: 2));
    }

    _locationSubscription = geolocator.Geolocator.getPositionStream(
            locationSettings: locationSettings)
        .listen((geolocator.Position? position) async {
      if (position == null) return;
      var newLoc = position.convertToBGLocation();
      _onLocation(newLoc);
    });

    _geolocatorServiceStatusStream =
        geolocator.Geolocator.getServiceStatusStream()
            .listen((geolocator.ServiceStatus status) {
      _onProviderChange(status.convertToBgProviderChangeEvent());
    });
  }

  Future<bg.Location?> getLocation() async {
    try {
      var loc = await bg.BackgroundGeolocation.getCurrentPosition(
        timeout: 2,
        maximumAge: 5000,
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_MEDIUM,
        samples: 3, // How many location samples to attempt.
      );
      _lastKnownPoint = loc;
      return loc;
    } catch (e) {
      BnLog.error(text: 'getLocation - could not determine current location');
    }
    return _lastKnownPoint;
  }

  void checkWakeLock(double batteryLevel, bool isCharging) async {
    if (_isInBackground) return;
    BnLog.verbose(text: 'checkWakelock');
    if (HiveSettingsDB.wakeLockEnabled &&
        _wakelockDisabled == false &&
        !isCharging &&
        batteryLevel != -1 &&
        batteryLevel < 0.2) {
      BnLog.verbose(text: 'checkWakelock disable Wakelock');
      //await WakelockPlus.disable();
      _wakelockDisabled = true;
      NotificationHelper().showString(
          id: DateTime.now().hashCode,
          text: Localize.current.wakelockWarnBattery(batteryLevel * 100));
      //showToast(message: Localize.current.wakelockEnabled);
    }
    if (HiveSettingsDB.wakeLockEnabled &&
        _wakelockDisabled == true &&
        (batteryLevel > 0.2 || isCharging)) {
      //await WakelockPlus.enable();
      _wakelockDisabled = false;
      //showToast(message: Localize.current.wakelockEnabled);
    }
  }

  ///Refresh [RealTimeData] every 5s if tracking or every 15 sec if not subscribed
  ///
  ///[forceUpdate]-Mode to update after resume  default value = false
  ///necessary after app state switching in viewer mode
  Future<void> refreshRealtimeData({bool forceUpdate = false}) async {
    if (_trackingType == TrackingType.onlyTracking) {
      return;
    }
    var dtNow = DateTime.now();

    var timeDiff = dtNow.difference(_lastSendLocationToServerRequest);
    if ((_trackingType == TrackingType.userNotParticipating ||
            _trackingType == TrackingType.userParticipating) &&
        timeDiff <
            const Duration(milliseconds: defaultLocationUpdateInterval - 100) &&
        !forceUpdate) {
      //print('${DateTime.now().toIso8601String()} lower $defaultLocationUpdateInterval ms rt update');

      //avoid to much traffic
      return;
    }

    var timeDiff2 = dtNow.difference(_lastRealtimedataUpdate);
    if (timeDiff2 <
            const Duration(milliseconds: defaultRealtimeUpdateInterval - 100) &&
        _trackingType == TrackingType.noTracking &&
        !forceUpdate) {
      //print('${DateTime.now().toIso8601String()} lower $defaultRealtimeUpdateInterval ms rt update');
      return;
    }
    if (!WampV2().webSocketIsConnected &&
        timeDiff < const Duration(seconds: 60)) {
      BnLog.verbose(
          text:
              '${timeDiff.inSeconds} s not online. Last update : $lastRealtimedataUpdate',
          methodName: 'refreshRealtimeData',
          className: toString());
      _realtimeUpdate = _realtimeUpdate?.copyWith(
          rpcException: WampException('Not online more than 60 s.'));
      // notifyListeners();
    } else if (!WampV2().webSocketIsConnected) {
      BnLog.verbose(
          text:
              '${timeDiff.inSeconds}s not connected. Last refresh: $lastRealtimedataUpdate',
          methodName: 'noTrackingRealtimedataRefresh',
          className: toString());
    }
    bg.Location? locData;

    if (_trackingType == TrackingType.userNotParticipating ||
        _trackingType == TrackingType.userParticipating) {
      locData = await _updateLocation();
    } else {
      _realUserSpeedKmh = null;
    }
    if (locData != null) {
      _lastSendLocationToServerRequest = dtNow;
      _getRealtimeDataWithLocation(locData);
    } else {
      var id = UUID.createShortUuid();
      if (kDebugMode) {
        print(
            '${DateTime.now().toIso8601String()} lprov_1219_getrealtimedata $id');
      }
      await _getRealtimeData();
      if (kDebugMode) {
        print(
            '${DateTime.now().toIso8601String()} lprov_1219_getrealtimedata fin $id');
      }
    }
  }

  ///Get current [Location] if older 5sec. and send to server
  /// will not send new location to server if [sendLoc] == false
  /// or last send not 5sec ago
  /// refreshes [_lastKnownPoint] on bg.Location
  /// returns [Location] for [_lastKnownPoint]  or null
  Future<bg.Location?> _updateLocation() async {
    if (_lastKnownPoint != null) {
      var ts = DateTime.parse(_lastKnownPoint!.timestamp);
      var diff = DateTime.now().toUtc().difference(ts.toUtc());
      //set lastKnownPoint to null after x sec
      if (diff > const Duration(seconds: 30)) {
        _lastKnownPoint = await getCurrentLocation();
      }
    } else {
      _lastKnownPoint ??= await getCurrentLocation();
    }
    return _lastKnownPoint;
  }

  Future<void> _getRealtimeData() async {
    try {
      //update procession when no location data were sent
      var update = await RealtimeUpdate.realtimeDataUpdate();

      if (update.rpcException != null && update.rpcException is WampException) {
        var type = (update.rpcException).runtimeType;
        BnLog.error(
            className: 'locationProvider',
            methodName: 'refresh',
            text: update.rpcException.toString());
        _realUserSpeedKmh = null;
        SendToWatch.setUserSpeed('- km/h');
        _updateWatchData();
        _maxFails--;
        if (_maxFails <= 0) {
          _realtimeUpdate = null;
          _maxFails = 3;
        }

        if (!_isInBackground) {
          notifyListeners();
        }
        return;
      }
      if (update.rpcException != null &&
          update.rpcException is MultipleRequestException) {
        return;
      }

      _setRealtimeUpdate(update, notify: !_isInBackground);
      _maxFails = 3;

      if (_lastKnownPoint == null) {
        _realUserSpeedKmh = null;
        SendToWatch.setUserSpeed('- km/h');
        if (!kIsWeb) _updateWatchData();
      }
      if (!_isInBackground) {
        notifyListeners();
      }
    } catch (e) {
      BnLog.error(
          className: 'locationProvider',
          methodName: 'refreshRealtimeData',
          text: e.toString());
    }
  }

  Future<bg.Location?> getCurrentLocation() async {
    try {
      if (!HiveSettingsDB.useAlternativeLocationProvider) {
        return await bg.BackgroundGeolocation.getCurrentPosition(
          timeout: 2,
          maximumAge: 30000,
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        );
      } else {
        geolocator.Position position =
            await geolocator.Geolocator.getCurrentPosition(
                locationSettings: locationSettings);
        _onLocation(position.convertToBGLocation());
      }
    } catch (e) {
      BnLog.verbose(
          text: 'getNewLocation failed',
          methodName: 'getNewLocation',
          className: toString());
    }
    return null;
  }

  void checkUserFinishedOrEndEvent() async {
    try {
      var activeEventData = ProviderContainer().read(activeEventProvider);
      //Check for 'user reached finish' event and inform user

      int userPos = _realtimeUpdate?.user.position ?? 0;
      double runLength = _realtimeUpdate?.runningLength ?? double.maxFinite;
      Duration eventRuntime =
          DateTime.now().toUtc().difference(activeEventData.startDate.toUtc());
      if (userPos == 0 || runLength == 0) {
        _checkStopTrackingForce(activeEventData, eventRuntime);
        return;
      }

      if (userPos.toDouble() >= runLength - 50 && eventRuntime.inMinutes > 60) {
        //inform user at end of event
        //subtract -50m because finish is in the middle of BavariaPark, not at the end of track point
        //check event is running for a minimum interval to avoid stop of auto tracking
        if (_userReachedFinishDateTime == null) {
          _userReachedFinishDateTime = DateTime.now();
          var isTracking = await stopTracking();
          if (isTracking) {
            return;
          }
          if (HiveSettingsDB.autoStopTrackingEnabled) {
            NotificationHelper().showString(
                id: DateTime.now().hashCode,
                text: Localize.current.finishReachedStopedTracking);
            QuickAlert.show(
                context: rootNavigatorKey.currentContext!,
                type: QuickAlertType.warning,
                title: Localize.current.finishReachedTitle,
                text: Localize.current.finishReachedStopedTracking);
            BnLog.info(
                className: 'locationProvider',
                methodName: 'checkUserFinishedOrEndEvent',
                text: 'User reached finish - auto stop');
          } else {
            NotificationHelper().showString(
                id: DateTime.now().hashCode,
                text: Localize
                    .current.finishReachedtargetReachedPleaseStopTracking);
            QuickAlert.show(
                context: rootNavigatorKey.currentContext!,
                type: QuickAlertType.warning,
                title: Localize.current.finishReachedTitle,
                text: Localize
                    .current.finishReachedtargetReachedPleaseStopTracking);
            BnLog.info(
                className: 'locationProvider',
                methodName: 'checkUserFinishedOrEndEvent',
                text: 'User reached finish');
          }
        }
      }
    } catch (e) {
      BnLog.error(
        text: e.toString(),
        className: 'locationProvider',
        methodName: 'checkUserFinishedOrEndEvent',
      );
    }
  }

  void _checkStopTrackingForce(
      Event activeEventData, Duration eventRuntime) async {
    if (DateTime.now().difference(_lastForceStop) <
        const Duration(minutes: 60)) {
      return;
    }
    //Stop if state is finished
    if (activeEventData.status == EventStatus.finished &&
        isTracking &&
        HiveSettingsDB.autoStopTrackingEnabled) {
      _lastForceStop = DateTime.now();
      _userReachedFinishDateTime == null;
      var isTracking = await stopTracking();
      if (isTracking) return;
      //Alert for overtime or finish event
      if (activeEventData.status == EventStatus.finished) {
        if (_isInBackground) {
          NotificationHelper().showString(
              id: DateTime.now().hashCode,
              text: Localize.current.finishStopTrackingEventOver);
        } else {
          QuickAlert.show(
              context: rootNavigatorKey.currentContext!,
              type: QuickAlertType.info,
              title: Localize.current.finishForceStopEventOverTitle,
              text: Localize.current.finishStopTrackingEventOver);
        }
      }
      BnLog.info(
          className: 'locationProvider',
          methodName: 'checkUserFinishedOrEndEvent',
          text:
              'forced tracking stop finished${activeEventData.status == EventStatus.finished}');
    }
    //Stop if event runtime greater than maximum
    var maxDuration = activeEventData.duration.inMinutes;
    if (maxDuration == 0) return;
    if (eventRuntime.inMinutes >= maxDuration && isTracking) {
      _lastForceStop = DateTime.now();
      _userReachedFinishDateTime == null;
      var isTracking = await stopTracking();
      if (isTracking) return;
      if (_isInBackground) {
        NotificationHelper().showString(
            id: DateTime.now().hashCode,
            text: Localize.current.stopTrackingTimeOut(maxDuration));
      } else {
        QuickAlert.show(
            context: rootNavigatorKey.currentContext!,
            type: QuickAlertType.warning,
            title: Localize.current.timeOutDurationExceedTitle,
            text: Localize.current.stopTrackingTimeOut(maxDuration));
      }
      BnLog.info(
          className: 'locationProvider',
          methodName: 'checkUserFinishedOrEndEvent',
          text: 'Remembering user to stop tracking');
    }
  }

  void _updateWatchData() {
    try {
      if (kIsWeb) return;
      SendToWatch.setIsLocationTracking(isTracking);
      if (_realtimeUpdate != null && _realtimeUpdate!.rpcException == null) {
        SendToWatch.updateRealtimeData(_realtimeUpdate?.toJson());
      }
    } catch (e) {
      if (!kIsWeb) {
        BnLog.error(text: 'Error on _updateWatchData ${e.toString()}');
      }
    }
  }

  ///Clear all tracked points
  ///
  /// Set ODO meter to  0.0 km
  Future<bool> resetTrackPoints() async {
    try {
      if (HiveSettingsDB.useAlternativeLocationProvider) {
        _userGpxPoints.clear();
        _userSpeedPoints.clear();
        _userLatLngList.clear();
        notifyListeners();
        //LocationStore.clearTrackPointStoreForDate(DateTime.now());
        return true;
      }
      //Triggers start location service
      var odoResetResult =
          await bg.BackgroundGeolocation.setOdometer(0.0).then((value) {
        _odometer = value.odometer;
        _userGpxPoints.clear();
        _userSpeedPoints.clear();
        _userLatLngList.clear();
        notifyListeners();
        //LocationStore.clearTrackPointStoreForDate(DateTime.now());
      }).catchError((error) {
        if (!kIsWeb) {
          BnLog.error(text: 'Reset trackPoint] ERROR: $error');
        }
        return null;
      });

      if (!isTracking) {
        //#issue 1102
        var bgGeoLocState = await bg.BackgroundGeolocation.stop();
        _trackingType =
            bgGeoLocState.enabled ? trackingType : TrackingType.noTracking;
        notifyListeners();
      }

      return odoResetResult == null ? false : true;
    } catch (e) {
      BnLog.error(
          text: 'Error on resetTrackPoints ${e.toString()}', exception: e);

      return false;
    }
  }

  Future<void> resetTrackPointsStore() async {
    LocationStore.clearTrackPointStore();
  }

  Future resetOdoMeterAndRoutePoints(BuildContext context) async {
    var alwaysPermissionGranted =
        (gpsLocationPermissionsStatus == LocationPermissionStatus.always);
    var whenInusePermissionGranted =
        (gpsLocationPermissionsStatus == LocationPermissionStatus.whenInUse);
    if (alwaysPermissionGranted || whenInusePermissionGranted) {
      QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          type: QuickAlertType.warning,
          showCancelBtn: true,
          title: Localize.current.resetOdoMeterTitle,
          text:
              '${Localize.current.userSpeed}  ${realUserSpeedKmh == null ? '- km/h' : realUserSpeedKmh?.formatSpeedKmH()}\n'
              '${Localize.current.distanceDrivenOdo} ${HiveSettingsDB.useAlternativeLocationProvider ? '' : '${odometer.toStringAsFixed(1)} km'} \n '
              '${Localize.current.resetOdoMeter}'
              '${alwaysPermissionGranted ? "" : "\n${Localize.of(context).onlyWhileInUse}"} \n',
          confirmBtnText: Localize.current.yes,
          cancelBtnText: Localize.current.cancel,
          onConfirmBtnTap: () {
            resetTrackPoints();
            notifyListeners();
            if (!context.mounted) return;
            context.pop();
          });
    }
  }

  Future resetOdoMeter(BuildContext context) async {
    var alwaysPermissionGranted =
        (gpsLocationPermissionsStatus == LocationPermissionStatus.always);
    var whenInusePermissionGranted =
        (gpsLocationPermissionsStatus == LocationPermissionStatus.whenInUse);
    if ((alwaysPermissionGranted || whenInusePermissionGranted) &&
        !HiveSettingsDB.useAlternativeLocationProvider) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          showCancelBtn: true,
          title: Localize.current.resetOdoMeterTitle,
          text:
              '${Localize.current.userSpeed}  ${realUserSpeedKmh == null ? '- km/h' : realUserSpeedKmh?.formatSpeedKmH()}\n'
              '${Localize.current.distanceDrivenOdo} ${HiveSettingsDB.useAlternativeLocationProvider ? '' : '${odometer.toStringAsFixed(1)} km'} \n '
              '${Localize.current.resetOdoMeter}',
          confirmBtnText: Localize.current.yes,
          cancelBtnText: Localize.current.cancel,
          onConfirmBtnTap: () {
            resetTrackPoints();
            notifyListeners();
            if (!rootNavigatorKey.currentContext!.mounted) return;
            rootNavigatorKey.currentContext!.pop();
          });
    }
  }

//################# Subscription
  int _maxSubscribeFails = 3;
  Timer? _subscriptionTimer;
  StreamSubscription<RealtimeUpdate?>? _realTimeDataStreamListener;
  StreamSubscription<WampConnectedState>? _wampConnectedListener;
  int _realTimeDataSubscriptionId = 0;

  Future<void> startRealtimeUpdateSubscriptionIfNotTracking() async {
    _wampConnectedListener?.cancel();
    _realTimeDataStreamListener?.cancel();
    _wampConnectedListener = null;
    _realTimeDataStreamListener = null;
    BnLog.info(
        text: 'started startRealtimeUpdateSubscription',
        className: 'location_provider');
    _wampConnectedListener =
        WampV2().wampConnectedStreamController.stream.listen((connected) async {
      if (connected == WampConnectedState.connected) {
        await (Future.delayed(const Duration(seconds: 3)));
        _maxSubscribeFails = 10;
        _subscribeIfNeeded(_trackingType);
      } else {
        _realTimeDataSubscriptionId = 0;
      }
    });
    _realTimeDataStreamListener =
        WampV2().realTimeUpdateStreamController.stream.listen((event) {
      if (event.rpcException != null) {
        //set null after x secs
        return;
      }
      _setRealtimeUpdate(event, notify: !_isInBackground);
    });

    _reStartRealtimeUpdateTimer();
    _subscribeIfNeeded(_trackingType);
  }

  int rtUpdateFails = 0;

  void _setRealtimeUpdate(RealtimeUpdate rtu, {required bool notify}) {
    BnLog.verbose(text: '_setRealtimeUpdate $rtu');
    _realtimeUpdate = rtu;
    if (rtu.rpcException == null) {
      rtUpdateFails = 0;
      _lastRealtimedataUpdate = DateTime.now();
      _eventIsActive = rtu.eventIsActive;
    } else {
      rtUpdateFails++;
      if (rtUpdateFails > 3) {
        _realtimeUpdate = null;
        if (notify) {
          notifyListeners();
        }
        return;
      }
    }

    if (rtu.head.longitude != 0.0) {
      double lat = rtu.head.latitude ?? defaultLatitude;
      double lon = rtu.head.longitude ?? defaultLongitude;

      _trainHeadStreamController.add(LatLng(lat, lon));

      if (_lastRouteName != rtu.routeName || _eventState != rtu.eventState) {
        _lastRouteName = rtu.routeName;
        _eventState = rtu.eventState;
        ProviderContainer()
            .read(activeEventProvider.notifier)
            .refresh(forceUpdate: true);
      }
    }

    if ((_lastRouteName != rtu.routeName ||
        _eventState != rtu.eventState ||
        _eventIsActive != rtu.eventIsActive)) {
      _lastRouteName = rtu.routeName;
      _eventState = rtu.eventState;
      _eventIsActive = rtu.eventIsActive;
      ProviderContainer()
          .read(activeEventProvider.notifier)
          .refresh(forceUpdate: true);
    }
    if (notify) {
      notifyListeners();
    }
  }

  void stopRealtimedataSubscription() {
    //print('${DateTime.now().toIso8601String()} _stopRealtimedataSubscription');
    BnLog.debug(text: 'rtProvider dispose');
    _subscriptionTimer?.cancel();
    _wampConnectedListener?.cancel();
    _realTimeDataStreamListener?.cancel();

    _subscriptionTimer = null;
    _wampConnectedListener = null;
    _realTimeDataStreamListener = null;
    _realTimeDataSubscriptionId = 0;
    print('${DateTime.now().toIso8601String()} _stopRealtimedataSubscription');
  }

  /// timer to get new [RealtimeData] if other timer or events are failed
  /// every 15 sec
  Future<void> _reStartRealtimeUpdateTimer() async {
    BnLog.debug(text: '_reStartRealtimeUpdateTimer');
    _subscriptionTimer?.cancel();
    _subscriptionTimer = null;
    _rtUpdateIntervalInMs = 10000; //10s subscription update from server
    _subscriptionTimer = Timer.periodic(
        Duration(
          milliseconds: _rtUpdateIntervalInMs,
        ), (timer) async {
      await refreshRealtimeData(forceUpdate: true); // _realtimeUpdate == null);
    });
    await refreshRealtimeData(forceUpdate: true);
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
      _reStartRealtimeUpdateTimer();
    } else {
      _maxSubscribeFails = 3;
      _unsubscribe();
      stopRealtimedataSubscription(); //realtimeDataUpdate in LocationProvider handled
    }
  }

/* Future<void> noTrackingRealtimedataRefresh() async {


    var update = await RealtimeUpdate.realtimeDataUpdate();
    if (update.rpcException != null) {
      _maxFails--;
      if (_maxFails == 0) {
        //trigger only once a time
        BnLog.warning(
            text: 'RealtimeData update exceed maximum blocking 10 seconds');
        _realtimeUpdate =
            _realtimeUpdate?.copyWith(rpcException: update.rpcException);
        if (!_isInBackground) notifyListeners();
        await Future.delayed(const Duration(seconds: 10));
        _maxFails = 3;
      }
      if (_maxFails <= 0) {
        return;
      }
    }
    _maxFails = 3;
    _setRealtimeUpdate(update, notify: !_isInBackground);

    BnLog.trace(
        text: 'noTrackingRealtimedataRefresh success: $lastRealtimedataUpdate',
        methodName: 'noTrackingRealtimedataRefresh',
        className: toString());

    _subscribeIfNeeded(_trackingType);
  }*/

  void _unsubscribe() async {
    for (var subscriptionId in WampV2().subscriptions) {
      await unSubscribeMessage(subscriptionId);
    }
    _realTimeDataSubscriptionId = 0;
  }

  Future<bool> _subscribe() async {
    for (var subscriptionId in WampV2().subscriptions) {
      if (subscriptionId == realtimeSubscriptionId) return true;
    }
    _realTimeDataSubscriptionId = await subscribeMessage('RealtimeData');
    //3589978069
    if (_realTimeDataSubscriptionId == 0) {
      return false;
      //workaround if subscription fails
      //LocationProvider().refresh();
    }
    return true;
  }
}

//Providers

final locationProvider = ChangeNotifierProvider((ref) => LocationProvider());

final locationLastUpdateProvider = Provider.autoDispose((ref) {
  print('${DateTime.now().toIso8601String()} locationLastUpdateProvider ');
  return ref.watch(locationProvider.select((l) => l.lastRealtimedataUpdate));
});

var _lastSpeedColorIdx = ColorConstants.colorsGradient.iterator;

final colorTimerProvider = Provider.autoDispose((ref) {
  print('${DateTime.now().toIso8601String()} colorTimerProvider');
  var _ = ref.watch(locationProvider.select((l) => l.realtimeUpdate));
  if (_lastSpeedColorIdx.moveNext()) {
    return _lastSpeedColorIdx.current;
  } else {
    _lastSpeedColorIdx = SpeedToColor.speedColors.iterator;
    _lastSpeedColorIdx.moveNext();
    return _lastSpeedColorIdx.current;
  }
});

final updateIntervalProvider = Provider.autoDispose((ref) {
  print('${DateTime.now().toIso8601String()} updateIntervalProvider');
  var _ = ref.watch(locationProvider.select((l) => l.updateIntervalInMs));
});

final realtimeDataProvider = Provider.autoDispose((ref) {
  //print('${DateTime.now().toIso8601String()} realtimeDataProvider');
  return ref.watch(locationProvider.select((l) => l.realtimeUpdate));
});

final preciseLocationProvider = Provider.autoDispose((ref) {
  return ref.watch(locationProvider.select((l) => l.locationIsPrecise));
});

///true when moving
final isMovingProvider = Provider.autoDispose((ref) {
  return ref.watch(locationProvider.select((l) => l.isMoving));
});

final trackingTypeProvider = Provider.autoDispose((ref) {
  return ref.watch(locationProvider.select((l) => l.trackingType));
});

final odometerProvider = Provider.autoDispose((ref) {
  return ref.watch(locationProvider.select((l) => l.odometer));
});

final realUserSpeedProvider = Provider.autoDispose((ref) {
  return ref.watch(locationProvider.select((l) => l.realUserSpeedKmh));
});

final userLatLongProvider = Provider.autoDispose((ref) {
  return ref.watch(locationProvider.select((l) => l.userSpeedPoints));
});

final isGPSGrantedProvider = Provider.autoDispose((ref) {
  return ref.watch(locationProvider.select((l) => l.gpsGranted));
});

final gpsLocationPermissionsStatusProvider = Provider.autoDispose((ref) {
  return ref
      .watch(locationProvider.select((l) => l.gpsLocationPermissionsStatus));
});

final isUserParticipatingProvider = Provider.autoDispose((ref) {
  return ref.watch(locationProvider.select((l) => l.userIsParticipant));
});

///Watch active [Event]
final isActiveEventProvider = Provider.autoDispose((ref) {
  print('${DateTime.now().toIso8601String()} isActiveEventProvider');
  return ref.watch(locationProvider.select((l) => l.eventIsActive));
});

final geoFenceEventProvider =
    StreamProvider.autoDispose<bg.GeofenceEvent>((ref) {
  return LocationProvider().geoFenceEventStream.map((event) {
    return event;
  });
});
