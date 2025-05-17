import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/quickalert.dart';
import 'package:synchronized/synchronized.dart' show Lock;
import 'package:universal_io/io.dart';
import 'package:vector_math/vector_math.dart' show radians;
import 'package:wakelock_plus/wakelock_plus.dart';

import '../app_settings/app_configuration_helper.dart';
import '../app_settings/app_constants.dart';
import '../app_settings/server_connections.dart';
import '../generated/l10n.dart';
import '../geofence/geofence_helper.dart';
import '../helpers/average_list.dart';
import '../helpers/device_id_helper.dart';
import '../helpers/device_info_helper.dart';
import '../helpers/distance_converter.dart';
import '../helpers/double_helper.dart';
import '../helpers/enums/tracking_type.dart';
import '../helpers/logger/log_level.dart';
import '../helpers/geolocation/simplify_user_gpx_points_list.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/location2_to_bglocation.dart';
import '../helpers/location_permission_dialogs.dart';
import '../helpers/logger/logger.dart';
import '../helpers/notification/notification_helper.dart';
import '../helpers/notification/toast_notification.dart' show showToast;
import '../helpers/speed_to_color.dart';
import '../helpers/wamp/subscribe_message.dart';
import '../helpers/watch_communication_helper.dart';
import '../main.dart';
import '../models/event.dart';
import '../models/location.dart';
import '../models/realtime_update.dart';
import '../models/route.dart';
import '../models/user_gpx_point.dart';
import '../models/user_location_point.dart';
import '../models/user_speed_point.dart';
import '../wamp/wamp_exception.dart';
import '../wamp/wamp_v2.dart';
import 'active_event_provider.dart';
import 'app_start_and_router/go_router.dart';

///[LocationProvider] gets actual procession of BladeNight
///when tracking is active is result included users position and friends
///is tracking inactive result contains only head,tail and route data
class LocationProvider with ChangeNotifier {
  static LocationProvider? _instance = LocationProvider._privateConstructor();

  LocationProvider._privateConstructor() {
    runZonedGuarded(() async {
      _init();
    }, errorHandler);
  }

  void errorHandler(Object error, StackTrace stack) {}

  //instance factory
  factory LocationProvider() {
    _instance ??= LocationProvider._privateConstructor();
    return _instance!;
  }

  bool _mapPushed = false;
  AverageList<double> realtimeSpeedAvgList = AverageList(maxLength: 5);

  bg.State? _state;
  StreamSubscription<geolocator.Position>? _locationSubscription;
  bool locationRequested = false;
  bool _isInBackground = false;
  bool _wakelockDisabled = false;
  bool _hasAutoStoppedDueLowBatt = false;

  static DateTime _lastRealtimedataUpdate = DateTime(2022, 1, 1, 0, 0, 0);
  static DateTime _lastForceStop = DateTime(2022, 1, 1, 0, 0, 0);
  static DateTime _lastSendLocationToServerRequest =
      DateTime(2022, 1, 1, 0, 0, 0);
  DateTime? _userReachedFinishDateTime, _startedTrackingTime;
  Timer? _updateRealtimedataIfTrackingTimer,
      _saveLocationsTimer,
      _startTrackingCheckTimer,

      ///Timer to reset speed and user location if no new data
      _noLocationAndBatteryTimer;

  bool _autoTrackingStarted = false;
  String _lastRouteName = '';
  EventStatus? _eventState;

  bool get isInBackground => _isInBackground;

  EventStatus? get eventState => _eventState;

  DateTime get lastRealtimedataUpdate => _lastRealtimedataUpdate;

  bool _eventIsRunning = false;

  bool get eventIsActive => _eventIsRunning;

  bool _isMoving = false;

  bool get isMoving => _isMoving;

  ///Location service is active
  bool get isTracking => _trackingType != TrackingType.noTracking;

  TrackingType _trackingType = TrackingType.noTracking;

  TrackingType get trackingType => _trackingType;

  TrackWaitStatus _trackWaitStatus = TrackWaitStatus.none;

  TrackWaitStatus get trackWaitStatus => _trackWaitStatus;

  bool get hasLocationPermissions =>
      _gpsLocationPermissionsStatus == LocationPermissionStatus.always ||
      _gpsLocationPermissionsStatus == LocationPermissionStatus.whenInUse;

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

  static final List<LatLng> _userLatLngList = <LatLng>[];

  ///Users position LatLng
  List<LatLng> get userLatLngList => _userLatLngList;

  static double? _realUserSpeedKmh;

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

  static final UserSpeedPoints _userSpeedPoints = UserSpeedPoints([]);

  UserSpeedPoints get userSpeedPoints => _userSpeedPoints;

  bool _locationIsPrecise = true;

  bool get locationIsPrecise => _locationIsPrecise;

  static final _userGpxPoints = <UserGpxPoint>[];

  List<UserGpxPoint> get userGpxPoints => _userGpxPoints;

  //Stream controllers private
  final _userPositionStreamController =
      StreamController<bg.Location>.broadcast();

  final _userLatLngStreamController = StreamController<LatLng>.broadcast();

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

  Stream<LatLng> get trainHeadUpdateStream => _trainHeadStreamController.stream;

  Stream<UserGpxPoint> get userTrackPointsControllerStream =>
      _userTrackPointsStreamController.stream;

  Stream<LocationMarkerPosition> get userLocationMarkerPositionStream =>
      _userLocationMarkerPositionStreamController.stream;

  Stream<LocationMarkerHeading> get userLocationMarkerHeadingStream =>
      _userLocationMarkerHeadingStreamController.stream;

  StreamSubscription<bool>? _wampConnectedSubscription;

  late geolocator.LocationSettings locationSettings;

  DateTime? _lastLocationTimeStamp;

  static bool _showOwnTrack = false;
  static bool _showOwnColoredTrack = false;

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
    _noLocationAndBatteryTimer?.cancel();
    _startTrackingCheckTimer?.cancel();
    _saveLocationsTimer?.cancel();
    _updateRealtimedataIfTrackingTimer?.cancel();
    super.dispose();
  }

  void _init() async {
    startRealtimeUpdateSubscriptionIfNotTracking();

    if (kIsWeb) {
      HiveSettingsDB.setUseAlternativeLocationProvider(true);
      notifyListeners();
      return;
    }

    if (!HiveSettingsDB.useAlternativeLocationProvider) {
      _state = await _startBackgroundGeolocation();
      if (_state == null) {
        notifyListeners();
        return;
      }
    }

    _autoStopTracking = HiveSettingsDB.autoStopTrackingEnabled;
    _autoStartTracking = HiveSettingsDB.autoStartTrackingEnabled;

    _gpsLocationPermissionsStatus =
        await LocationPermissionDialog().getPermissionsStatus();

    if (!hasLocationPermissions) {
      notifyListeners();
      return;
    }

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
      if (HiveSettingsDB.wakeLockEnabled) {
        WakelockPlus.disable();
      }
    } //set to foreground
    else {
      if (_trackingType == TrackingType.noTracking ||
          _trackingType != TrackingType.onlyTracking) {
        WampV2().startWamp();
      }
      if (_trackingType == TrackingType.noTracking) {
        _reStartRealtimeUpdateTimer();
      }
      if (HiveSettingsDB.wakeLockEnabled) {
        WakelockPlus.enable();
      }
      _updateUserLocationTrack;
    }
  }

  Future<bool> ensureBackgroundGeolocationInitialized() async {
    var initialized = await _startBackgroundGeolocation();
    return initialized != null;
  }

  ///Initializes BackgroundLocationPlugin
  Future<bg.State?> _startBackgroundGeolocation() async {
    try {
      if (_state != null) return _state;
      bg.BackgroundGeolocation.onLocation(_onLocation, _onLocationError);
      //bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
      bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
      //bg.BackgroundGeolocation.onHeartbeat(_onHeartBeat);
      bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
      //bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);
      //bg.BackgroundGeolocation.onGeofence(_onGeoFenceEvent);

      var isMotionDetectionDisabled = HiveSettingsDB.isMotionDetectionDisabled;

      if (Platform.isAndroid) {
        return bg.BackgroundGeolocation.ready(bg.Config(
          locationAuthorizationRequest: 'Any',
          fastestLocationUpdateInterval: 1000,
          reset: true,
          debug: false,
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
          allowIdenticalLocations: true,
          activityRecognitionInterval: 10000,
          distanceFilter: 0,
          heartbeatInterval: 60,
          disableLocationAuthorizationAlert: true,
          disableMotionActivityUpdates: isMotionDetectionDisabled,
          logMaxDays: 0,
          persistMode: bg.Config.PERSIST_MODE_NONE,
          stopAfterElapsedMinutes: 3600,
          preventSuspend: true,
          stopOnTerminate: false,
          startOnBoot: false,
          logLevel: BnLog.getActiveLogLevel() == LogLevel.verbose
              ? bg.Config.LOG_LEVEL_VERBOSE
              : bg.Config.LOG_LEVEL_INFO,
          stopTimeout: 180,
          //20 minutes
          // <-- a very long stopTimeout
          disableStopDetection: true,
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
          debug: BnLog.getActiveLogLevel() == LogLevel.all ? true : false,
          fastestLocationUpdateInterval: 1000,
          //ALL
          logLevel: BnLog.getActiveLogLevel() == LogLevel.verbose
              ? bg.Config.LOG_LEVEL_VERBOSE
              : bg.Config.LOG_LEVEL_INFO,
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
          distanceFilter: 0,
          disableLocationAuthorizationAlert: true,
          disableMotionActivityUpdates: isMotionDetectionDisabled,
          logMaxDays: BnLog.getActiveLogLevel() == LogLevel.verbose ? 8 : 0,
          heartbeatInterval: 60,
          stopDetectionDelay: 180,
          persistMode: BnLog.getActiveLogLevel() == LogLevel.verbose
              ? bg.Config.PERSIST_MODE_ALL
              : bg.Config.PERSIST_MODE_NONE,
          // Activity Recognition
          activityRecognitionInterval: 10000,
          showsBackgroundLocationIndicator: true,
          preventSuspend: true,
          //locationUpdateInterval: 1000, not used - distance filter must be 0
          stopTimeout: 180,
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
    BnLog.all(text: '_onLocation ${location.coords} ${location.isMoving}');
    _lastLocationTimeStamp = DateTime.now();
    _updateUserLocation(location);
  }

  ///Update user location and track points list
  void _updateUserLocation(bg.Location location) async {
    BnLog.verbose(text: 'updateuserloc ${location.coords}');
    _lastKnownPoint = location;
    if (!isTracking) return;
    _isMoving = location.isMoving;
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

    _userLatLngList
        .add(LatLng(location.coords.latitude, location.coords.longitude));

    if (MapSettings.showOwnTrack) {
      var userTrackingPoint = UserGpxPoint(
          location.coords.latitude.toShortenedDouble(9),
          location.coords.longitude.toShortenedDouble(9),
          _realUserSpeedKmh!,
          location.coords.heading,
          location.coords.altitude,
          odometer,
          DateTime.now());
      if (_userGpxPoints.isNotEmpty) {
        var userLastPoint = _userGpxPoints.last;
        var lon = location.coords.longitude.toShortenedDouble(9);
        var lat = location.coords.latitude.toShortenedDouble(9);
        if (userLastPoint.latitude != lat && userLastPoint.longitude != lon) {
          _userGpxPoints.add(userTrackingPoint);
        }
      } else {
        _userGpxPoints.add(userTrackingPoint);
      }
    }

    var userLoc = UserLocationPoint(
        latitude: location.coords.latitude.toShortenedDouble(9),
        longitude: location.coords.longitude.toShortenedDouble(9),
        speed: '${_realUserSpeedKmh!.toStringAsFixed(1)} km/h');
    SendToWatch.updateUserLocationData(userLoc);
    await _updateUserLocationTrack(location);

    if (!_isInBackground) {
      notifyListeners();
    }
  }

  //init 0 then 0 plus 1
  //if 0 recalculate
  static int rerenderTrackCount = -1;
  static bool calcUpdateUserLocationTrack = false;

  /// simplify user location track
  /// all variables are static
  ///
  Future<bool> _updateUserLocationTrack(bg.Location location) {
    if (calcUpdateUserLocationTrack) return Future.value(false);
    return Future.microtask(() {
      try {
        calcUpdateUserLocationTrack = true;
        rerenderTrackCount++;
        if (rerenderTrackCount >= 30) {
          var simplifyUserGpxPoints = simplifyUserGpxPointList(_userGpxPoints,
              tolerance: MapSettings.simplifyTolerance);
          _userGpxPoints.clear();
          _userGpxPoints.addAll(simplifyUserGpxPoints);
          rerenderTrackCount = 0;
        }
        if (!_showOwnTrack) return true;

        if (!_showOwnColoredTrack && rerenderTrackCount == 0) {
          _userLatLngList.clear();
          _userLatLngList.addAll(_userGpxPoints.toLatLngList);
        }

        if (_showOwnColoredTrack) {
          if (_userSpeedPoints.latLngList.isEmpty) {
            //first point
            UserSpeedPoint userSpeedPoint = UserSpeedPoint(
              location.coords.latitude.toShortenedDouble(9),
              location.coords.longitude.toShortenedDouble(9),
              _realUserSpeedKmh!,
              LatLng(location.coords.latitude.toShortenedDouble(9),
                  location.coords.longitude.toShortenedDouble(9)),
            );
            _userSpeedPoints.addUserSpeedPoint(userSpeedPoint);
          } else if (rerenderTrackCount == 0) {
            //decrease numbers of poly lines
            var smallTrackPointList = UserSpeedPoints([]);
            LatLng? lastLatLng;
            for (var counter = 0; counter < _userGpxPoints.length; counter++) {
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
            }
            _userSpeedPoints.clear();
            _userSpeedPoints.userSpeedPoints
                .addAll(smallTrackPointList.userSpeedPoints);
            UserSpeedPoint userSpeedPoint = UserSpeedPoint(
              location.coords.latitude,
              location.coords.longitude,
              _realUserSpeedKmh!,
              _userSpeedPoints.lastSpeedPointLatLng,
            );
            _userSpeedPoints.addUserSpeedPoint(userSpeedPoint);
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
      } catch (e) {
        BnLog.error(text: 'failed to calculate usertrack');
      } finally {
        calcUpdateUserLocationTrack = false;
      }
      return true;
    });
  }

  ///load UserTrack from database for current day
  void _initUserTrackStore() async {
    await Future.microtask(() {
      _userGpxPoints.clear();
      _userReachedFinishDateTime == null;
      if (MapSettings.showOwnTrack && LocationStore.dataTodayAvailable) {
        //load data
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
      if (!_isInBackground) {
        notifyListeners();
      }
    });
  }

  void _onLocationError(bg.LocationError error) {
    if (!kIsWeb) BnLog.verbose(text: 'Location error reason: $error');
    if (_lastKnownPoint != null) {
      //sendLocation(_lastKnownPoint!);
    }
  }

  void _onActivityChange(bg.ActivityChangeEvent event) {
    _isMoving = event.activity.toLowerCase() != 'still';
    if (_lastKnownPoint != null && !_isMoving) {
      _realUserSpeedKmh = 0.0;
      var userLocationPoint = UserLocationPoint(
          latitude: _lastKnownPoint!.coords.latitude.toShortenedDouble(9),
          longitude: _lastKnownPoint!.coords.longitude.toShortenedDouble(9),
          speed: '- km/h');
      SendToWatch.updateUserLocationData(userLocationPoint);
    }

    if (!_isInBackground) {
      notifyListeners();
    }
  }

  void _onHeartBeat(bg.HeartbeatEvent event) {
    BnLog.verbose(text: '_onHeartbeatEvent  ${event.location}');
    _getHeartBeatLocation();
  }

  void _getHeartBeatLocation() async {
    if (!isTracking) return;
    BnLog.verbose(text: '_getHeartBeatLocation');
    try {
      await bg.BackgroundGeolocation.getCurrentPosition(
        timeout: 2,
        maximumAge: 5000,
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        samples: 2, // How many location samples to attempt.
      );
      //triggers update
    } catch (e) {
      BnLog.warning(
          className: toString(),
          methodName: '_getHeartBeatLocation',
          text: '_getHeartBeatLocation failed: ${e.toString()}');
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
    if (!_isInBackground) {
      notifyListeners();
    }
  }

  //called by geolocator and bg id gps disabled / enabled crash sometimes
  void _onLocationPermissionChange(bool gpsIsEnabled) {
    if (gpsIsEnabled) {
      _gpsLocationPermissionsStatus = LocationPermissionStatus.notDetermined;
    } else {
      _gpsLocationPermissionsStatus = LocationPermissionStatus.denied;
      stopTracking();
    }
    notifyListeners();
  }

  void toggleAutoStop() async {
    _autoStopTracking = !_autoStopTracking;
    notifyListeners();
    HiveSettingsDB.setAutoStopTrackingEnabled(_autoStopTracking);
  }

  Future<bool> stopTracking() async {
    _setRealtimedataUpdateTimerIfTracking(false);
    if (HiveSettingsDB.useAlternativeLocationProvider) {
      _trackingStopped();
      await startRealtimeUpdateSubscriptionIfNotTracking();
    } else {
      bg.BackgroundGeolocation.stop().then((bg.State state) async {
        _trackingStopped();
        HiveSettingsDB.setOdometerValue(odometer);
        await WakelockPlus.disable();
        GeofenceHelper().startStopGeoFencing();
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
    _locationSubscription = null;
    _lastKnownPoint = null;
    _realUserSpeedKmh = null;
    _userLatLng = null;
    _trackingType = TrackingType.noTracking;
    _stopNoLocationAndBatteryTimer();
    //reset autostart
    //avoid second autostart on an event , reset after end
    var activeEventData = ActiveEventProvider().event;
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

  Future<bool> _collectLocationWithPermissionService() async {
    var status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      _gpsLocationPermissionsStatus == LocationPermissionStatus.whenInUse;
      //web no always Loc
      if (kIsWeb) return true;
    } else if (status == PermissionStatus.denied) {
      _gpsLocationPermissionsStatus == LocationPermissionStatus.denied;
      return false;
    }
    if (HiveSettingsDB.hasAskedAlwaysAllowLocationPermission) return true;
    var alwaysStatus = await Permission.locationAlways.request();
    if (alwaysStatus == PermissionStatus.granted) {
      _gpsLocationPermissionsStatus == LocationPermissionStatus.always;
      return true;
    }
    return false;
  }

  ///Check and request necessary location permissions
  Future<bool> _collectLocationPermissions(BuildContext context) async {
    if (kIsWeb) return false;
    var serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      //web no always request!
      HiveSettingsDB.setHasShownProminentDisclosure(kIsWeb ? true : false);
      HiveSettingsDB.setHasAskedAlwaysAllowLocationPermission(
          kIsWeb ? true : false);
      if (context.mounted) {
        await LocationPermissionDialog().requestAndOpenAppSettings(context);
      }
      return false;
    }
    var locationPermission = await geolocator.Geolocator.checkPermission();
    if (locationPermission == geolocator.LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      HiveSettingsDB.setHasShownProminentDisclosure(false);
      HiveSettingsDB.setHasAskedAlwaysAllowLocationPermission(false);
      _gpsLocationPermissionsStatus =
          LocationPermissionStatus.locationNotEnabled;
      Fluttertoast.showToast(
          msg: Localize.current.noLocationPermitted,
          backgroundColor: Colors.redAccent);

      BnLog.warning(
          text: 'location permanentlyDenied by OS',
          className: 'location_provider',
          methodName: '_collectLocationPermissions');
      if (context.mounted) {
        await LocationPermissionDialog().requestAndOpenAppSettings(context);
      }
      //no tracking start
      return false;
    }

    if (HiveSettingsDB.hasShownProminentDisclosure == false ||
        locationPermission == geolocator.LocationPermission.denied) {
      var acceptLocation =
          await LocationPermissionDialog().showProminentAndroidDisclosure();
      if (!acceptLocation) {
        BnLog.warning(
            text: 'No positive prominent disclosure or always denied');
        return false;
      }
      HiveSettingsDB.setHasShownProminentDisclosure(true);

      var permission = await geolocator.Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        HiveSettingsDB.setHasShownProminentDisclosure(false);
        HiveSettingsDB.setHasAskedAlwaysAllowLocationPermission(
            kIsWeb ? true : false);
        _gpsLocationPermissionsStatus =
            LocationPermissionStatus.locationNotEnabled;
        Fluttertoast.showToast(
            msg: Localize.current.noLocationPermitted,
            backgroundColor: Colors.redAccent);

        BnLog.warning(
            text: 'location permanentlyDenied by OS',
            className: 'location_provider',
            methodName: '_collectLocationPermissions');
        if (context.mounted) {
          await LocationPermissionDialog().requestAndOpenAppSettings(context);
        }
        //no tracking start
        return false;
      }

      if (permission == geolocator.LocationPermission.denied) {
        HiveSettingsDB.setHasShownProminentDisclosure(false);
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return true;
      }
    }

    if (Platform.isAndroid &&
        await DeviceHelper.isAndroidGreaterVNine() &&
        context.mounted) {
      await LocationPermissionDialog()
          .showMotionSensorProminentDisclosure(context);
    }

    if (locationPermission == geolocator.LocationPermission.denied) {
      _gpsLocationPermissionsStatus = LocationPermissionStatus.denied;
      var res = await LocationPermissionDialog()
          .requestWhileInUseLocationPermissions();
      _gpsLocationPermissionsStatus = res;
      if (res == LocationPermissionStatus.always) {
        locationPermission = geolocator.LocationPermission.always;
      }
      if (res == LocationPermissionStatus.whenInUse) {
        locationPermission = geolocator.LocationPermission.whileInUse;
      }
    }

    if (!kIsWeb &&
        locationPermission == geolocator.LocationPermission.whileInUse) {
      _gpsLocationPermissionsStatus = LocationPermissionStatus.whenInUse;
      var res =
          await LocationPermissionDialog().requestAlwaysLocationPermissions();
      _gpsLocationPermissionsStatus = res;
      if (res == LocationPermissionStatus.always) {
        locationPermission = geolocator.LocationPermission.always;
      }
    }

    if (locationPermission == geolocator.LocationPermission.always) {
      _gpsLocationPermissionsStatus = LocationPermissionStatus.always;
    }

    //Check precise location
    _locationIsPrecise =
        await LocationPermissionDialog().checkOrRequestPreciseLocation() ==
            geolocator.LocationAccuracyStatus.precise;
    return !locationIsPrecise ? false : true;
  }

  /// Starts location tracking with set values
  ///
  /// Returns false if no location-permissions given or fails
  Future<bool> startTracking(TrackingType trackingType) async {
    try {
      var context = rootNavigatorKey.currentContext!;
      _showOwnTrack = MapSettings.showOwnTrack;
      _showOwnColoredTrack = MapSettings.showOwnColoredTrack;
      _trackWaitStatus = TrackWaitStatus.starting;
      notifyListeners();

      bool permissionOk;
      if (kIsWeb) {
        permissionOk = await _collectLocationWithPermissionService();
      } else {
        permissionOk = await _collectLocationPermissions(context);
      }
      if (!permissionOk) {
        return false;
      }
      //if (kIsWeb) return false;
      _trackingType = trackingType;
      if (kIsWeb) {
        _userIsParticipant = trackingType == TrackingType.userNotParticipating;
        if (context.mounted) {
          showToast(message: Localize.of(context).showonly);
        }
      } else {
        _userIsParticipant = trackingType == TrackingType.userParticipating;
      }
      _isHead = HiveSettingsDB.specialCodeValue == 1 ||
          HiveSettingsDB.specialCodeValue == 5;
      _isTail = HiveSettingsDB.specialCodeValue == 2 ||
          HiveSettingsDB.specialCodeValue == 6;

      if (!kIsWeb &&
          HiveSettingsDB.trackingFirstStart &&
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
      //set user track points
      _initUserTrackStore();
      _startNoLocationAndBatteryTimer();
      if (HiveSettingsDB.wakeLockEnabled) {
        await WakelockPlus.enable();
      }

      if (kIsWeb || HiveSettingsDB.useAlternativeLocationProvider) {
        BnLog.info(
            text: 'alternative location tracking started',
            className: 'location_provider',
            methodName: '_startTracking');
        //set if kIsWeb
        HiveSettingsDB.setUseAlternativeLocationProvider(true);
        _listenLocationWithAlternativePackage();
        _trackingType = trackingType;
        stopRealtimedataSubscription();
        _setRealtimedataUpdateTimerIfTracking(true);
        _startedTrackingTime = DateTime.now();
        ActiveEventProvider().refresh(forceUpdate: true);
        _trackWaitStatus = TrackWaitStatus.none;
        notifyListeners();
        /*var loc = await _updateLocation();
        if (loc != null) {
          _getRealtimeDataWithLocation(loc);
        }
        SendToWatch.setIsLocationTracking(isTracking);*/
        HiveSettingsDB.setTrackingActive(isTracking);
      }
      //####################################################
      //# use Transistorsoft geolocator for Android and iOS
      //####################################################
      else {
        await bg.BackgroundGeolocation.start()
            .then((bg.State bgGeoLocState) async {
          BnLog.info(
              text: 'location tracking started',
              className: 'location_provider',
              methodName: 'startTracking');
          _startedTrackingTime = DateTime.now();
          _trackingType =
              bgGeoLocState.enabled ? trackingType : TrackingType.noTracking;
          _trackWaitStatus = TrackWaitStatus.none;
          notifyListeners();
          stopRealtimedataSubscription();
          _setRealtimedataUpdateTimerIfTracking(true);
          HiveSettingsDB.setTrackingActive(isTracking);
          SendToWatch.setIsLocationTracking(isTracking);
          var loc = await _updateLocation();
          if (loc != null) {
            _getRealtimeDataWithLocation(loc);
          }
        }).catchError((error) {
          BnLog.error(text: 'LocStarting ERROR: $error');
          _trackWaitStatus = TrackWaitStatus.none;
          trackingType = TrackingType.noTracking;
          notifyListeners();
          HiveSettingsDB.setTrackingActive(false);
          SendToWatch.setIsLocationTracking(false);
          _setRealtimedataUpdateTimerIfTracking(false);
          startRealtimeUpdateSubscriptionIfNotTracking();
          //re-update on error
          return null;
        });
        await bg.BackgroundGeolocation.setConfig(bg.Config(
            distanceFilter: trackingType == TrackingType.onlyTracking ? 5 : 0,
            locationUpdateInterval: 500,
            stopTimeout: trackingType == TrackingType.onlyTracking
                ? 5
                : 180, // <-- a very long stopTimeout
            disableStopDetection: trackingType == TrackingType.onlyTracking
                ? false
                : true // <-- Don't interrupt location updates when Motion API says "still"
            ));
        await bg.BackgroundGeolocation.changePace(true);
      }
    } catch (ex) {
      BnLog.verbose(
          text: 'startTracking Location',
          methodName: 'startTracking',
          className: toString());
    } finally {
      _trackWaitStatus = TrackWaitStatus.none;
      notifyListeners();
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
          coords: LatLng(location.coords.latitude.toShortenedDouble(9),
              location.coords.longitude.toShortenedDouble(9)),
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
  void _setRealtimedataUpdateTimerIfTracking(bool enabled) {
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

  void _stopNoLocationAndBatteryTimer() {
    _noLocationAndBatteryTimer?.cancel();
  }

  ///Start timer to autostart tracking on event start every minute
  void _startNoLocationAndBatteryTimer() {
    BnLog.verbose(text: 'init checkLocationUpdateTimer');
    _noLocationAndBatteryTimer?.cancel();
    _noLocationAndBatteryTimer = Timer.periodic(
      const Duration(seconds: 60),
      (timer) async {
        BnLog.verbose(text: 'checkBatteryTimer elapsed');
        var bat = Battery();
        try {
          var batteryLevel = await bat.batteryLevel;

          var isCharging = await bat.batteryState == BatteryState.charging;
          if (batteryLevel != -1) {
            checkWakeLock(batteryLevel / 100, isCharging);
            checkLowPowerStopTracking(batteryLevel / 100, isCharging);
          }
          BnLog.verbose(
              text:
                  'checkBatteryTimer finished $batteryLevel %, chg:$isCharging');
        } catch (ex) {
          BnLog.verbose(text: 'checkBatteryTimer cant executed due $ex');
        }
        if (_lastKnownPoint == null || _lastLocationTimeStamp == null) {
          _resetLocation();
        } else {
          var lastLocationTimeStampDiff =
              DateTime.now().difference(_lastLocationTimeStamp!);
          if (lastLocationTimeStampDiff > Duration(seconds: 60)) {
            _resetLocation();
          }
        }
      },
    );
  }

  void _resetLocation() {
    SendToWatch.updateUserLocationData(
        UserLocationPoint.userLocationPointEmpty());
    _realUserSpeedKmh = 0.0;
    _lastKnownPoint = null;
  }

  ///Start timer to autostart tracking on event start every minute
  void _autoStartTrackingUpdateTimer() {
    BnLog.verbose(text: 'init startTrackingUpdateTimer');
    _startTrackingCheckTimer?.cancel();
    _startTrackingCheckTimer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) async {
        await _showMapAndAutoStartTimerCallBack();
      },
    );
    _showMapAndAutoStartTimerCallBack();
  }

  ///Autostart tracking and show map page if event is active
  Future<void> _showMapAndAutoStartTimerCallBack() async {
    _eventIsRunning = ActiveEventProvider().event.isRunning;

    if (_eventIsRunning && !_mapPushed) {
      _mapPushed = true;
      BnLog.info(text: 'goNamed Map due event is active');
      rootNavigatorKey.currentContext?.goNamed(AppRoute.map.name);
    }

    if (isTracking ||
        !HiveSettingsDB.autoStartTrackingEnabled ||
        _autoTrackingStarted) {
      return;
    }

    if (_eventIsRunning) {
      startTracking(TrackingType.userParticipating);
      _autoTrackingStarted = true;
      BnLog.info(text: 'Autostart tracking due event is active');
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
    if (!_eventIsRunning) {
      _autoTrackingStarted = false; //reset auto tracking start
    }
  }

  Future<void> _listenLocationWithAlternativePackage() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = geolocator.AndroidSettings(
          accuracy: geolocator.LocationAccuracy.high,
          distanceFilter: 10,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 1),
          timeLimit: Duration(seconds: 3),
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
          timeLimit: Duration(seconds: 3));
    } else if (kIsWeb) {
      locationSettings = geolocator.WebSettings(
          accuracy: geolocator.LocationAccuracy.high,
          distanceFilter: 10,
          maximumAge: Duration(seconds: 5),
          timeLimit: Duration(seconds: 3));
    } else {
      locationSettings = geolocator.LocationSettings(
          accuracy: geolocator.LocationAccuracy.high,
          distanceFilter: 2,
          timeLimit: Duration(seconds: 3));
    }

    _locationSubscription = geolocator.Geolocator.getPositionStream(
            locationSettings: locationSettings)
        .listen((geolocator.Position? position) async {
      if (position == null) return;
      _onLocation(position.convertToBGLocation());
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
    BnLog.verbose(text: 'checkWakelock');
    if (HiveSettingsDB.wakeLockEnabled &&
        _wakelockDisabled == false &&
        !isCharging &&
        batteryLevel != -1 &&
        batteryLevel < 0.2) {
      BnLog.info(text: 'checkWakelock disable Wakelock');
      await WakelockPlus.disable();
      _wakelockDisabled = true;
      await stopTracking();
      if (!_isInBackground) {
        NotificationHelper().showString(
            id: DateTime.now().hashCode,
            text: Localize.current.wakelockWarnBattery(batteryLevel * 100));
      } else {
        showToast(
            message: Localize.current.wakelockWarnBattery(batteryLevel * 100));
      }
    }
    if (HiveSettingsDB.wakeLockEnabled &&
        _wakelockDisabled == true &&
        (batteryLevel > 0.2 && isCharging)) {
      _wakelockDisabled = false;
    }
  }

  void checkLowPowerStopTracking(double batteryLevel, bool isCharging) async {
    if (!isTracking) return;
    if (HiveSettingsDB.autoStopTrackingEnabled &&
        _hasAutoStoppedDueLowBatt == false &&
        !isCharging &&
        batteryLevel != -1 &&
        batteryLevel < 0.15) {
      BnLog.info(text: 'Low Power Stop tracking');
      await stopTracking();
      _hasAutoStoppedDueLowBatt = true;

      if (!_isInBackground) {
        NotificationHelper().showString(
            id: DateTime.now().hashCode,
            text: Localize.current
                .autoStopTrackingDueLowBattery(batteryLevel * 100));
      } else {
        showToast(
            message: Localize.current
                .autoStopTrackingDueLowBattery(batteryLevel * 100));
      }
    }
    if (HiveSettingsDB.autoStopTrackingEnabled &&
        _hasAutoStoppedDueLowBatt == true &&
        (batteryLevel > 0.2 && isCharging)) {
      _hasAutoStoppedDueLowBatt = false;
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
            const Duration(milliseconds: defaultLocationUpdateInterval - 50) &&
        !forceUpdate) {
      //print('${DateTime.now().toIso8601String()} lower $defaultLocationUpdateInterval ms rt update');

      //avoid to much traffic
      return;
    }

    var timeDiff2 = dtNow.difference(_lastRealtimedataUpdate);
    if (timeDiff2 <
            const Duration(milliseconds: defaultRealtimeUpdateInterval - 50) &&
        _trackingType == TrackingType.noTracking &&
        !forceUpdate) {
      //print('${DateTime.now().toIso8601String()} lower $defaultRealtimeUpdateInterval ms rt update');
      return;
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
      await _getRealtimeData();
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
      if (diff > const Duration(seconds: 5)) {
        _lastKnownPoint = await getCurrentLocation();
      }
    } else {
      _lastKnownPoint ??= await getCurrentLocation();
    }
    return _lastKnownPoint;
  }

  var lock = Lock();

  ///only called if no subscription
  Future<void> _getRealtimeData() async {
    //lock.synchronized(() async {
    try {
      //update procession when no location data were sent
      var update = await RealtimeUpdate.realtimeDataUpdate();

      if (update.rpcException != null && update.rpcException is WampException) {
        BnLog.verbose(
            className: 'locationProvider',
            methodName: 'refresh realtimedata',
            text: update.rpcException.toString());
        _realUserSpeedKmh = null;
        SendToWatch.updateUserLocationData(
            UserLocationPoint.userLocationPointEmpty());
        _updateWatchData();

        if (!_isInBackground) {
          notifyListeners();
        }
        return;
      }

      _setRealtimeUpdate(update, notify: !_isInBackground);

      if (_lastKnownPoint == null) {
        _realUserSpeedKmh = null;
        if (!kIsWeb) {
          _updateWatchData();
        }
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

    /*});
        .timeout(Duration(seconds: 11))
        .catchError((error) {
          BnLog.error(
              text: 'lock failed ${error.toString()}', className: toString());
        });*/
  }

  Future<bg.Location?> getCurrentLocation() async {
    try {
      if (HiveSettingsDB.useAlternativeLocationProvider) {
        geolocator.Position position =
            await geolocator.Geolocator.getCurrentPosition(
                    locationSettings: locationSettings)
                .timeout(Duration(seconds: 3));
        _onLocation(position.convertToBGLocation());
      } else {
        return await bg.BackgroundGeolocation.getCurrentPosition(
          timeout: 2,
          maximumAge: 5000,
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        );
      }
    } catch (e) {
      BnLog.verbose(
          text: 'getNewLocation failed $e',
          methodName: 'getNewLocation',
          className: toString());
    }
    return null;
  }

  void checkUserFinishedOrEndEvent() async {
    try {
      var activeEventData = ActiveEventProvider().event;
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
      if (_lastKnownPoint == null) {
        SendToWatch.updateUserLocationData(
            UserLocationPoint.userLocationPointEmpty());
      } else {
        var userLoc = UserLocationPoint(
            latitude: _lastKnownPoint!.coords.latitude.toShortenedDouble(9),
            longitude: _lastKnownPoint!.coords.longitude.toShortenedDouble(9),
            speed:
                '${_realUserSpeedKmh != null ? _realUserSpeedKmh?.toStringAsFixed(1) : '-'} km/h');
        SendToWatch.updateUserLocationData(userLoc);
      }
      SendToWatch.setIsLocationTracking(isTracking);
      if (_realtimeUpdate != null && _realtimeUpdate!.rpcException == null) {
        SendToWatch.updateRealtimeData(_realtimeUpdate?.toJson());
      }
    } catch (e) {
      BnLog.error(text: 'Error on _updateWatchData ${e.toString()}');
    }
  }

  ///Clear all tracked points
  ///
  /// Set ODO meter to  0.0 km
  Future<bool> resetTrackPoints() async {
    try {
      _userGpxPoints.clear();
      _userSpeedPoints.clear();
      _userLatLngList.clear();
      //Triggers start location service
      var odoResetResult =
          await bg.BackgroundGeolocation.setOdometer(0.0).then((value) {
        _odometer = value.odometer;
        LocationStore.clearTrackPointStoreForDate(DateTime.now());
        notifyListeners();
      }).catchError((error) {
        BnLog.error(text: 'Reset trackPoint] ERROR: $error');
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

  Future resetOdoMeterAndRoutePoints(BuildContext context) async {
    _gpsLocationPermissionsStatus =
        await LocationPermissionDialog().getPermissionsStatus();
    var alwaysPermissionGranted =
        (_gpsLocationPermissionsStatus == LocationPermissionStatus.always);
    var whenInusePermissionGranted =
        (_gpsLocationPermissionsStatus == LocationPermissionStatus.whenInUse);
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
              '${alwaysPermissionGranted ? "" : "\n${Localize.current.onlyWhileInUse}"} \n',
          confirmBtnText: Localize.current.ok,
          cancelBtnText: Localize.current.cancel,
          onConfirmBtnTap: () async {
            if (context.mounted && context.canPop()) {
              context.pop();
            }
            await resetTrackPoints();
            notifyListeners();
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
          confirmBtnText: Localize.current.ok,
          cancelBtnText: Localize.current.cancel,
          onConfirmBtnTap: () async {
            if (!rootNavigatorKey.currentContext!.mounted &&
                rootNavigatorKey.currentContext!.canPop()) {
              return;
            }
            rootNavigatorKey.currentContext!.pop();
            await resetTrackPoints();
            notifyListeners();
          });
    }
  }

//################# Subscription
  int _maxSubscribeFails = 3;
  Timer? _subscriptionTimer;
  StreamSubscription<RealtimeUpdate?>? _realTimeDataStreamListener;
  StreamSubscription<WampConnectedState>? _wampConnectedListener;
  int _realTimeDataSubscriptionId = 0;
  WampConnectedState _lastConnectionState = WampConnectedState.disconnected;

  Future<void> startRealtimeUpdateSubscriptionIfNotTracking() async {
    if (_trackingType == TrackingType.onlyTracking) return;
    _wampConnectedListener?.cancel();
    _realTimeDataStreamListener?.cancel();
    _wampConnectedListener = null;
    _realTimeDataStreamListener = null;
    BnLog.info(
        text: 'started startRealtimeUpdateSubscriptionIfNotTracking',
        className: 'location_provider');
    _wampConnectedListener =
        WampV2().wampConnectedStreamController.stream.listen((connected) async {
      //check status change!
      if (_lastConnectionState == connected) return;
      _lastConnectionState = connected;
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
    if (rtu.rpcException == null) {
      _realtimeUpdate = rtu;
      rtUpdateFails = 0;
      _lastRealtimedataUpdate = DateTime.now();
      _eventIsRunning = rtu.eventIsActive;
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
        ActiveEventProvider().refresh(forceUpdate: true);
      }
    }

    if ((_lastRouteName != rtu.routeName ||
        _eventState != rtu.eventState ||
        _eventIsRunning != rtu.eventIsActive)) {
      _lastRouteName = rtu.routeName;
      _eventState = rtu.eventState;
      _eventIsRunning = rtu.eventIsActive;
      ActiveEventProvider().refresh(forceUpdate: true);
    }
    if (notify) {
      notifyListeners();
    }
  }

  void stopRealtimedataSubscription() {
    //print('${DateTime.now().toIso8601String()} _stopRealtimedataSubscription');
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
  //print('${DateTime.now().toIso8601String()} colorTimerProvider');
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

///Provide to signal start or stop tracking
final trackingWaitStatusProvider = Provider.autoDispose((ref) {
  return ref.watch(locationProvider.select((l) => l.trackWaitStatus));
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
  return ref.watch(locationProvider.select((l) => l.hasLocationPermissions));
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
