import 'dart:async';

import 'package:wakelock_plus/wakelock_plus.dart';

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
import '../helpers/watch_communication_helper.dart';
import '../main.dart';
import '../models/event.dart';
import '../models/geofence_point.dart' as gfp;
import '../models/location.dart';
import '../models/realtime_update.dart';
import '../models/route.dart';
import '../models/user_speed_point.dart';
import '../models/user_gpx_point.dart';
import '../wamp/wamp_v2.dart';
import 'active_event_provider.dart';
import 'images_and_links/geofence_image_and_link_provider.dart';
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
  bool locationRequested = false;
  bool _isInBackground = false;
  bool _wakelockDisabled = false;

  static DateTime _lastUpdate = DateTime(2022, 1, 1, 0, 0, 0);
  static DateTime _lastForceStop = DateTime(2022, 1, 1, 0, 0, 0);
  static DateTime _lastLocationRealtimeRequest = DateTime(2022, 1, 1, 0, 0, 0);
  static DateTime _lastRefreshRequest = DateTime(2022, 1, 1, 0, 0, 0);

  DateTime? _userReachedFinishDateTime, _startedTrackingTime;
  Timer? _updateTimer, _saveLocationsTimer, _trackingUpdateTimer;

  bool _autoTrackingStarted = false;
  String _lastRouteName = '';
  EventStatus? _eventState;

  EventStatus? get eventState => _eventState;

  DateTime get lastUpdate => _lastUpdate;

  bool _eventIsRunning = false;

  bool get eventIsActive => _eventIsRunning;

  bool _isMoving = false;

  bool get isMoving => _isMoving;

  bool _networkConnected = WampV2.instance.webSocketIsConnected;

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

  bool _autoStopTracking = true;

  bool _autoStartTracking = false;

  bool get autoStopTracking => _autoStopTracking;

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

  UserSpeedPoints get userSpeedPoints => _userSpeedPoints;
  UserSpeedPoints _userSpeedPoints = UserSpeedPoints([]);

  List<UserGpxPoint> get userGpxPoints => _userGpxPoints;

  final _userGpxPoints = <UserGpxPoint>[];

  //Stream controllers private
  final _userPositionStreamController =
      StreamController<bg.Location>.broadcast();

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

  @override
  void dispose() {
    LocationStore.saveUserTrackPointList(_userGpxPoints, DateTime.now());
    _userTrackPointsStreamController.close();
    _trainHeadStreamController.close();
    _userPositionStreamController.close();
    _wampConnectedSubscription?.cancel();
    _userLocationMarkerPositionStreamController.close();
    _userLocationMarkerHeadingStreamController.close();
    _trackingUpdateTimer?.cancel();
    _saveLocationsTimer?.cancel();
    _updateTimer?.cancel();
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
    _startTrackingUpdateTimer();
    BnLog.trace(
        className: 'locationProvider',
        methodName: 'init',
        text: 'init finished');
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
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
          allowIdenticalLocations: true,
          distanceFilter: 2,
          heartbeatInterval: 60,
          disableMotionActivityUpdates: isMotionDetectionDisabled,
          logMaxDays: 1,
          persistMode: bg.Config.PERSIST_MODE_NONE,
          stopAfterElapsedMinutes: 3600,
          preventSuspend: true,
          stopOnTerminate: false,
          startOnBoot: false,
          logLevel: bgLogLevel,
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
          //ALL
          logLevel: bgLogLevel,
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
          distanceFilter: 2,
          disableMotionActivityUpdates: isMotionDetectionDisabled,
          heartbeatInterval: 60,
          stopDetectionDelay: 2,
          persistMode: bg.Config.PERSIST_MODE_NONE,
          // Activity Recognition
          activityRecognitionInterval: 3000,
          allowIdenticalLocations: true,
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
      if (!kIsWeb) {
        BnLog.error(text: '_startBackgroundGeolocation', exception: error);
      }
    }
    if (!kIsWeb) {
      BnLog.warning(
          text: 'No valid device for bg.BackgroundGeolocation',
          className: toString(),
          methodName: '_startBackgroundGeolocation');
    }
    return null;
  }

  void _onLocation(bg.Location location) {
    //BnLog.trace(text: '_onLocation $location');
    updateUserLocation(location);
    sendLocation(location);
    checkWakeLock(location.battery.level, location.battery.isCharging);
  }

  ///Update user location and track points list
  void updateUserLocation(bg.Location location) {
    if (!_isTracking) return;
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
      if (diff < const Duration(milliseconds: 2500)) {
        return;
      }
    }

    _userLatLng = LatLng(location.coords.latitude, location.coords.longitude);

    _realUserSpeedKmh =
        location.coords.speed <= 0 ? 0.0 : location.coords.speed * 3.6;
    _realUserSpeedKmh = _realUserSpeedKmh!.toShortenedDouble(3);
    _odometer = location.odometer / 1000;

    if (MapSettings.showOwnTrack && !MapSettings.showOwnColoredTrack) {
      _userLatLngList
          .add(LatLng(location.coords.latitude, location.coords.longitude));
    }
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
    _lastKnownPoint = location;
    SendToWatch.setUserSpeed('${_realUserSpeedKmh!.toStringAsFixed(1)} km/h');

    //Create poly lines for user tracking
    int maxSize = 250;
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
        var last5 = _userGpxPoints.reversed.take(2).toList(growable: false);
        for (var last in last5) {
          smallTrackPointList.add(LatLng(last.latitude, last.longitude));
        }
        _userLatLngList = smallTrackPointList;
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

        var last2userGPXPoints =
            _userGpxPoints.reversed.take(2).toList(growable: false);
        for (int i = 1; i >= 0; i--) {
          var lastSmTrackPointListEntry = smallTrackPointList.lastSpeedPoint;
          if (last2userGPXPoints[i].latLng ==
              lastSmTrackPointListEntry!.latLng) {
            continue;
          }
          smallTrackPointList.add(
              last2userGPXPoints[i].latitude,
              last2userGPXPoints[i].longitude,
              last2userGPXPoints[i].realSpeedKmh,
              lastSmTrackPointListEntry.latLng);
        }
        _userSpeedPoints = smallTrackPointList;
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
    if (!kIsWeb) BnLog.trace(text: 'Location error reason:$error');
    if (_lastKnownPoint != null) {
      //sendLocation(_lastKnownPoint!);
    }
  }

  void _onMotionChange(bg.Location location) {
    BnLog.trace(text: 'OnMotionChange location');
    _isMoving = location.isMoving;
    if (!_isInBackground) {
      notifyListeners();
    }
    //sendLocation(location); //dont send!!
  }

  void _onActivityChange(bg.ActivityChangeEvent event) {
    BnLog.trace(text: 'On ActivityChangeEvent $event');
    //_subToUpdates();
  }

  void _onHeartBeat(bg.HeartbeatEvent event) {
    BnLog.trace(text: 'On Heartbeat  $event');
    _getHeartBeatLocation();
  }

  _onConnectionChange(bg.ConnectivityChangeEvent event) {
    BnLog.debug(text: 'On ConnectivityChange  $event');
    //_networkConnected = event.connected;
  }

  void _getHeartBeatLocation() async {
    if (!_isTracking) return;
    try {
      BnLog.trace(
        className: toString(),
        methodName: '_getHeartBeatLocation',
        text: 'started',
      );
      bg.Location? newLocation;
      newLocation = await bg.BackgroundGeolocation.getCurrentPosition(
        timeout: 2,
        maximumAge: 60000,
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        samples: 2, // How many location samples to attempt.
      );
      //triggers onLocation
      BnLog.trace(
        className: toString(),
        methodName: '_getHeartBeatLocation',
        text: '_subUpdates sent new location $newLocation',
      );
      return;
    } catch (e) {
      BnLog.warning(
          className: toString(),
          methodName: '_subToUpdates',
          text: '_subUpdates Failed:',
          exception: e);
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
    _onGeoFenceEvent(event);
  }

  void toggleAutoStop() async {
    _autoStopTracking = !_autoStopTracking;
    notifyListeners();
    HiveSettingsDB.setAutoStopTrackingEnabled(_autoStopTracking);
  }

  Future<bool> stopTracking() async {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _isTracking = false;
    _lastKnownPoint = null;
    setUpdateTimer(false);
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
      LocationStore.saveUserTrackPointList(_userGpxPoints, DateTime.now());
    } else {
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
        LocationStore.saveUserTrackPointList(_userGpxPoints, DateTime.now());
        await startStopGeoFencing();
        await WakelockPlus.disable();
      }).catchError((error) {
        BnLog.error(text: 'Stopping location error: $error');
      });
    }
    notifyListeners();
    return _isTracking;
  }

  ///Starts or stops geofencing
  Future<void> startStopGeoFencing() async {
    if (!HiveSettingsDB.isBladeGuard ||
        !HiveSettingsDB.onsiteGeoFencingActive) {
      if (!_isTracking) {
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
        !HiveSettingsDB.onsiteGeoFencingActive) return;
    var points = await ProviderContainer().read(geofencePointsProvider.future);
    var geofencePoints = gfp.GeofencePoints.getGeofenceList(points);
    bg.BackgroundGeolocation.addGeofences(geofencePoints).then((bool success) {
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

    if (HiveSettingsDB.trackingFirstStart &&
        HiveSettingsDB.autoStartTrackingEnabled) {
      await QuickAlert.show(
          context: navigatorKey.currentContext!,
          type: QuickAlertType.confirm,
          showCancelBtn: true,
          confirmBtnColor: Colors.orange,
          title: Localize.current.autoStartTrackingInfo,
          text: Localize.current.autoStartTrackingInfoTitle,
          onConfirmBtnTap: () {
            HiveSettingsDB.setAutoStartTrackingEnabled(true);
            navigatorKey.currentState?.pop();
          },
          onCancelBtnTap: () {
            HiveSettingsDB.setAutoStartTrackingEnabled(false);
            navigatorKey.currentState?.pop();
          },
          confirmBtnText: 'Auto-Start',
          cancelBtnText: Localize.current.no);
      HiveSettingsDB.setTrackingFirstStart(false);
    }

    _userReachedFinishDateTime == null;
    if (_userGpxPoints.length <= 1 &&
        MapSettings.showOwnTrack &&
        LocationStore.storedDataAreFromToday) {
      //reload data
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
      WakelockPlus.enable();
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
    BnLog.trace(text: 'init startSaveLocationsUpdateTimer to $enabled');
    _saveLocationsTimer?.cancel();
    if (enabled) {
      _saveLocationsTimer = Timer.periodic(
        const Duration(minutes: 5),
        (timer) {
          if (!_isTracking) {
            return;
          }
          LocationStore.saveUserTrackPointList(_userGpxPoints, DateTime.now());
        },
      );
    } else {
      _saveLocationsTimer?.cancel();
      _saveLocationsTimer = null;
    }
  }

  ///set [enabled] = true  or reset [enabled] = false location updates if tracking is enabled
  void setUpdateTimer(bool enabled) {
    BnLog.trace(text: 'init setLocationTimer to $enabled');
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

  void _startTrackingUpdateTimer() {
    BnLog.trace(text: 'init startTrackingUpdateTimer');
    _trackingUpdateTimer?.cancel();
    _trackingUpdateTimer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) async {
        await _autoStartTimerCallBack();
      },
    );
    _autoStartTimerCallBack();
  }

  Future<void> _autoStartTimerCallBack() async {
    if (_isTracking ||
        !HiveSettingsDB.autoStartTrackingEnabled ||
        _autoTrackingStarted) {
      return;
    }
    await ProviderContainer()
        .read(activeEventProvider.notifier)
        .refresh(forceUpdate: true);
    _eventIsRunning = ProviderContainer().read(activeEventProvider).status ==
            EventStatus.running ||
        (_realtimeUpdate != null && _realtimeUpdate!.eventIsActive);
    if (_eventIsRunning) {
      startTracking(userIsParticipant);
      _autoTrackingStarted = true;
      BnLog.trace(text: '_autoStartTimerCallBack autostart tracking via timer');
      if (_isInBackground) {
        NotificationHelper().showString(
            id: DateTime.now().hashCode,
            text: Localize.current.autoStartTracking);
      } else {
        QuickAlert.show(
            context: navigatorKey.currentContext!,
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

  ///get location and send to server
  ///will send new location to server if sendLoc != false
  Future<bg.Location?> _subToUpdates({var sendLoc = true}) async {
    var timeDiff = DateTime.now().difference(_lastUpdate);
    if (timeDiff < const Duration(seconds: defaultSendNewLocationDelay)) {
      return _lastKnownPoint;
    }
    try {
      BnLog.trace(
        className: toString(),
        methodName: '_subToUpdates',
        text: 'started',
      );

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
          maximumAge: 30000,
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
          samples: 3, // How many location samples to attempt.
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
      if (sendLoc) {
        sendLocation(_lastKnownPoint!);
      }
      return _lastKnownPoint;
    }
    return null;
  }

  void checkWakeLock(double batteryLevel, bool isCharging) async {
    if (HiveSettingsDB.wakeLockEnabled &&
        _wakelockDisabled == false &&
        !isCharging &&
        batteryLevel < 0.3) {
      await WakelockPlus.disable();
      _wakelockDisabled = true;
      //showToast(message: Localize.current.wakelockDisabled);
    }
    if (HiveSettingsDB.wakeLockEnabled &&
        _wakelockDisabled == true &&
        (batteryLevel > 0.3 || isCharging)) {
      await WakelockPlus.enable();
      _wakelockDisabled = false;
      //showToast(message: Localize.current.wakelockEnabled);
    }
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

    /* removed because no request -> no connection
    if (!_networkConnected) {
      BnLog.trace(
        className: toString(),
        methodName: 'sendLocation',
        text: 'no network ignore send location',
      );
      return;
    }*/
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
    HiveSettingsDB.setOdometerValue(odometer);

    _lastUpdate = DateTime.now();
    _realtimeUpdate = update;

    BnLog.trace(
        className: 'locationProvider',
        methodName: 'sendLocation',
        text: 'sent loc update with result $update');

    if (realtimeUpdate != null &&
        (_lastRouteName != _realtimeUpdate?.routeName ||
            _eventState != _realtimeUpdate?.eventState ||
            _eventIsRunning != _realtimeUpdate?.eventIsActive)) {
      _lastRouteName = _realtimeUpdate!.routeName;
      _eventState = _realtimeUpdate!.eventState;
      _eventIsRunning = _realtimeUpdate!.eventIsActive;
      ProviderContainer()
          .read(activeEventProvider.notifier)
          .refresh(forceUpdate: true);
    }
    if (_realtimeUpdate != null && _realtimeUpdate?.friends != null) {
      var friendList =
          _realtimeUpdate?.mapPointFriends(_realtimeUpdate!.friends);
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
      if (locData == null) {
        // &&_networkConnected) {
        //update procession when no location data were sent
        var update = await RealtimeUpdate.wampUpdate();
        BnLog.trace(
            className: 'locationProvider',
            methodName: 'refresh',
            text: 'send refresh force $forceUpdate');
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
        notifyListeners();
      }
    } catch (e) {
      BnLog.error(
          className: 'locationProvider',
          methodName: 'refresh',
          text: e.toString());
    }
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
                context: navigatorKey.currentContext!,
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
        _isTracking &&
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
              context: navigatorKey.currentContext!,
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
    if (eventRuntime.inMinutes >= maxDuration && _isTracking) {
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
            context: navigatorKey.currentContext!,
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
        _userGpxPoints.clear();
        _userSpeedPoints.clear();
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
      _userGpxPoints.clear();
      _userSpeedPoints.clear();
      LocationStore.clearTrackPointStoreForDate(DateTime.now());
      return odoResetResult == null ? false : true;
    } catch (e) {
      if (!kIsWeb) {
        BnLog.error(
            text: 'Error on resetTrackPoints ${e.toString()}', exception: e);
      }
      return false;
    }
  }

  Future<void> resetTrackPointsStore() async {
    await resetTrackPointsStore();
    LocationStore.clearTrackPointStore();
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

  Future clearAllTrackPoints(BuildContext context) async {
    QuickAlert.show(
        context: navigatorKey.currentContext!,
        type: QuickAlertType.warning,
        showCancelBtn: true,
        title: Localize.current.resetTrackPointsStoreTitle,
        text: '${Localize.current.resetTrackPointsStore}',
        confirmBtnText: Localize.current.yes,
        cancelBtnText: Localize.current.cancel,
        onConfirmBtnTap: () {
          resetTrackPointsStore();
          notifyListeners();
          if (!context.mounted) return;
          Navigator.of(context).pop();
        });
  }

  void _onGeoFenceEvent(bg.GeofenceEvent event) async {
    if (HiveSettingsDB.isBladeGuard && HiveSettingsDB.onsiteGeoFencingActive) {
      BnLog.info(text: 'geofence recognized ${event.toString()}');
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
}

//Providers

final locationProvider =
    ChangeNotifierProvider((ref) => LocationProvider.instance);

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
  return ref.watch(locationProvider.select((l) => l.userSpeedPoints));
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

final geoFenceEventProvider = StreamProvider<bg.GeofenceEvent>((ref) {
  return LocationProvider.instance.geoFenceEventStream.map((event) {
    return event;
  });
});

final locationTrainHeadUpdateProvider = StreamProvider<LatLng?>((ref) {
  return LocationProvider.instance.trainHeadUpdateStream.map((location) {
    return LatLng(location.latitude, location.longitude);
  });
});
