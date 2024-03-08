import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../models/event.dart';
import '../../models/follow_location_state.dart';
import '../../models/route.dart';
import '../../models/user_trackpoint.dart';
import '../logger.dart';
import '../uuid_helper.dart';

part 'location_store.dart';
part 'map_settings.dart';

final hiveDBProvider =
    StateProvider<HiveSettingsDB>((ref) => HiveSettingsDB.instance);

final bgLeaderSettingProvider = Provider((ref) {
  return ref.watch(hiveDBProvider);
});

class HiveSettingsDB {
  static final HiveSettingsDB instance = HiveSettingsDB._();

  HiveSettingsDB();

  HiveSettingsDB._() {
    init();
  }

  static get _hiveBox {
    return Hive.box('settings');
  }

  void init() async {
    setSessionShortUUID(UUID.createShortUuid());
    //not working here
    //await Hive.initFlutter();
    //await Hive.openBox('settings');
  }

  static get settingsHiveBox => _hiveBox;

  static const String _hasSpecialRightsPref = 'hasSpecialRightsPref';
  static const String _specialRightsPref = 'specialRightsPref';
  static const String isTailOfProcessionKey = 'isTailOfProcessionSettingPref';
  static const String isHeadOfProcessionKey = 'isHeadOfProcessionSettingPref';
  static const String wantSeeFullOfProcessionKey =
      'wantSeeFullOfProcessionSettingPref';
  static const String _bgLoglevelKey = 'bgLoglevelPref';
  static const String _getUserIsParticipantKey = 'userIsParticipantKeyPref';

  ///get loglevel bg Geolocation
  static int get getBackgroundLocationLogLevel {
    return _hiveBox.get(_bgLoglevelKey, defaultValue: bg.Config.LOG_LEVEL_INFO);
  }

  static void setBackgroundLocationLogLevel(int val) {
    BnLog.info(text: 'setBackgroundLocationLogLevel to $val');
    _hiveBox.put(_bgLoglevelKey, val);
  }

  static const String _sessionShortUUIDKey = 'sessionShortUUIDPref';

  ///get RoutePointsAsString
  static String get sessionShortUUID {
    return _hiveBox.get(_sessionShortUUIDKey,
        defaultValue: UUID.createShortUuid());
  }

  ///set SessionShortUUID
  static void setSessionShortUUID(String val) {
    _hiveBox.put(_sessionShortUUIDKey, val);
  }

  static const String _disableMotionDetection = 'disableMotionDetectionPref';

  ///get if motion detection is disabled
  static bool get isMotionDetectionDisabled {
    var val = _hiveBox.get(_disableMotionDetection, defaultValue: false);
    return val;
  }

  ///set if motion detection is disabled
  static void setIsMotionDetectionDisabled(bool val) {
    if (!kIsWeb) BnLog.info(text: 'setisMotionDetectionDisabled to $val');
    _hiveBox.put(_disableMotionDetection, val);
  }

  static const String _useAlternativeLocationProvider =
      'useAlternativeLocationProviderPref';

  ///get if motion detection is disabled
  static bool get useAlternativeLocationProvider {
    var val =
        _hiveBox.get(_useAlternativeLocationProvider, defaultValue: false);
    return val;
  }

  ///set if motion detection is disabled
  static void setUseAlternativeLocationProvider(bool val) {
    if (!kIsWeb) BnLog.info(text: 'setUseAlternativeLocationProvider to $val');
    _hiveBox.put(_useAlternativeLocationProvider, val);
  }

  static const String _hasShownProminentDisclosure =
      'hasShownProminentDisclosurePref';

  ///get if motion detection is disabled
  static bool get hasShownProminentDisclosure {
    var val = _hiveBox.get(_hasShownProminentDisclosure, defaultValue: false);
    return val;
  }

  ///set if motion detection is disabled
  static void setHasShownProminentDisclosure(bool val) {
    if (!kIsWeb) BnLog.info(text: 'set hasShownProminentDisclosure to $val');
    _hiveBox.put(_hasShownProminentDisclosure, val);
  }

  static const String _fLogLevel = 'fLogLevelPref';

  ///get loglevel FLog
  static Level get flogLogLevel {
    var levelIndex = _hiveBox.get(_fLogLevel, defaultValue: Level.info.index);
    return Level.values[levelIndex];
  }

  ///set loglevel
  static void setFlogLevel(Level level) {
    if (!kIsWeb) BnLog.info(text: 'setFlogLevel to ${level.index}');
    _hiveBox.put(_fLogLevel, level.index);
  }

  static const String _odometerKey = 'odometerKeyPref';

  ///get odometerValue
  static double get odometerValue {
    return _hiveBox.get(_odometerKey, defaultValue: 0.0);
  }

  ///set value of odometer
  static void setOdometerValue(double val) {
    _hiveBox.put(_odometerKey, val);
  }

  static const String iconSizeKey = 'iconSizeValKey';

  ///get iconSizeValue
  static double get iconSizeValue {
    var size = _hiveBox.get(iconSizeKey, defaultValue: 25.0);
    return size;
  }

  ///set value of iconSize
  static void setIconSizeValue(double size) {
    if (size < 15.0) {
      HiveSettingsDB.setIconSizeValue(15.0);
    }
    if (size > 60.0) {
      HiveSettingsDB.setIconSizeValue(60.0);
    }
    _hiveBox.put(iconSizeKey, size);
  }

  static const String _bgSettingVisibleKey = 'bgSettingVisibleKeyPref';

  static bool get bgSettingVisible {
    return _hiveBox.get(_bgSettingVisibleKey, defaultValue: false);
  }

  static void setBgSettingVisible(bool val) {
    _hiveBox.put(_bgSettingVisibleKey, val);
  }

  static const String _bgLeaderSettingVisibleKey =
      'bgLeaderSettingVisibleKeyPref';

  static bool get bgLeaderSettingVisible {
    return _hiveBox.get(_bgLeaderSettingVisibleKey, defaultValue: false);
  }

  static void setBgLeaderSettingVisible(bool val) {
    _hiveBox.put(_bgLeaderSettingVisibleKey, val);
  }

  static const String _mainSponsorImagePathKey = 'mainSponsorImagePathKeyPref';

  ///get mainSponsorImagePathValue
  static String get mainSponsorImagePath {
    return _hiveBox.get(_mainSponsorImagePathKey,
        defaultValue: mainSponsorPlaceholder);
  }

  static void setMainSponsorImagePath(String val) {
    _hiveBox.put(_mainSponsorImagePathKey, val);
  }

  static const String _secondSponsorImagePathKey =
      'secondSponsorImagePathKeyPref';

  ///get secondSponsorImagePathValue
  static String get secondSponsorImagePath {
    return _hiveBox.get(_secondSponsorImagePathKey,
        defaultValue: secondLogoPlaceholder);
  }

  static void setSecondSponsorImagePath(String val) {
    _hiveBox.put(_secondSponsorImagePathKey, val);
  }

  static const String _hasAskedAlwaysAllowLocationPermissionKey =
      'hasAskedAlwaysAllowLocationPermissionsPref';

  ///get hasAskedAlwaysAllowLocationPermission - see https://github.com/transistorsoft/flutter_background_geolocation/issues/925
  static bool get hasAskedAlwaysAllowLocationPermission {
    return _hiveBox.get(_hasAskedAlwaysAllowLocationPermissionKey,
        defaultValue: false);
  }

  ///set if  setHasAskedAlwaysAllowLocationPermissionPath were requested
  static void setHasAskedAlwaysAllowLocationPermission(bool val) {
    _hiveBox.put(_hasAskedAlwaysAllowLocationPermissionKey, val);
  }

  static const String _hasShownIntroKey = 'hasShownIntroPref';

  ///get hasShownIntro
  static bool get hasShownIntro {
    return _hiveBox.get(_hasShownIntroKey, defaultValue: false);
  }

  ///set if  setHasShownIntroPath were shown
  static void setHasShownIntro(bool val) {
    _hiveBox.put(_hasShownIntroKey, val);
  }

  static const String _pushNotificationsEnabledKey =
      'pushNotificationsEnabledPref';

  ///get pushNotificationsEnabled
  static bool get pushNotificationsEnabled {
    return _hiveBox.get(_pushNotificationsEnabledKey, defaultValue: true);
  }

  ///set if  setPushNotificationsEnabled were shown
  static void setPushNotificationsEnabled(bool val) {
    _hiveBox.put(_pushNotificationsEnabledKey, val);
  }

  static const String _oneSignalIdKey = 'oneSignalIdPref';

  ///get oneSignalId
  static String get oneSignalId {
    return _hiveBox.get(_oneSignalIdKey, defaultValue: 'noId');
  }

  ///set if  setOneSignalId were shown
  static void setOneSignalId(String val) {
    _hiveBox.put(_oneSignalIdKey, val);
  }

  static const String _isBladeGuardKey = 'isBladeGuardPref';

  ///get isBladeGuard
  static bool get isBladeGuard {
    return _hiveBox.get(_isBladeGuardKey, defaultValue: false);
  }

  ///set if  setIsBladeGuard were shown
  static void setIsBladeGuard(bool val) {
    _hiveBox.put(_isBladeGuardKey, val);
  }

  static const String _teamIdKey = 'teamIdPref';

  ///get teamId
  static int get teamId {
    return _hiveBox.get(_teamIdKey, defaultValue: 0);
  }

  ///set setTeamId for Bladeguard
  static void setTeamId(int val) {
    _hiveBox.put(_teamIdKey, val);
  }

  static const String _bladeGuardClickKey = 'bladeGuardClickPref';

  ///get bladeGuardClick
  static bool get bladeGuardClick {
    return _hiveBox.get(_bladeGuardClickKey, defaultValue: false);
  }

  ///set if  setbladeGuardClick were shown
  static void setBladeGuardClick(bool val) {
    _hiveBox.put(_bladeGuardClickKey, val);
  }

  static const String _rsvSkatemunichInfosKey = 'rsvSkatemunichInfosPref';

  ///get rsvSkatemunichInfos
  static bool get rcvSkatemunichInfos {
    return _hiveBox.get(_rsvSkatemunichInfosKey, defaultValue: false);
  }

  ///set if  setrsvSkatemunichInfos were shown
  static void setRcvSkatemunichInfos(bool val) {
    _hiveBox.put(_rsvSkatemunichInfosKey, val);
  }

  static const String _trackingActiveKey = 'trackingActiveKey';

  ///get Tracking is Active means locations updating is active
  static bool get trackingActive {
    return _hiveBox.get(_trackingActiveKey, defaultValue: false);
  }

  ///set if  setTrackingActive were requested
  static void setTrackingActive(bool val) {
    _hiveBox.put(_trackingActiveKey, val);
  }

  static const String _wakeLockEnabledKey = 'wakeLockEnabledKey';

  ///get Tracking is Active means locations updating is active
  static bool get wakeLockEnabled {
    return _hiveBox.get(_wakeLockEnabledKey, defaultValue: true);
  }

  ///set if  setTrackingActive were requested
  static void setWakeLockEnabled(bool val) {
    _hiveBox.put(_wakeLockEnabledKey, val);
  }

  static const String _headlessAllowedKey = 'headlessAllowedKey';

  ///get Tracking is Active means locations updating is active
  static bool get headlessAllowed {
    return _hiveBox.get(_headlessAllowedKey, defaultValue: false);
  }

  ///set if  setHeadlessAllowed were requested
  static void setHeadlessAllowed(bool val) {
    _hiveBox.put(_headlessAllowedKey, val);
  }

  static const String appOutDatedKey = 'appOutDatedKey';

  ///get Tracking is Active means locations updating is active
  static bool get appOutDated {
    return _hiveBox.get(appOutDatedKey, defaultValue: false);
  }

  ///set if  setAppOutDated were requested
  static void setAppOutDated(bool val) {
    _hiveBox.put(appOutDatedKey, val);
  }

  static const String _useCustomServerKey = 'useCustomServerKey';

  static bool get useCustomServer {
    return _hiveBox.get(_useCustomServerKey, defaultValue: false);
  }

  ///set if  set use CustomServer
  static void setUseCustomServer(bool val) {
    _hiveBox.put(_useCustomServerKey, val);
  }

  static const String _customServerAddressKey = 'customServerAddressKey';

  ///get Tracking is Active means locations updating is active
  static String get customServerAddress {
    return _hiveBox.get(_customServerAddressKey, defaultValue: '');
  }

  ///set if  setCustomServerAddress were requested
  static void setCustomServerAddress(String? val) {
    if (val == null) {
      _hiveBox.put(_customServerAddressKey, '');
    } else {
      _hiveBox.put(_customServerAddressKey, val);
    }
  }

  static bool get hasSpecialRights {
    return _hiveBox.get(_hasSpecialRightsPref, defaultValue: false);
  }

  static void setSpecialRightsPrefs(bool value) {
    _hiveBox.put(_hasSpecialRightsPref, value);
  }

  static bool get isHeadOfProcession {
    return _hiveBox.get(isHeadOfProcessionKey, defaultValue: false);
  }

  static void setIsSpecialHead(bool value) {
    _hiveBox.put(isHeadOfProcessionKey, value);
  }

  static bool get isTailOfProcession {
    return _hiveBox.get(isTailOfProcessionKey, defaultValue: false);
  }

  static void setIsSpecialTail(bool value) {
    _hiveBox.put(isTailOfProcessionKey, value);
  }

  static bool get wantSeeFullOfProcession {
    return _hiveBox.get(wantSeeFullOfProcessionKey, defaultValue: false);
  }

  static void setwantSeeFullOfProcession(bool value) {
    _hiveBox.put(wantSeeFullOfProcessionKey, value);
  }

  static void setSpecialRightsValuePrefs(int value) {
    _hiveBox.put(_specialRightsPref, value);
  }

  static int get specialCodeValue {
    if (isHeadOfProcession && isTailOfProcession) {
      return (wantSeeFullOfProcession ? 4 : 0);
    } else {
      return (isHeadOfProcession ? 1 : 0) +
          (isTailOfProcession ? 2 : 0) +
          (wantSeeFullOfProcession ? 4 : 0);
    }
  }

  static bool get userIsParticipant {
    return _hiveBox.get(_getUserIsParticipantKey, defaultValue: true);
  }

  static void setUserIsParticipant(bool isParticipant) {
    _hiveBox.put(_getUserIsParticipantKey, isParticipant);
  }

  static const String _myNameKey = 'myNamePref';

  ///get name to transfer vie lokal link
  static String get myName {
    return _hiveBox.get(_myNameKey, defaultValue: 'Anonym');
  }

  ///set MyName
  static void setMyName(String val) {
    _hiveBox.put(_myNameKey, val);
  }

  static const String _realTimeDataLastUpdate =
      'realTimeDataLastUpdatePref';

  ///get realTimeDataString DateTimeStamp
  static DateTime get realTimeDataLastUpdate {
    return _hiveBox.get(_realTimeDataLastUpdate,
        defaultValue: DateTime(2000, 1, 1, 0, 0, 0));
  }

  ///set realTimeDataString DateTimeStamp
  static void setRealTimeDataLastUpdate(DateTime val) {
    _hiveBox.put(_realTimeDataLastUpdate, val);
  }
  
  static const String _routePointsLastUpdate =
      'routePoints_routePointsLastUpdatePref';

  ///get RoutePointsstring DateTimeStamp
  static DateTime get routePointsLastUpdate {
    return _hiveBox.get(_routePointsLastUpdate,
        defaultValue: DateTime(2000, 1, 1, 0, 0, 0));
  }

  ///set RoutePointsstring DateTimeStamp
  static void setRoutePointsLastUpdate(DateTime val) {
    _hiveBox.put(_routePointsLastUpdate, val);
  }

  static const String _routePointsStringKey = 'routePointsStringPref';

  ///get RoutePoints
  static RoutePoints get routePoints {
    var rp = _hiveBox.get(_routePointsStringKey, defaultValue: '');
    if (rp as String == '') {
      return RoutePoints('', <LatLng>[]);
    } else {
      return RoutePointsMapper.fromJson(rp);
    }
  }

  ///get RoutePointsAsString
  static String get routePointsString {
    return _hiveBox.get(_routePointsStringKey, defaultValue: '');
  }

  static set setRoutePoints(RoutePoints routePoints) {
    setRoutePointsString(routePoints.toJson());
  }

  ///set RoutePointsString
  static void setRoutePointsString(String val) {
    _hiveBox.put(_routePointsStringKey, val);
    setRoutePointsLastUpdate(DateTime.now().toUtc());
  }

  static const String _actualEventLastUpdate =
      'actualEventString_actualEventStringLastUpdatePref';

  ///get actualEventString DateTimeStamp
  static DateTime get actualEventLastUpdate {
    return _hiveBox.get(_actualEventLastUpdate,
        defaultValue: DateTime(2000, 1, 1, 0, 0, 0));
  }

  ///set actualEventString DateTimeStamp
  static void setActualEventLastUpdate(DateTime val) {
    _hiveBox.put(_actualEventLastUpdate, val);
  }

  static const String _actualEventStringKey = 'actualEventStringPref';

  ///get actualEventStringAsString
  static String get actualEventAsJson {
    return _hiveBox.get(_actualEventStringKey, defaultValue: '');
  }

  ///Get actual [Event] from preferences and
  ///return saved event or if nothing saved [Event.init]
  static Event get getActualEvent {
    try {
      var jsonData = _hiveBox.get(_actualEventStringKey);
      if (jsonData != null) {
        return MapperContainer.globals.fromJson<Event>(jsonData);
      } else {
        return Event.init;
      }
    } catch (e) {
      Event event = Event.init;
      event.rpcException = e as Exception;
      return event;
    }
  }

  ///set actualEventStringString
  static void setActualEvent(Event event) {
    event.lastupdate = DateTime.now();
    String eventJson = MapperContainer.globals.toJson(event);
    _hiveBox.put(_actualEventStringKey, eventJson);
    setActualEventLastUpdate(DateTime.now());
  }

  static const String _imagesAndLinksDataKey = 'imagesAndLinksJsonPref';

  ///get imagesAndLinksJsonDataAsString
  static String get imagesAndLinksJson {
    return _hiveBox.get(_imagesAndLinksDataKey, defaultValue: '');
  }

  ///set imagesAndLinksDataString as Json
  static void setImagesAndLinksJson(String val) {
    _hiveBox.put(_imagesAndLinksDataKey, val);
  }

  static const String _eventsMapKey = 'eventsJsonPref';

  ///get imagesAndLinksJsonDataAsString
  static String get eventsJson {
    return _hiveBox.get(_eventsMapKey, defaultValue: '');
  }

  ///set eventsMapString as Json
  static void setEventsJson(String val) {
    _hiveBox.put(_eventsMapKey, val);
  }

  static const String _themeKey = 'dynamicTheme3Pref';

  ///get theme (Bright true/ dark false) without Adapter
  static AdaptiveThemeMode get adaptiveThemeMode {
    var val = _hiveBox.get(_themeKey,
        defaultValue: kIsWeb ? ThemeType.light.index : ThemeType.system.index);
    if (val == ThemeType.light.index) {
      return AdaptiveThemeMode.light;
    } else if (val == ThemeType.dark.index) {
      return AdaptiveThemeMode.dark;
    } else {
      return AdaptiveThemeMode.system;
    }
  }

  ///set themeString
  static void setAdaptiveThemeMode(AdaptiveThemeMode themeMode) {
    switch (themeMode) {
      case AdaptiveThemeMode.light:
        _hiveBox.put(_themeKey, ThemeType.light.index);
        break;
      case AdaptiveThemeMode.dark:
        _hiveBox.put(_themeKey, ThemeType.dark.index);
        break;
      case AdaptiveThemeMode.system:
        _hiveBox.put(_themeKey, ThemeType.system.index);
        break;
    }
  }
}

enum ThemeType { system, light, dark }
