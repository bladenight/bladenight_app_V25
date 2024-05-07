import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location2/location2.dart' hide PermissionStatus;
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/quickalert.dart';
import 'package:universal_io/io.dart';
import 'package:vector_math/vector_math.dart' show radians;
import 'package:wakelock/wakelock.dart';

import '../app_settings/app_configuration_helper.dart';
import '../app_settings/app_constants.dart';
import '../generated/l10n.dart';
import '../helpers/device_info_helper.dart';
import '../helpers/deviceid_helper.dart';
import '../helpers/distance_converter.dart';
import '../helpers/double_helper.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/location2_to_bglocation.dart';
import '../helpers/location_permission_dialogs.dart';
import '../helpers/logger.dart';
import '../helpers/notification/notification_helper.dart';
import '../helpers/notification/toast_notification.dart';
import '../helpers/preferences_helper.dart';
import '../helpers/watch_communication_helper.dart';
import '../main.dart';
import '../models/event.dart';
import '../models/location.dart';
import '../models/realtime_update.dart';
import '../models/route.dart';
import '../models/user_trackpoint.dart';
import '../wamp/wamp_v2.dart';
import 'active_event_provider.dart';
import 'realtime_data_provider.dart';
import 'rest_api/onsite_state_provider.dart';

///[LocationProvider] gets actual procession of Bladenight
///when tracking is active is result included users position and friends
///is tracking inactive result contains only head,tail and route data
class LocationProvider with ChangeNotifier {
  static final LocationProvider instance = LocationProvider._();

  LocationProvider._() {
    init();
  }

  bg.State? _state;
  StreamSubscription? _locationSubscription;
  bool _stoppedAfterMaxTime = false;
  bool locationRequested = false;
  bool _isInBackground = false;

  static DateTime _lastUpdate = DateTime(2022, 1, 1, 0, 0, 0);
  static DateTime _lastLocationRealtimeRequest = DateTime(2022, 1, 1, 0, 0, 0);
  static DateTime _lastRefreshRequest = DateTime(2022, 1, 1, 0, 0, 0);

  DateTime? _userReachedFinishDateTime, _startedTrackingTime;
  Timer? _updateTimer, _saveLocationsTimer;

  bool _isMoving = false;
  String _lastRouteName = '';
  EventStatus? _eventState;

  DateTime get lastUpdate => _lastUpdate;

  bool _eventIsActive = false;

  bool get eventIsActive => _eventIsActive;

  bool get isMoving => _isMoving;

  bool _networkConnected = true;

  bool get networkConnected => _networkConnected;

  bool get isTracking => _isTracking;
  bool _isTracking = false;

  bool _gpsGranted = false;

  bool _hasLocationPermissions = false;

  bool get hasLocationPermissions => _hasLocationPermissions;

  bool get gpsGranted => _gpsGranted;

  LocationPermissionStatus _gpsLocationPermissionsStatus =
      LocationPermissionStatus.unknown;

  LocationPermissionStatus get gpsLocationPermissionsStatus =>
      _gpsLocationPermissionsStatus;

  ///flag for user is participant or not
  bool get userIsParticipant => _userIsParticipant;

  bool _userIsParticipant = false;

  bool _autoStop = false;

  bool get autoStop => _autoStop;

  bool _trackingWasActive = false;

  ///Tracking was active last time where app was running
  bool get trackingWasActive => _trackingWasActive;

  LatLng? _userLatLng;

  ///Users position LatLng
  LatLng? get userLatLng => _userLatLng;

  double? _realUserSpeedKmh;

  ///Userspeed in km/h
  double? get realUserSpeedKmh => _realUserSpeedKmh;

  ///odometer in km/h
  double get odometer => _odometer;
  double _odometer = 0.0;

  RealtimeUpdate? _realtimeUpdate;

  RealtimeUpdate? get realtimeUpdate => _realtimeUpdate;

  bool _isHead = false;
  bool _isTail = false;
  bg.Location? _lastKnownPoint;

  bool get isHead => _isHead;

  bool get isTail => _isTail;

  List<LatLng> get userLatLongs => _userLatLongs;
  List<LatLng> _userLatLongs = <LatLng>[];

  List<UserTrackPoint> get userTrackingPoints => _userTrackingPoints;

  final _userTrackingPoints = <UserTrackPoint>[];

  //Stream controllers private
  final _userPositionStreamController =
      StreamController<bg.Location>.broadcast();
  final _trainHeadStreamController = StreamController<LatLng>.broadcast();
  final _userTrackPointsStreamController =
      StreamController<UserTrackPoint>.broadcast();
  final _userLocationMarkerPositionStreamController =
      StreamController<LocationMarkerPosition>.broadcast();
  final _userLocationMarkerHeadingStreamController =
      StreamController<LocationMarkerHeading>.broadcast();

  //Stream controllers public
  Stream<bg.Location> get userBgLocationStream =>
      _userPositionStreamController.stream;

  Stream<LatLng> get trainHeadUpdateStream => _trainHeadStreamController.stream;

  Stream<UserTrackPoint> get userTrackPointsControllerStream =>
      _userTrackPointsStreamController.stream;

  Stream<LocationMarkerPosition> get userLocationMarkerPositionStream =>
      _userLocationMarkerPositionStreamController.stream;

  Stream<LocationMarkerHeading> get userLocationMarkerHeadingStream =>
      _userLocationMarkerHeadingStreamController.stream;

  StreamSubscription<bool>? _wampConnectedSubscription;

  @override
  void dispose() {
    LocationStore.saveUserTrackPointList(_userTrackingPoints);
    _userTrackPointsStreamController.close();
    _trainHeadStreamController.close();
    _userPositionStreamController.close();
    _wampConnectedSubscription?.cancel();
    _userLocationMarkerPositionStreamController.close();
    _userLocationMarkerHeadingStreamController.close();
    super.dispose();
  }

  void init() async {
    _wampConnectedSubscription =
        WampV2.instance.wampConnectedStreamController.stream.listen((event) {
      _networkConnected = event;
      if (event) {
        refresh(forceUpdate: true);
      }
    });
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
      setGeoFence();
      await startStopGeoFencing();
    }

    _autoStop = await PreferencesHelper.getAutoStopFromPrefs();

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
    if (!kIsWeb) {
      BnLog.trace(
          className: 'locationProvider',
          methodName: 'init',
          text: 'check _trackingWasActive');
    }
    if (_trackingWasActive &&
        !_isTracking &&
        ProviderContainer().read(activeEventProvider).status ==
            EventStatus.confirmed) {
      //restart tracking on reopen
      BnLog.info(
          className: 'locationProvider',
          methodName: 'init',
          text: 'restarting tracking');
      HiveSettingsDB.setUserIsParticipant(userIsParticipant);
      var state = await startTracking(_userIsParticipant);
      if (state) {
        showToast(message: Localize.current.trackingRestarted);
      }
    } else {
      startStopGeoFencing();
    }
    notifyListeners();
    if (!kIsWeb) {
      BnLog.trace(
          className: 'locationProvider',
          methodName: 'init',
          text: 'init finished');
    }
  }

  void setToBackground(bool value) {
    _isInBackground = value;
  }

  ///Initializes BackgroundLocationPlugin
  Future<bg.State?> _startBackgroundGeolocation() async {
    try {
      bg.BackgroundGeolocation.onLocation(_onLocation, _onLocationError);
      bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
      bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
      bg.BackgroundGeolocation.onHeartbeat(_onHeartBeat);
      bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
      bg.BackgroundGeolocation.onConnectivityChange(_onConnectionChange);
      bg.BackgroundGeolocation.onGeofence(_onGeoFence);

      var isMotionDetectionDisabled = HiveSettingsDB.isMotionDetectionDisabled;
      var bgLogLevel = HiveSettingsDB.getBackgroundLocationLogLevel;

      if (Platform.isAndroid) {
        return bg.BackgroundGeolocation.ready(bg.Config(
          locationAuthorizationRequest: 'Any',
          reset: true,
          debug: false,
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_NAVIGATION,
          allowIdenticalLocations: true,
          distanceFilter: 0,
          heartbeatInterval: 60,
          disableMotionActivityUpdates: isMotionDetectionDisabled,
          logMaxDays: 1,
          persistMode: bg.Config.PERSIST_MODE_NONE,
          stopAfterElapsedMinutes: 3600,
          preventSuspend: true,
          stopOnTerminate: true,
          startOnBoot: false,
          logLevel: bgLogLevel,
          //bg.Config.LOG_LEVEL_VERBOSE,//
          locationUpdateInterval: 1000,
          stopTimeout: 1000,
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
          debug: false,
          //ALL
          logLevel: bgLogLevel,
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_NAVIGATION,
          distanceFilter: 0.5,
          disableMotionActivityUpdates: isMotionDetectionDisabled,
          heartbeatInterval: 60,
          stopDetectionDelay: 5000,
          persistMode: bg.Config.PERSIST_MODE_NONE,
          // Activity Recognition
          activityRecognitionInterval: 3000,
          allowIdenticalLocations: true,
          showsBackgroundLocationIndicator: true,
          preventSuspend: true,
          locationUpdateInterval: 1000,
          stopTimeout: 1000,
          // <-- a very long stopTimeout
          disableStopDetection: true,
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
      if (!kIsWeb) {
        BnLog.error(text: '_startBackgroundGeolocation', exception: error);
      }
    }
    if (!kIsWeb) {
      BnLog.warning(
          text: 'No Valid device for bg.BackgroundGeolocation',
          className: toString(),
          methodName: '_startBackgroundGeolocation');
    }
    return null;
  }

  void _onLocation(bg.Location location) {
    //BnLog.trace(text: '_onLocation $location');
    updateUserLocation(location);
    sendLocation(location);
  }

  ///Update user location and track points list
  void updateUserLocation(bg.Location location) {
    _userPositionStreamController.add(location);
    _userLocationMarkerPositionStreamController.sink.add(LocationMarkerPosition(
        latitude: location.coords.latitude,
        longitude: location.coords.longitude,
        accuracy: location.coords.accuracy));
    _userLocationMarkerHeadingStreamController.sink.add(LocationMarkerHeading(
        heading: radians(location.coords.heading),
        accuracy: location.coords.accuracy));
    if (_lastKnownPoint != null) {
      var ts = DateTime.parse(_lastKnownPoint!.timestamp).toUtc();
      var diff = DateTime.now().toUtc().difference(ts);
      if (diff < const Duration(seconds: 1)) {
        return;
      }
    }

    var userLatLng =
        LatLng(location.coords.latitude, location.coords.longitude);

    _userLatLng = userLatLng;
    _realUserSpeedKmh =
        location.coords.speed < 0 ? 0.0 : location.coords.speed * 3.6;
    _odometer = location.odometer / 1000;
    var userTrackingPoint = UserTrackPoint(
        location.coords.latitude,
        location.coords.longitude,
        _realUserSpeedKmh!,
        location.coords.heading,
        location.coords.altitude,
        odometer,
        DateTime.now());
    if (_userTrackingPoints.isNotEmpty) {
      var userLastPoint = _userTrackingPoints.last;
      var lon = location.coords.longitude;
      var lat = location.coords.latitude;
      if (userLastPoint.latitude != lat && userLastPoint.longitude != lon) {
        _userTrackingPoints.add(userTrackingPoint);
      }
    } else {
      _userTrackingPoints.add(userTrackingPoint);
    }
    _lastKnownPoint = location;
    SendToWatch.setUserSpeed('${_realUserSpeedKmh!.toStringAsFixed(1)} km/h');
    int maxSize = 250;
    if (_userTrackingPoints.length > maxSize) {
      var smallTrackPointList = <LatLng>[];
      var divider = _userTrackingPoints.length ~/ maxSize;

      for (var counter = 0; counter < _userTrackingPoints.length - divider;) {
        smallTrackPointList.add(LatLng(_userTrackingPoints[counter].latitude,
            _userTrackingPoints[counter].longitude));
        counter = counter + divider.toInt();
      }
      //avoid jumping of tracking if list is large
      var last5 = _userTrackingPoints.reversed.take(maxSize ~/ 10);
      for (var last in last5) {
        smallTrackPointList.add(LatLng(last.latitude, last.longitude));
      }
      _userLatLongs = smallTrackPointList;
    } else {
      _userLatLongs.add(userLatLng);
    }
    if (!_isInBackground) {
      notifyListeners();
    }
  }

  void _onLocationError(bg.LocationError error) {
    if (!kIsWeb) BnLog.trace(text: 'Location error reason:$error');
    if (_lastKnownPoint != null) {
      //sendLocation(_lastKnownPoint!);
    }
  }

  void _onMotionChange(bg.Location location) {
    if (!kIsWeb) BnLog.trace(text: 'OnMotionChange send location');
    //sendLocation(location); //dont send
  }

  void _onActivityChange(bg.ActivityChangeEvent event) {
    if (!kIsWeb) BnLog.trace(text: 'On ActivityChangeEvent $event');
    //_subToUpdates();
  }

  void _onHeartBeat(bg.HeartbeatEvent event) {
    if (!kIsWeb) BnLog.trace(text: 'On Heartbeat  $event');
    _getHeartBeatLocation();
  }

  _onConnectionChange(bg.ConnectivityChangeEvent event) {
    if (!kIsWeb) BnLog.debug(text: 'On ConnectivityChange  $event');
    _networkConnected = event.connected;
  }

  void _getHeartBeatLocation() async {
    try {
      if (!kIsWeb) {
        BnLog.trace(
          className: toString(),
          methodName: '_getHeartBeatLocation',
          text: 'started',
        );
      }
      bg.Location? newLocation;
      newLocation = await bg.BackgroundGeolocation.getCurrentPosition(
        timeout: 2,
        maximumAge: 60000,
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_NAVIGATION,
        samples: 2, // How many location samples to attempt.
      );
      //triggers onLocation
      if (!kIsWeb) {
        BnLog.trace(
          className: toString(),
          methodName: '_getHeartBeatLocation',
          text: '_subUpdates sent new location $newLocation',
        );
      }
      return;
    } catch (e) {
      if (!kIsWeb) {
        BnLog.warning(
            className: toString(),
            methodName: '_subToUpdates',
            text: '_subUpdates Failed:',
            exception: e);
      }
    }
    refresh();
  }

  _onProviderChange(bg.ProviderChangeEvent event) {
    if (!kIsWeb) BnLog.info(text: 'onProviderChangeEvent  $event');
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
    if (HiveSettingsDB.isBladeGuard && HiveSettingsDB.onsiteGeoFencingActive) {
      BnLog.info(text: '[geofence] ${event.identifier}, ${event.action}');
      ProviderContainer()
          .read(bgIsOnSiteProvider.notifier)
          .setOnSiteState(true);
      NotificationHelper()
          .showString(id: 3234, text: 'Bladguard Geofence Event vor Ort ');
    }
  }

  void toggleAutoStop() async {
    _autoStop = !_autoStop;
    notifyListeners();
    PreferencesHelper.saveAutoStopToPrefs(_autoStop);
  }

  Future<bool> stopTracking() async {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _isTracking = false;
    setUpdateTimer(false);
    Wakelock.disable();
    if (HiveSettingsDB.useAlternativeLocationProvider) {
      _realUserSpeedKmh = null;
      _userLatLng = null;
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
      LocationStore.saveUserTrackPointList(_userTrackingPoints);
    }
    bg.BackgroundGeolocation.stop().then((bg.State state) async {
      BnLog.info(
          text: 'location tracking stopped ${state.enabled}',
          className: 'location_provider',
          methodName: '_stopTracking');
      _realUserSpeedKmh = null;
      _userLatLng = null;
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
      LocationStore.saveUserTrackPointList(_userTrackingPoints);
      notifyListeners();
      await startStopGeoFencing();
    }).catchError((error) {
      BnLog.error(text: 'Stopping location error: $error');
    });
    notifyListeners();
    return _isTracking;
  }

  ///Starts or stops geofencing
  Future<void> startStopGeoFencing() async {
    if (!HiveSettingsDB.isBladeGuard ||
        !HiveSettingsDB.onsiteGeoFencingActive) {
      if (!_isTracking) {
        bg.BackgroundGeolocation.stop().catchError((error) {
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

  void setGeoFence() {
    if (!HiveSettingsDB.bgSettingVisible ||
        !HiveSettingsDB.onsiteGeoFencingActive) return;
    bg.BackgroundGeolocation.addGeofences([
      bg.Geofence(
          identifier: 'startPoint',
          radius: 200,
          latitude: defaultLatitude,
          longitude: defaultAppLongitude,
          notifyOnEntry: true,
          notifyOnExit: false,
          extras: {'routeId': 1234}),
      bg.Geofence(
          identifier: 'test',
          radius: 200,
          latitude: 52.521900,
          longitude: 8.372809,
          notifyOnEntry: true,
          notifyOnExit: true,
          extras: {'routeId': 4332})
    ]).then((bool success) {
      BnLog.info(text: '[addGeofence] success');
    }).catchError((dynamic error) {
      BnLog.warning(text: '[addGeofence] FAILURE: $error');
    });
  }

  Future<bool> startTracking(bool userIsParticipant) async {
    //if (kIsWeb) return false;
    _userIsParticipant = userIsParticipant;
    _isHead = HiveSettingsDB.specialCodeValue == 1 ||
        HiveSettingsDB.specialCodeValue == 5;
    _isTail = HiveSettingsDB.specialCodeValue == 2 ||
        HiveSettingsDB.specialCodeValue == 6;

    if (!kIsWeb && HiveSettingsDB.wakeLockEnabled) {
      Wakelock.enable();
    }
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
      if (Platform.isAndroid && await DeviceHelper.isAndroidGreaterVNine()) {
        await LocationPermissionDialog().showMotionSensorProminentDisclosure();
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

      await LocationPermissionDialog().requestAndOpenAppSettings();
      return false;
    }

    _userReachedFinishDateTime == null;
    if (_userTrackingPoints.length <= 1 &&
        MapSettings.showOwnTrack &&
        LocationStore.storedDataAreFromToday) {
      //reload data
      _userTrackingPoints.addAll(LocationStore.userTrackPointsList);
      _userLatLongs.clear();
      for (var tp in _userTrackingPoints) {
        _userLatLongs.add(LatLng(tp.latitude, tp.longitude));
      }
    }

    if (kIsWeb || HiveSettingsDB.useAlternativeLocationProvider) {
      if (kIsWeb) {
        HiveSettingsDB.setUseAlternativeLocationProvider(true);
      }
      BnLog.info(
          text: 'alternative location tracking started',
          className: 'location_provider',
          methodName: '_startTracking');
      if (kIsWeb) {
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
      }
      _listenLocationWithAlternativePackage();
      _isTracking = true;
      setUpdateTimer(true);
      _startedTrackingTime = DateTime.now();
      _stoppedAfterMaxTime = false;
      ProviderContainer()
          .read(activeEventProvider.notifier)
          .refresh(forceUpdate: true);
      notifyListeners();
      _subToUpdates();
      SendToWatch.setIsLocationTracking(_isTracking);
      HiveSettingsDB.setTrackingActive(_isTracking);
    } else {
      await bg.BackgroundGeolocation.start().then((bg.State bgGeoLocState) {
        if (!kIsWeb) {
          BnLog.info(
              text: 'location tracking started',
              className: 'location_provider',
              methodName: '_startTracking');
        }

        _startedTrackingTime = DateTime.now();
        _stoppedAfterMaxTime = false;
        _isTracking = bgGeoLocState.enabled;
        setUpdateTimer(true);
        ProviderContainer()
            .read(activeEventProvider.notifier)
            .refresh(forceUpdate: true);
        notifyListeners();
        _subToUpdates();
        HiveSettingsDB.setTrackingActive(_isTracking);
        SendToWatch.setIsLocationTracking(_isTracking);
      }).catchError((error) {
        BnLog.error(text: 'LocStarting ERROR: $error');
        HiveSettingsDB.setTrackingActive(false);
        _isTracking = false;
        setUpdateTimer(false);
        SendToWatch.setIsLocationTracking(false);
        notifyListeners();
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
    return _isTracking;
  }

  ///set [enabled] = true  or reset [enabled] = false location updates if tracking is enabled
  void startSaveLocationsUpdateTimer(bool enabled) {
    if (!kIsWeb) {
      BnLog.trace(text: 'init startSaveLocationsUpdateTimer to $enabled');
    }
    _saveLocationsTimer?.cancel();
    if (enabled) {
      _saveLocationsTimer = Timer.periodic(
        const Duration(minutes: 5),
        (timer) {
          if (!_isTracking) {
            return;
          }
          LocationStore.saveUserTrackPointList(_userTrackingPoints);
        },
      );
    } else {
      _updateTimer?.cancel();
      _updateTimer = null;
    }
  }

  ///set [enabled] = true  or reset [enabled] = false location updates if tracking is enabled
  void setUpdateTimer(bool enabled) {
    if (!kIsWeb) {
      BnLog.trace(text: 'init setLocationTimer to $enabled');
    }
    _updateTimer?.cancel();
    _saveLocationsTimer?.cancel();
    if (enabled) {
      startSaveLocationsUpdateTimer(true);
      _updateTimer = Timer.periodic(
        //realtimeUpdateProvider reads data on send-location -
        //so it must not updated all 10 secs
        const Duration(seconds: defaultLocationUpdateInterval),
        (timer) {
          int lastUpdate = DateTime.now().difference(_lastUpdate).inSeconds;
          if (kDebugMode) {
            print(
                '${DateTime.now().toIso8601String()} update timer internal  lastupdate ${lastUpdate}s ago');
          }
          if (lastUpdate >= defaultLocationUpdateInterval) {
            if (!kIsWeb) {
              BnLog.trace(text: 'setUpdateTimer Refresh');
            }
            refresh();
          }
        },
      );
    } else {
      _updateTimer = null;
      _saveLocationsTimer = null;
    }
  }

  Future<void> _listenLocationWithAlternativePackage() async {
    setLocationSettings(
        rationaleMessageForGPSRequest:
            Localize.current.requestAlwaysPermissionTitle,
        rationaleMessageForPermissionRequest:
            Localize.current.enableAlwaysLocationInfotext,
        askForPermission: true);
    _locationSubscription =
        onLocationChanged(inBackground: true).handleError((dynamic err) {
      if (err is PlatformException) {
        //_onLocationError(bg.LocationError(err));
        if (_lastKnownPoint != null) {
          sendLocation(_lastKnownPoint!);
        }
      }
      _locationSubscription?.cancel();
      _locationSubscription = null;
      _isTracking = false;
      notifyListeners();
    }).listen((LocationData currentLocation) async {
      if (currentLocation.longitude == null ||
          currentLocation.latitude == null) {
        return;
      }

      var newLoc = currentLocation.convertToBGLocation();
      _onLocation(newLoc);

      await updateBackgroundNotification(
        title: Localize.current.bgNotificationTitle,
        subtitle: Localize.current.bgNotificationText,
        onTapBringToFront: true,
      );
    });
  }

  ///get location and send to server
  Future<bg.Location?> _subToUpdates() async {
    var timeDiff = DateTime.now().difference(_lastUpdate);
    if (timeDiff < const Duration(seconds: defaultSendNewLocationDelay)) {
      return _lastKnownPoint;
    }
    try {
      if (!kIsWeb) {
        BnLog.trace(
          className: toString(),
          methodName: '_subToUpdates',
          text: 'started',
        );
      }
      bg.Location newLocation;
      if (HiveSettingsDB.useAlternativeLocationProvider) {
        return _lastKnownPoint;
        //getLocation ignored if location is running
      } else {
        if (Platform.isAndroid) {
          return _lastKnownPoint;
        }
        newLocation = await bg.BackgroundGeolocation.getCurrentPosition(
          timeout: 3,
          maximumAge: 60000,
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_NAVIGATION,
          samples: 1, // How many location samples to attempt.
        );
        _lastKnownPoint = newLocation;
      }
    } catch (e) {
      BnLog.warning(
          className: toString(),
          methodName: '_subToUpdates',
          text: '_subUpdates Failed:',
          exception: e);
    }

    BnLog.trace(
        className: toString(),
        methodName: '_subToUpdates',
        text: '_subUpdates OK:');

    if (_lastKnownPoint != null) {
      var ts = DateTime.parse(_lastKnownPoint!.timestamp);
      var diff = DateTime.now().toUtc().difference(ts.toUtc());
      //set lastKnownPoint to null after x min
      if (diff > const Duration(minutes: 5)) {
        _lastKnownPoint = null;
        return null;
      }
      sendLocation(_lastKnownPoint!);
      return _lastKnownPoint;
    }
    return null;
  }

  void sendLocation(bg.Location location) async {
    if (!_isTracking) return;
    RealtimeUpdate? update;
    var dtNow = DateTime.now();
    var timeDiff = dtNow.difference(_lastLocationRealtimeRequest);
    if (timeDiff < const Duration(seconds: defaultSendNewLocationDelay)) {
      return;
    }
    _lastLocationRealtimeRequest = dtNow;

    if (!_networkConnected) {
      if (!kIsWeb) {
        BnLog.trace(
          className: toString(),
          methodName: 'sendLocation',
          text: 'no network ignore send location',
        );
      }
      return;
    }
    //only result of this message contains friend position -
    //requested [RealTimeUpdates] with
    update = await RealtimeUpdate.wampUpdate(MapperContainer.globals.toMap(
      LocationInfo(
          //location creation timestamp
          locationTimeStamp:
              DateTime.now().millisecondsSinceEpoch - location.age,
          //6 digits => 1 m location accuracy
          coords: LatLng(location.coords.latitude.toShortenedDouble(6),
              location.coords.longitude.toShortenedDouble(6)),
          deviceId: DeviceId.appId,
          isParticipating: _userIsParticipant,
          specialFunction: HiveSettingsDB.wantSeeFullOfProcession
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
    HiveSettingsDB.setOdometerValue(odometer);

    _lastUpdate = DateTime.now();
    _realtimeUpdate = update;
    if (!kIsWeb) {
      BnLog.trace(
          className: 'locationProvider',
          methodName: 'sendLocation',
          text: 'sent loc update with result  $update');
    }
    if (realtimeUpdate != null &&
        (_lastRouteName != _realtimeUpdate?.routeName ||
            _eventState != _realtimeUpdate?.eventState ||
            _eventIsActive != _realtimeUpdate?.eventIsActive)) {
      _lastRouteName = _realtimeUpdate!.routeName;
      _eventState = _realtimeUpdate!.eventState;
      _eventIsActive = _realtimeUpdate!.eventIsActive;
      ProviderContainer()
          .read(activeEventProvider.notifier)
          .refresh(forceUpdate: true);
    }
    if (_realtimeUpdate != null && _realtimeUpdate?.friends != null) {
      var friendList =
          _realtimeUpdate?.updateMapPointFriends(_realtimeUpdate!.friends);
      if (friendList != null) {
        var friends = friendList.where((x) => x.specialValue == 0).toList();
        var friendListAsJson = MapperContainer.globals.toJson(friends);
        SendToWatch.updateFriends(friendListAsJson);
      }
    }

    if (_realtimeUpdate != null &&
        _realtimeUpdate?.head != null &&
        _realtimeUpdate?.head.longitude != 0.0) {
      double lat = _realtimeUpdate?.head.latitude ?? defaultLatitude;
      double lon = _realtimeUpdate?.head.longitude ?? defaultLongitude;

      _trainHeadStreamController.add(LatLng(lat, lon));
    }
    if (!kIsWeb) _updateWatchData();
    checkUserFinishedOrEndEvent();
    if (!_isInBackground) {
      BnLog.debug(text: 'location notify');
      notifyListeners();
    }
  }

  int _maxFails = 3;

  ///Refresh [RealTimeData] when location has no data for 4500ms with tracking
  ///15 s without tracking
  ///[forceUpdate]-Mode to update after resume  default value = false
  ///necessary after app state switching in viewer mode
  Future<void> refresh({bool forceUpdate = false}) async {
    try {
      BnLog.trace(
          className: 'locationProvider',
          methodName: 'refresh',
          text: 'start refresh force $forceUpdate');
      var dtNow = DateTime.now();
      //avoid async re-trigger
      var timeDiff = dtNow.difference(_lastRefreshRequest);
      if (timeDiff < const Duration(milliseconds: 4500)) {
        return;
      }
      _lastRefreshRequest = dtNow;

      bg.Location? locData;
      /*  var diffSec = DateTime.now().difference(_lastUpdate).inMilliseconds +
          1000; //most time  14 seconds because timer and refresh are async
      if (diffSec >= defaultLocationUpdateInterval * 1000 || forceUpdate) {*/

      if (_isTracking) {
        locData = await _subToUpdates();
      } else {
        _realUserSpeedKmh = null;
      }
      if (locData == null && _networkConnected) {
        //update procession when no location data were sent
        var update = await RealtimeUpdate.wampUpdate();
        if (!kIsWeb) {
          BnLog.trace(
              className: 'locationProvider',
              methodName: 'refresh',
              text: 'send refresh force $forceUpdate');
        }
        /* if (isTesting) {
            update = Mapper.fromJson<RealtimeUpdate>(
                '{"hea":{"pos":17281,"spd":20,"eta":440010,"ior":true,"iip":true,"lat":48.12526909151467,"lon":11.549398275972768,"acc":0},"tai":{"pos":16663,"spd":0,"eta":490010,"ior":true,"iip":true,"lat":48.12016726012295,"lon":11.54839572144946,"acc":0},"fri":{"fri":{"9":{"req":0,"fid":0,"onl":false,"pos":16865,"spd":13,"eta":720259,"ior":true,"iip":true,"lat":48.1219677066427,"lon":11.548752403193944,"acc":0}}},"up":{"pos":16963,"spd":0,"eta":470010,"ior":true,"iip":false,"lat":0.0,"lon":0.0,"acc":0},"rle":18452.0,"rna":"Ost","ust":4,"usr":4}');
          }*/

        if (update.rpcException != null) {
          if (!kIsWeb) {
            BnLog.error(
                className: 'locationProvider',
                methodName: 'refresh',
                text: update.rpcException.toString());
          }
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
        _realtimeUpdate = update;
      }

      _lastUpdate = dtNow;
      _maxFails = 3;
      if (_realtimeUpdate != null &&
          _realtimeUpdate?.head != null &&
          _realtimeUpdate?.head.longitude != 0.0) {
        double lat = _realtimeUpdate?.head.latitude ?? defaultLatitude;
        double lon = _realtimeUpdate?.head.longitude ?? defaultLongitude;

        _trainHeadStreamController.add(LatLng(lat, lon));
        if (_lastRouteName != _realtimeUpdate?.routeName ||
            _eventState != _realtimeUpdate?.eventState) {
          _lastRouteName = _realtimeUpdate!.routeName;
          _eventState = _realtimeUpdate!.eventState;
          ProviderContainer()
              .read(activeEventProvider.notifier)
              .refresh(forceUpdate: true);
        }
      }
      if (_lastKnownPoint == null) {
        _realUserSpeedKmh = null;
        SendToWatch.setUserSpeed('- km/h');
        if (!kIsWeb) _updateWatchData();
      }
      if (!_isInBackground) {
        BnLog.trace(text: 'Refresh forces map rebuild');
        notifyListeners();
      }
    } catch (e) {
      if (!kIsWeb) {
        BnLog.error(
            className: 'locationProvider',
            methodName: 'refresh',
            text: e.toString());
      }
    }
  }

  void checkUserFinishedOrEndEvent() async {
    try {
      var activeEventData = ProviderContainer().read(activeEventProvider);
      //Check for 'user reached finish' event and inform user
      Duration eventRuntime =
          DateTime.now().toUtc().difference(activeEventData.startDate.toUtc());
      int userPos = _realtimeUpdate?.user.position ?? 0;
      double runLength = _realtimeUpdate?.runningLength ?? double.maxFinite;

      if (userPos == 0 || runLength == 0) {
        return;
      }

      if (userPos.toDouble() >= runLength - 50 && eventRuntime.inMinutes > 60) {
        //inform user at end of event
        //subtract -50m because finish is in the middle of BavariaPark, not at the end of track point
        //check event is running for a minimum interval to avoid stop of auto tracking
        if (_userReachedFinishDateTime == null) {
          _userReachedFinishDateTime = DateTime.now();
          if (autoStop) {
            NotificationHelper().showString(
                id: DateTime.now().hashCode,
                text: Localize.current.finishReachedStopedTracking);
            QuickAlert.show(
                context: navigatorKey.currentContext!,
                type: QuickAlertType.warning,
                title: Localize.current.finishReachedTitle,
                text: Localize.current.finishReachedStopedTracking);
            BnLog.info(
                className: 'locationProvider',
                methodName: 'checkUserFinishedOrEndEvent',
                text: 'User reached finish - auto stop');
            stopTracking();
          } else {
            NotificationHelper().showString(
                id: DateTime.now().hashCode,
                text: Localize
                    .current.finishReachedtargetReachedPleaseStopTracking);
            QuickAlert.show(
                context: navigatorKey.currentContext!,
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
      var maxDuration = activeEventData.duration.inMinutes;
      if (maxDuration == 0) return;
      if ((activeEventData.status == EventStatus.finished ||
              eventRuntime.inMinutes > maxDuration) &&
          _isTracking &&
          _autoStop &&
          !_stoppedAfterMaxTime) {
        _stoppedAfterMaxTime = true;
        _userReachedFinishDateTime == null;
        stopTracking();

        //Alert for overtime or finish event
        if (activeEventData.status == EventStatus.finished) {
          if (_isInBackground) {
            NotificationHelper().showString(
                id: DateTime.now().hashCode,
                text: Localize.current.finishStopTrackingEventOver);
          } else {
            QuickAlert.show(
                context: navigatorKey.currentContext!,
                type: QuickAlertType.info,
                title: Localize.current.finishForceStopEventOverTitle,
                text: Localize.current.finishStopTrackingEventOver);
          }
        } else {
          if (_isInBackground) {
            NotificationHelper().showString(
                id: DateTime.now().hashCode,
                text: Localize.current.finishStopTrackingTimeout(maxDuration));
          } else {
            QuickAlert.show(
                context: navigatorKey.currentContext!,
                type: QuickAlertType.warning,
                title: Localize.current.finishForceStopTimeoutTitle,
                text: Localize.current.finishStopTrackingTimeout(maxDuration));
          }
        }
        if (!kIsWeb) {
          BnLog.info(
              className: 'locationProvider',
              methodName: 'checkUserFinishedOrEndEvent',
              text:
                  'forced tracking stop finished${activeEventData.status == EventStatus.finished}');
        }
      } else if (eventRuntime.inMinutes > maxDuration &&
          _isTracking &&
          !_stoppedAfterMaxTime) {
        _stoppedAfterMaxTime = true;
        if (_isInBackground) {
          NotificationHelper().showString(
              id: DateTime.now().hashCode,
              text: Localize.current.stopTrackingTimeOut(maxDuration));
        } else {
          QuickAlert.show(
              context: navigatorKey.currentContext!,
              type: QuickAlertType.warning,
              title: Localize.current.timeOutDurationExceedTitle,
              text: Localize.current.stopTrackingTimeOut(maxDuration));
        }
        if (!kIsWeb) {
          BnLog.info(
              className: 'locationProvider',
              methodName: 'checkUserFinishedOrEndEvent',
              text: 'remember tracking stop');
        }
      }
    } catch (e) {
      if (!kIsWeb) {
        BnLog.error(
          text: e.toString(),
          className: 'locationProvider',
          methodName: 'checkUserFinishedOrEndEvent',
        );
      }
    }
  }

  void _updateWatchData() {
    try {
      if (kIsWeb) return;
      SendToWatch.setIsLocationTracking(_isTracking);
      if (_realtimeUpdate != null) {
        SendToWatch.updateRealtimeData(_realtimeUpdate?.toJson());
      }
    } catch (e) {
      if (!kIsWeb) {
        BnLog.error(text: 'Error on _updateWatchData ${e.toString()}');
      }
    }
  }

  ///Clear all tracked points
  Future<bool> resetTrackPoints() async {
    try {
      if (HiveSettingsDB.useAlternativeLocationProvider) {
        _userTrackingPoints.clear();
        _userLatLongs.clear();
        LocationStore.clearTrackPointStore();
        return true;
      }
      //Triggers start location service
      var odoResetResult =
          await bg.BackgroundGeolocation.setOdometer(0.0).then((value) {
        _odometer = value.odometer;
      }).catchError((error) {
        if (!kIsWeb) {
          BnLog.error(text: '[resetOdometer] ERROR: $error');
        }
        return null;
      });

      if (!_isTracking) {
        //#issue 1102
        var bgGeoLocState = await bg.BackgroundGeolocation.stop();
        _isTracking = bgGeoLocState.enabled;
        notifyListeners();
      }
      _userTrackingPoints.clear();
      _userLatLongs.clear();
      LocationStore.clearTrackPointStore();
      return odoResetResult == null ? false : true;
    } catch (e) {
      if (!kIsWeb) {
        BnLog.error(
            text: 'Error on resetTrackPoints ${e.toString()}', exception: e);
      }
      return false;
    }
  }

  void refreshRealtimeData() {
    int lastUpdate = DateTime.now()
        .difference(LocationProvider.instance.lastUpdate)
        .inMilliseconds;
    if (_isTracking || lastUpdate < defaultRealtimeUpdateInterval) {
      return;
    }
    if (!kIsWeb) {
      BnLog.trace(
          className: toString(),
          methodName: '_updateTime_periodic',
          text: 'updating because there are no new location data');
    }
    refresh();
  }

  void getLastRealtimeData() {
    if (_realtimeUpdate != null) {
      _updateWatchData();
    }
    int lastUpdate = DateTime.now()
        .difference(LocationProvider.instance.lastUpdate)
        .inMilliseconds;
    if (_isTracking || lastUpdate < defaultRealtimeUpdateInterval) {
      return;
    }
    if (!kIsWeb) {
      BnLog.trace(
          className: toString(),
          methodName: 'getLastRealtimeData',
          text: 'updating because there are no new location data');
    }
    refresh();
  }

  Future resetOdoMeterAndRoutePoints(BuildContext context) async {
    var alwaysPermissionGranted =
        (gpsLocationPermissionsStatus == LocationPermissionStatus.always);
    var whenInusePermissionGranted =
        (gpsLocationPermissionsStatus == LocationPermissionStatus.whenInUse);
    if (alwaysPermissionGranted || whenInusePermissionGranted) {
      QuickAlert.show(
          context: navigatorKey.currentContext!,
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
            if (!context.mounted) return;
            Navigator.of(context).pop();
          });
    }
  }
}

//Providers

final locationProvider =
    ChangeNotifierProvider((ref) => LocationProvider.instance);

final isAutoStopProvider = Provider((ref) {
  return ref.watch(locationProvider.select((l) => l.autoStop));
});

final locationLastUpdateProvider = Provider((ref) {
  return ref.watch(locationProvider.select((l) => l.lastUpdate));
});

///true when location is ready
final isMovingProvider = Provider((ref) {
  return ref.watch(locationProvider.select((l) => l.isMoving));
});

final odometerProvider = Provider((ref) {
  return ref.watch(locationProvider.select((l) => l.odometer));
});

final realUserSpeedProvider = Provider((ref) {
  return ref.watch(locationProvider.select((l) => l.realUserSpeedKmh));
});

final userLatLongProvider = Provider((ref) {
  return ref.watch(locationProvider.select((l) => l.userLatLongs));
});

final isGPSGrantedProvider = Provider((ref) {
  return ref.watch(locationProvider.select((l) => l.gpsGranted));
});

final gpsLocationPermissionsStatusProvider = Provider((ref) {
  return ref
      .watch(locationProvider.select((l) => l.gpsLocationPermissionsStatus));
});

final isUserParticipatingProvider = Provider((ref) {
  return ref.watch(locationProvider.select((l) => l.userIsParticipant));
});

///Watch active [Event]
final isActiveEventProvider = Provider((ref) {
  return ref.watch(
      realtimeDataProvider.select((l) => l == null ? false : l.eventIsActive));
});

final bgNetworkConnectedProvider = Provider((ref) {
  return ref.watch(locationProvider.select((nw) => nw.networkConnected));
});

final locationUpdateProvider = StreamProvider<LatLng?>((ref) {
  return LocationProvider.instance.userBgLocationStream.map((location) {
    return LatLng(location.coords.latitude, location.coords.longitude);
  });
});

final locationTrainHeadUpdateProvider = StreamProvider<LatLng?>((ref) {
  return LocationProvider.instance.trainHeadUpdateStream.map((location) {
    return LatLng(location.latitude, location.longitude);
  });
});
