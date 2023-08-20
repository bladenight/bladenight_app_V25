import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location2/location2.dart' hide PermissionStatus;
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_io/io.dart';
import 'package:wakelock/wakelock.dart';

import '../app_settings/app_configuration_helper.dart';
import '../app_settings/app_constants.dart';
import '../generated/l10n.dart';
import '../helpers/device_info_helper.dart';
import '../helpers/deviceid_helper.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/location2_to_bglocation.dart';
import '../helpers/location_permission_dialogs.dart';
import '../helpers/notification/notification_helper.dart';
import '../helpers/notification/toast_notification.dart';
import '../helpers/preferences_helper.dart';
import '../helpers/watch_communication_helper.dart';
import '../models/event.dart';
import '../models/location.dart';
import '../models/realtime_update.dart';
import '../models/route.dart';
import '../models/user_trackpoint.dart';
import 'active_event_notifier_provider.dart';
import 'network_connection_provider.dart';

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
  static DateTime _lastRealtimeRequest = DateTime(2022, 1, 1, 0, 0, 0);
  static DateTime _lastRefreshRequest = DateTime(2022, 1, 1, 0, 0, 0);

  get lastUpdate => _lastUpdate;
  DateTime? _userReachedFinishDateTime, _startedTrackingTime;

  Timer? _updateTimer;

  bool _isMoving = false;
  String _lastRouteName = '';
  EventStatus? _eventState;

  bool get isMoving => _isMoving;

  bool _networkConnected = true;

  bool get networkConnected => _networkConnected;

  bool _isTracking = false;

  bool get isTracking => _isTracking;

  bool _gpsGranted = false;

  bool _hasLocationPermissions = false;

  bool get hasLocationPermissions => _hasLocationPermissions;

  bool get gpsGranted => _gpsGranted;

  LocationPermissionStatus _gpsLocationPermissionsStatus =
      LocationPermissionStatus.unknown;

  LocationPermissionStatus get gpsLocationPermissionsStatus =>
      _gpsLocationPermissionsStatus;

  ///flag for user is in Procession or not
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

  get realtimeUpdate => _realtimeUpdate;

  bool _isHead = false;
  bool _isTail = false;
  bg.Location? _lastKnownPoint;

  bool get isHead => _isHead;

  bool get isTail => _isTail;

  List<LatLng> get userLatLongs => _userLatLongs;
  List<LatLng> _userLatLongs = <LatLng>[];

  List<UserTrackPoint> get userTrackingPoints => _userTrackingPoints;
  final _userTrackingPoints = <UserTrackPoint>[];

  final _controller = StreamController<bg.Location>.broadcast();
  final _trainHeadController = StreamController<LatLng>.broadcast();
  final _userTrackPointsController =
      StreamController<UserTrackPoint>.broadcast();

  StreamSubscription<ConnectivityStatus>? _internetConnectionSubscription;

  Stream<bg.Location> get updates => _controller.stream;

  Stream<LatLng> get trainHeadUpdates => _trainHeadController.stream;

  Stream<UserTrackPoint> get userTrackPointsController =>
      _userTrackPointsController.stream;

  @override
  void dispose() {
    _userTrackPointsController.close();
    _trainHeadController.close();
    _controller.close();
    _internetConnectionSubscription?.cancel();
    super.dispose();
  }

  void init() async {
    if (kIsWeb) {
      notifyListeners();
      return;
    }
    if (!HiveSettingsDB.useAlternativeLocationProvider) {
      _state = await _startBackgroundGeolocation();
      if (_state == null) {
        if (!kIsWeb) FLog.error(text: 'bg-locationState is null');
        _gpsGranted = false;
        notifyListeners();
        return;
      }
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
      FLog.trace(
          className: 'locationProvider',
          methodName: 'init',
          text: 'check _trackingWasActive');
    }
    if (_trackingWasActive &&
        !_isTracking &&
        ActiveEventProvider.instance.event.status == EventStatus.confirmed) {
      //restart tracking on reopen
      if (!kIsWeb) {
        FLog.info(
            className: 'locationProvider',
            methodName: 'init',
            text: 'restart tracking');
      }
      await toggleProcessionTracking(userIsParticipant: _userIsParticipant);
      showToast(message: Localize.current.trackingRestarted);
    }
    notifyListeners();
    if (!kIsWeb) {
      FLog.trace(
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

      var isMotionDetectionDisabled = HiveSettingsDB.isMotionDetectionDisabled;
      var bgLogLevel = HiveSettingsDB.getBackgroundLocationLogLevel;

      if (Platform.isAndroid) {
        return bg.BackgroundGeolocation.ready(bg.Config(
          locationAuthorizationRequest: 'Any',
          reset: true,
          debug: false,
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_NAVIGATION,
          allowIdenticalLocations: true,
          distanceFilter: 0.5,
          heartbeatInterval: 60,
          disableMotionActivityUpdates: isMotionDetectionDisabled,
          logMaxDays: 1,
          persistMode: bg.Config.PERSIST_MODE_NONE,
          stopAfterElapsedMinutes: 3600,
          preventSuspend: true,
          stopOnTerminate: true,
          startOnBoot: false,
          logLevel: bgLogLevel,
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
        FLog.error(text: '_startBackgroundGeolocation', exception: error);
      }
    }
    if (!kIsWeb) {
      FLog.warning(
          text: 'No Valid device for bg.BackgroundGeolocation',
          className: toString(),
          methodName: '_startBackgroundGeolocation');
    }
    return null;
  }

  void _onLocation(bg.Location location) {
    if (!kIsWeb) FLog.trace(text: '_onLocation $location');
    _controller.add(location);
    updateUserLocation(location);
    sendLocation(location);
  }

  ///Update user location and track points list
  void updateUserLocation(bg.Location location) {
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
      smallTrackPointList.add(LatLng(_userTrackingPoints.last.latitude,
          _userTrackingPoints.last.longitude));
      _userLatLongs = smallTrackPointList;
    } else {
      _userLatLongs.add(userLatLng);
    }
    if (!_isInBackground) {
      notifyListeners();
    }
  }

  void _onLocationError(bg.LocationError error) {
    if (!kIsWeb) FLog.trace(text: 'Location error reason:$error');
    if (_lastKnownPoint != null) {
      //sendLocation(_lastKnownPoint!);
    }
  }

  void _onMotionChange(bg.Location location) {
    if (!kIsWeb) FLog.trace(text: 'OnMotionChange send location');
    //sendLocation(location); //dont send
  }

  void _onActivityChange(bg.ActivityChangeEvent event) {
    if (!kIsWeb) FLog.trace(text: 'On ActivityChangeEvent $event');
    //_subToUpdates();
  }

  void _onHeartBeat(bg.HeartbeatEvent event) {
    if (!kIsWeb) FLog.trace(text: 'On Heartbeat  $event');
    _getHeartBeatLocation();
  }

  _onConnectionChange(bg.ConnectivityChangeEvent event) {
    if (!kIsWeb) FLog.debug(text: 'On ConnectivityChange  $event');
    _networkConnected = event.connected;
  }

  void _getHeartBeatLocation() async {
    try {
      if (!kIsWeb) {
        FLog.trace(
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
        FLog.trace(
          className: toString(),
          methodName: '_getHeartBeatLocation',
          text: '_subUpdates sent new location $newLocation',
        );
      }
      return;
    } catch (e) {
      if (!kIsWeb) {
        FLog.warning(
            className: toString(),
            methodName: '_subToUpdates',
            text: '_subUpdates Failed:',
            exception: e);
      }
    }
    refresh();
  }

  _onProviderChange(bg.ProviderChangeEvent event) {
    if (!kIsWeb) FLog.info(text: 'onProviderChangeEvent  $event');
    switch (event.status) {
      case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_NOT_DETERMINED:
        _gpsLocationPermissionsStatus = LocationPermissionStatus.notDetermined;
        break;
      case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_RESTRICTED:
        _gpsLocationPermissionsStatus = LocationPermissionStatus.restricted;
        break;
      case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_DENIED:
        _gpsLocationPermissionsStatus = LocationPermissionStatus.denied;
        _stopTracking();
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

  ///toggles tracking when user is in procession
  ///set [userIsParticipant] to true if participant
  ///set [userIsParticipant] to false if only in viewer-mode
  Future<void> toggleProcessionTracking({bool userIsParticipant = true}) async {
    if (kIsWeb) {
      return;
    }
    _userIsParticipant = userIsParticipant;
    HiveSettingsDB.setUserIsParticipant(userIsParticipant);
    if (_isTracking) {
      _stopTracking();
    } else {
      _startTracking();
    }
  }

  void toggleAutoStop() async {
    _autoStop = !_autoStop;
    notifyListeners();
    PreferencesHelper.saveAutoStopToPrefs(_autoStop);
  }

  void _stopTracking() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _isTracking = false;
    setUpdateTimer(false);
    Wakelock.disable();
    bg.BackgroundGeolocation.stop().then((bg.State state) {
      if (!kIsWeb) {
        FLog.info(
            text: 'location tracking stopped ${state.enabled}',
            className: 'location_provider',
            methodName: '_stopTracking');
      }
      _realUserSpeedKmh = null;
      _userLatLng = null;
      //reset autostart
      //avoid second autostart on an event , reset after end
      if (_startedTrackingTime != null &&
          DateTime.now().difference(_startedTrackingTime!).inMinutes >
              ActiveEventProvider.instance.event.duration.inMinutes) {
        _startedTrackingTime = null;
      }
      SendToWatch.setIsLocationTracking(false);
      HiveSettingsDB.setTrackingActive(false);
      LocationStore.saveUserTrackPointList(_userTrackingPoints);
      notifyListeners();
    }).catchError((error) {
      if (!kIsWeb) FLog.error(text: 'Stopping ERROR: $error');
    });
  }

  void _startTracking() async {
    if (kIsWeb) return;
    _isHead = HiveSettingsDB.specialCodeValue == 1 ||
        HiveSettingsDB.specialCodeValue == 5;
    _isTail = HiveSettingsDB.specialCodeValue == 2 ||
        HiveSettingsDB.specialCodeValue == 6;

    if (HiveSettingsDB.wakeLockEnabled) {
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
        if (!kIsWeb) {
          FLog.warning(
              text: 'No positive prominent disclosure or always denied');
        }
        return;
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
      if (!kIsWeb) {
        FLog.warning(
            text: 'location permanentlyDenied by os',
            className: 'location_provider',
            methodName: '_startTracking');
      }
      await LocationPermissionDialog().requestAndOpenAppSettings();
      return;
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

    if (HiveSettingsDB.useAlternativeLocationProvider) {
      if (!kIsWeb) {
        FLog.info(
            text: 'alternative location tracking started',
            className: 'location_provider',
            methodName: '_startTracking');
      }
      _gpsLocationPermissionsStatus =
          await LocationPermissionDialog().getPermissionsStatus();

      _hasLocationPermissions =
          _gpsLocationPermissionsStatus == LocationPermissionStatus.whenInUse ||
              _gpsLocationPermissionsStatus == LocationPermissionStatus.always;
      if (HiveSettingsDB.useAlternativeLocationProvider &&
          _hasLocationPermissions) {
        _gpsLocationPermissionsStatus =
            _gpsLocationPermissionsStatus == LocationPermissionStatus.always
                ? LocationPermissionStatus.always
                : LocationPermissionStatus.whenInUse;
      }
      _listenLocationWithAlternativePackage();
      _isTracking = true;
      setUpdateTimer(true);
      _startedTrackingTime = DateTime.now();
      _stoppedAfterMaxTime = false;
      ActiveEventProvider.instance.refresh(forceUpdate: true);
      notifyListeners();
      _subToUpdates();
      SendToWatch.setIsLocationTracking(_isTracking);
      HiveSettingsDB.setTrackingActive(_isTracking);
    } else {
      await bg.BackgroundGeolocation.start().then((bg.State state) {
        if (!kIsWeb) {
          FLog.info(
              text: 'location tracking started',
              className: 'location_provider',
              methodName: '_startTracking');
        }
        _isTracking = state.enabled;
        _startedTrackingTime = DateTime.now();
        _stoppedAfterMaxTime = false;
        setUpdateTimer(true);
        ActiveEventProvider.instance.refresh(forceUpdate: true);
        notifyListeners();
        _subToUpdates();
        HiveSettingsDB.setTrackingActive(_isTracking);
        SendToWatch.setIsLocationTracking(_isTracking);
      }).catchError((error) {
        if (!kIsWeb) FLog.error(text: 'LocStarting ERROR: $error');
        HiveSettingsDB.setTrackingActive(false);
        _isTracking = false;
        setUpdateTimer(false);
        SendToWatch.setIsLocationTracking(false);
        notifyListeners();
        return;
      });
    }
  }

  ///set [enabled] = true  or reset [enabled] = false location updates if tracking is enabled
  void setUpdateTimer(bool enabled) {
    if (!kIsWeb) {
      FLog.trace(text: 'init setLocationTimer to $enabled');
    }
    _updateTimer?.cancel();
    if (enabled) {
      _updateTimer = Timer.periodic(
        //realtimeUpdateProvider reads data on send-location -
        //so it must not updated all 10 secs
        const Duration(seconds: defaultLocationUpdateInterval),
        (timer) {
          int lastUpdate = DateTime.now().difference(_lastUpdate).inSeconds;
          if (kDebugMode) {
            print('update timer internal  lastupdate before ${lastUpdate}s');
          }
          if (lastUpdate >= defaultLocationUpdateInterval) {
            if (!kIsWeb) {
              FLog.trace(text: 'setUpdateTimer Refresh');
            }
            refresh();
          }
        },
      );
    } else {
      _updateTimer?.cancel();
      _updateTimer = null;
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
        FLog.trace(
          className: toString(),
          methodName: '_subToUpdates',
          text: 'started',
        );
      }
      bg.Location? newLocation;
      if (HiveSettingsDB.useAlternativeLocationProvider) {
        return _lastKnownPoint;
        //getLocation ignored if location is running
      } else {
        newLocation = await bg.BackgroundGeolocation.getCurrentPosition(
          timeout: 3,
          maximumAge: 60000,
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_NAVIGATION,
          samples: 1, // How many location samples to attempt.
        );
      }
      // double sending by onLocation sendLocation(newLocation);
      if (!kIsWeb) {
        FLog.trace(
          className: toString(),
          methodName: '_subToUpdates',
          text: '_subUpdates sent new location $newLocation',
        );
      }
      return newLocation;
    } catch (e) {
      if (!kIsWeb) {
        FLog.warning(
            className: toString(),
            methodName: '_subToUpdates',
            text: '_subUpdates Failed:',
            exception: e);
      }
    }
    if (!kIsWeb) {
      FLog.trace(
          className: toString(),
          methodName: '_subToUpdates',
          text: '_subUpdates Failed:');
    }
    if (_lastKnownPoint != null) {
      var ts = DateTime.parse(_lastKnownPoint!.timestamp);
      var diff = DateTime.now().toUtc().difference(ts.toUtc());
      if (diff < const Duration(minutes: 10)) {
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
    var timeDiff = dtNow.difference(_lastRealtimeRequest);
    if (timeDiff < const Duration(seconds: defaultSendNewLocationDelay)) {
      return;
    }
    _lastRealtimeRequest = dtNow;

    ///TODO Testing to avoid server traffic
    /*if (ActiveEventProvider.instance.event.status != EventStatus.confirmed ||
        ActiveEventProvider.instance.event.status != EventStatus.running) {
      //no running event - don't send data to server
      return;
    }*/

    if (!_networkConnected) {
      if (!kIsWeb) {
        FLog.trace(
          className: toString(),
          methodName: 'sendLocation',
          text: 'no network ignore send location',
        );
      }
      return;
    }
    //only result of this message contains friend position - requested [RealTimeUpdates] without location
    update = await RealtimeUpdate.wampUpdate(MapperContainer.globals.toMap(
      LocationInfo(
          coords: LatLng(location.coords.latitude, location.coords.longitude),
          deviceId: await DeviceId.getId,
          isParticipating: _userIsParticipant,
          specialFunction: HiveSettingsDB.wantSeeFullOfProcession
              ? HiveSettingsDB.specialCodeValue
              : null,
          userSpeed: location.coords.speed < 0 ? 0.0 : location.coords.speed,
          realSpeed:
              location.coords.speed < 0 ? 0.0 : location.coords.speed * 3.6),
    ));
    if (update.rpcException != null) {
      return;
    }
    HiveSettingsDB.setOdometerValue(odometer);

    _lastUpdate = DateTime.now();
    _realtimeUpdate = update;
    if (!kIsWeb) {
      FLog.trace(
          className: 'locationProvider',
          methodName: 'sendLocation',
          text: 'sent loc update with result  $update');
    }
    if (realtimeUpdate != null &&
        (_lastRouteName != _realtimeUpdate?.routeName ||
            _eventState != _realtimeUpdate?.eventState)) {
      _lastRouteName = _realtimeUpdate!.routeName;
      _eventState = _realtimeUpdate!.eventState;
      await ActiveEventProvider.instance.refresh(forceUpdate: true);
    }
    if (_realtimeUpdate != null && _realtimeUpdate?.friends != null) {
      var friendList =
          _realtimeUpdate?.updateMapPointFriends(_realtimeUpdate!.friends);
      if (friendList != null) {
        var friends = friendList.where((x) => x.specialValue == 0).toList();
        var friendListAsJson = MapperContainer.globals.toJson(friends);
        if (kDebugMode) {
          print('lp_send Friends to watch $friendListAsJson');
        }
        SendToWatch.updateFriends(friendListAsJson);
      }
    }

    if (_realtimeUpdate != null &&
        _realtimeUpdate?.head != null &&
        _realtimeUpdate?.head.longitude != 0.0) {
      double lat = _realtimeUpdate?.head.latitude ?? defaultLatitude;
      double lon = _realtimeUpdate?.head.longitude ?? defaultLongitude;

      _trainHeadController.add(LatLng(lat, lon));
    }
    if (!kIsWeb) _updateWatchData();
    checkUserFinishedOrEndEvent();
    if (!_isInBackground) notifyListeners();
  }

  ///Refresh [RealTimeData] when location has no data for 4500ms with tracking
  ///15 s without tracking
  ///[forceUpdate]-Mode to update after resume  default value = false
  ///necessary after app state switching in viewer mode
  Future<void> refresh({bool forceUpdate = false}) async {
    try {
      if (!kIsWeb) {
        FLog.trace(
            className: 'locationProvider',
            methodName: 'refresh',
            text: 'start refresh force $forceUpdate');
      }
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
          FLog.trace(
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
            FLog.error(
                className: 'locationProvider',
                methodName: 'refresh',
                text: update.rpcException.toString());
          }
          _realUserSpeedKmh = null;
          SendToWatch.setUserSpeed('- km/h');
          _updateWatchData();
          if (!_isInBackground) {
            notifyListeners();
          }
          return;
        }
        _realtimeUpdate = update;
      }

      _lastUpdate = dtNow;
      if (_realtimeUpdate != null &&
          _realtimeUpdate?.head != null &&
          _realtimeUpdate?.head.longitude != 0.0) {
        double lat = _realtimeUpdate?.head.latitude ?? defaultLatitude;
        double lon = _realtimeUpdate?.head.longitude ?? defaultLongitude;

        _trainHeadController.add(LatLng(lat, lon));
        if (_lastRouteName != _realtimeUpdate?.routeName ||
            _eventState != _realtimeUpdate?.eventState) {
          _lastRouteName = _realtimeUpdate!.routeName;
          _eventState = _realtimeUpdate!.eventState;
          ActiveEventProvider.instance.refresh(forceUpdate: true);
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
      if (!kIsWeb) {
        FLog.error(
            className: 'locationProvider',
            methodName: 'refresh',
            text: e.toString());
      }
    }
  }

  void checkUserFinishedOrEndEvent() {
    try {
      //Check for 'user reached finish' event and inform user
      Duration eventRuntime = DateTime.now()
          .toUtc()
          .difference(ActiveEventProvider.instance.event.startDate.toUtc());
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
            FlutterPlatformAlert.showAlert(
                windowTitle: Localize.current.finishReachedTitle,
                text: Localize.current.finishReachedStopedTracking);
            if (!kIsWeb) {
              FLog.info(
                  className: 'locationProvider',
                  methodName: 'checkUserFinishedOrEndEvent',
                  text: 'User reached finish - auto stop');
            }
            _stopTracking();
          } else {
            NotificationHelper().showString(
                id: DateTime.now().hashCode,
                text: Localize
                    .current.finishReachedtargetReachedPleaseStopTracking);
            FlutterPlatformAlert.showAlert(
                windowTitle: Localize.current.finishReachedTitle,
                text: Localize
                    .current.finishReachedtargetReachedPleaseStopTracking);

            if (!kIsWeb) {
              FLog.info(
                  className: 'locationProvider',
                  methodName: 'checkUserFinishedOrEndEvent',
                  text: 'User reached finish');
            }
          }
        }
      }
      var maxDuration = ActiveEventProvider.instance.event.duration.inMinutes;
      if (maxDuration == 0) return;
      if ((ActiveEventProvider.instance.event.status == EventStatus.finished ||
              eventRuntime.inMinutes > maxDuration) &&
          _isTracking &&
          _autoStop &&
          !_stoppedAfterMaxTime) {
        _stoppedAfterMaxTime = true;
        _userReachedFinishDateTime == null;
        _stopTracking();

        //Alert for overtime or finish event
        if (ActiveEventProvider.instance.event.status == EventStatus.finished) {
          if (_isInBackground) {
            NotificationHelper().showString(
                id: DateTime.now().hashCode,
                text: Localize.current.finishStopTrackingEventOver);
          } else {
            FlutterPlatformAlert.showAlert(
                windowTitle: Localize.current.finishForceStopEventOverTitle,
                text: Localize.current.finishStopTrackingEventOver);
          }
        } else {
          if (_isInBackground) {
            NotificationHelper().showString(
                id: DateTime.now().hashCode,
                text: Localize.current.finishStopTrackingTimeout(maxDuration));
          } else {
            FlutterPlatformAlert.showAlert(
                windowTitle: Localize.current.finishForceStopTimeoutTitle,
                text: Localize.current.finishStopTrackingTimeout(maxDuration));
          }
        }
        if (!kIsWeb) {
          FLog.info(
              className: 'locationProvider',
              methodName: 'checkUserFinishedOrEndEvent',
              text:
                  'forced tracking stop finished${ActiveEventProvider.instance.event.status == EventStatus.finished}');
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
          FlutterPlatformAlert.showAlert(
              windowTitle: Localize.current.timeOutDurationExceedTitle,
              text: Localize.current.stopTrackingTimeOut(maxDuration));
        }
        if (!kIsWeb) {
          FLog.info(
              className: 'locationProvider',
              methodName: 'checkUserFinishedOrEndEvent',
              text: 'remember tracking stop');
        }
      }
    } catch (e) {
      if (!kIsWeb) {
        FLog.error(
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
      SendToWatch.setIsLocationTracking(isTracking);
      if (_realtimeUpdate != null) {
        SendToWatch.updateRealtimeData(_realtimeUpdate?.toJson());
      }
    } catch (e) {
      if (!kIsWeb) {
        FLog.error(text: 'Error on _updateWatchData ${e.toString()}');
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
      //Triggers startlocation
      var odoResetResult =
          await bg.BackgroundGeolocation.setOdometer(0.0).then((value) {
        _odometer = value.odometer;
      }).catchError((error) {
        if (!kIsWeb) {
          FLog.error(text: '[resetOdometer] ERROR: $error');
        }
        return null;
      });

      if (!_isTracking) {
        //#issue 1102
        var state = await bg.BackgroundGeolocation.stop();
        _isTracking = state.enabled;
        notifyListeners();
      }
      _userTrackingPoints.clear();
      _userLatLongs.clear();
      LocationStore.clearTrackPointStore();
      return odoResetResult == null ? false : true;
    } catch (e) {
      if (!kIsWeb) {
        FLog.error(
            text: 'Error on resetTrackPoints ${e.toString()}', exception: e);
      }
      return false;
    }
  }

  void refreshRealtimeData() {
    int lastUpdate = DateTime.now()
        .difference(LocationProvider.instance.lastUpdate)
        .inSeconds;
    if (_isTracking || lastUpdate < defaultRealtimeUpdateInterval) {
      return;
    }
    if (!kIsWeb) {
      FLog.trace(
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
        .inSeconds;
    if (_isTracking || lastUpdate < defaultRealtimeUpdateInterval) {
      return;
    }
    if (!kIsWeb) {
      FLog.trace(
          className: toString(),
          methodName: 'getLastRealtimeData',
          text: 'updating because there are no new location data');
    }
    refresh();
  }
}

final locationProvider =
    ChangeNotifierProvider((ref) => LocationProvider.instance);

final isAutoStopProvider = Provider((ref) {
  return ref.watch(locationProvider.select((a) => a.autoStop));
});

///true when location is ready
final bgLocationIsReadyProvider = Provider((ref) {
  return ref.watch(locationProvider.select((l) => l.isMoving));
});

final bgNetworkConnectedProvider = Provider((ref) {
  return ref.watch(locationProvider.select((nw) => nw.networkConnected));
});

final odometerProvider = Provider((ref) {
  return ref.watch(locationProvider.select((l) => l.odometer));
});

final isTrackingProvider = Provider((ref) {
  return ref.watch(locationProvider.select((l) => l.isTracking));
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

final hasNewRealtimeData = Provider((ref) {
  return ref.watch(locationProvider.select((l) => l.realtimeUpdate));
});

///Watch active [Event] and turn off Navigation when [Event] ist not running
///or finished (userPos == length ??)
final isActiveEventProvider = Provider((ref) {
  return ref.watch(activeEventProvider.select((ae) => ae.event));
});

final locationUpdateProvider = StreamProvider<LatLng?>((ref) {
  return LocationProvider.instance.updates.map((location) {
    return LatLng(location.coords.latitude, location.coords.longitude);
  });
});

final locationTrainHeadUpdateProvider = StreamProvider<LatLng?>((ref) {
  return LocationProvider.instance.trainHeadUpdates.map((location) {
    return LatLng(location.latitude, location.longitude);
  });
});
