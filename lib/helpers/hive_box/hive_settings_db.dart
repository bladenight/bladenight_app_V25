import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_logger/talker_logger.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../app_settings/app_constants.dart';
import '../../models/event.dart';
import '../../models/follow_location_state.dart';
import '../../models/route.dart';
import '../../models/user_gpx_point.dart';
import '../logger/logger.dart';
import '../notification/onesignal_handler.dart';
import '../time_converter_helper.dart';
import '../uuid_helper.dart';
import '../validator.dart';

part 'location_store_db.dart';

part 'map_settings_db.dart';

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
    return Hive.box(hiveBoxSettingDbName);
  }

  static get _locationHiveBox {
    return Hive.box(hiveBoxLocationDbName);
  }

  static get settingsHiveBox {
    return _hiveBox;
  }

  void init() async {
    setSessionShortUUID(UUID.createShortUuid());
    //not working here
    //await Hive.initFlutter();
    //await Hive.openBox('settings');
  }

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
    return _hiveBox.get(_bgLoglevelKey, defaultValue: bg.Config.LOG_LEVEL_OFF);
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

  static const String _disableMotionDetectionKey = 'disableMotionDetectionPref';

  ///get if motion detection is disabled
  static bool get isMotionDetectionDisabled {
    var val = _hiveBox.get(_disableMotionDetectionKey, defaultValue: false);
    return val;
  }

  ///set if motion detection is disabled
  static void setIsMotionDetectionDisabled(bool val) {
    if (!kIsWeb) BnLog.info(text: 'setisMotionDetectionDisabled to $val');
    _hiveBox.put(_disableMotionDetectionKey, val);
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
    BnLog.info(text: 'set hasShownProminentDisclosure to $val');
    _hiveBox.put(_hasShownProminentDisclosure, val);
  }

  static const String _hasShownMotionProminentDisclosureKey =
      'hasShownMotionProminentDisclosurePref';

  ///get if motion detection is disabled
  static bool get hasShownMotionProminentDisclosure {
    var val = _hiveBox.get(_hasShownMotionProminentDisclosureKey,
        defaultValue: false);
    return val;
  }

  ///set if motion detection is disabled
  static void setHasShownMotionProminentDisclosure(bool val) {
    BnLog.info(text: 'set hasShownMotionProminentDisclosure to $val');
    _hiveBox.put(_hasShownMotionProminentDisclosureKey, val);
  }

  static const String _fLogLevel = 'talkerLogLevelPref';

  ///get loglevel FLog
  static LogLevel get flogLogLevel {
    var levelIndex = _hiveBox.get(_fLogLevel, defaultValue: Level.info.index);
    return LogLevel.values[levelIndex];
  }

  ///set loglevel
  static void setFlogLevel(LogLevel level) {
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

  static const String bgSettingVisibleKey = 'bgSettingVisibleKeyPref';

  static bool get bgSettingVisible {
    return _hiveBox.get(bgSettingVisibleKey, defaultValue: false);
  }

  static void setBgSettingVisible(bool val) async {
    _hiveBox.put(bgSettingVisibleKey, val);
    if (val == false) {
      setBgLeaderSettingVisible(false);
      setIsSpecialTail(false);
      setIsSpecialHead(false);
      setWantSeeFullOfProcession(false);
      setHasSpecialRightsPrefs(false);
      await setBgIsAdmin(false);
      await setBladeguardPin(null);
      await setServerPassword(null);

      await OnesignalHandler.unRegisterPushAsBladeGuard();
      //including remove special rights
    }
  }

  static const String bgLeaderSettingVisibleKey =
      'bgLeaderSettingVisibleKeyPref';

  static bool get bgLeaderSettingVisible {
    return _hiveBox.get(bgLeaderSettingVisibleKey, defaultValue: false);
  }

  static void setBgLeaderSettingVisible(bool val) {
    _hiveBox.put(bgLeaderSettingVisibleKey, val);
  }

  static const String _mainSponsorImagePathKey = 'mainSponsorImagePathKeyPref';

  ///get mainSponsorImagePathValue
  static String get mainSponsorImagePath {
    return _hiveBox.get(_mainSponsorImagePathKey,
        defaultValue: emptySponsorPlaceholder);
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

  static const String _hasAskedPreciseLocationKey =
      'hasAskedPreciseLocationPref';

  ///get hasAskedAlwaysAllowLocationPermission - see https://github.com/transistorsoft/flutter_background_geolocation/issues/925
  static bool get hasAskedPreciseLocation {
    return _hiveBox.get(_hasAskedPreciseLocationKey, defaultValue: false);
  }

  ///set if  setHasAskedAlwaysAllowLocationPermissionPath were requested
  static void setHasPreciseLocationAsked(bool val) {
    _hiveBox.put(_hasAskedPreciseLocationKey, val);
  }

  static const String _firstStartKey = '2404firstStartPref';

  ///get firstStart
  static bool get firstStart {
    return _hiveBox.get(_firstStartKey, defaultValue: true);
  }

  ///set if  setFirstStart
  static void setFirstStart(bool val) {
    _hiveBox.put(_firstStartKey, val);
  }

  static const String _firstStart2421Key = 'first_Start_2421';

  ///get firstStart
  static bool get firstStart2421 {
    return _hiveBox.get(_firstStart2421Key, defaultValue: true);
  }

  ///set if  setFirstStart
  static void setFirstStart2421(bool val) {
    _hiveBox.put(_firstStart2421Key, val);
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

  static const String _hasShownBladeGuardKey = 'hasShownBladeGuardPref';

  ///get hasShownBladeGuard
  static bool get hasShownBladeGuard {
    return _hiveBox.get(_hasShownBladeGuardKey, defaultValue: false);
  }

  ///set if  setHasShownBladeGuardPath were shown
  static void setHasShownBladeGuard(bool val) {
    _hiveBox.put(_hasShownBladeGuardKey, val);
  }

  static const String _chrashlyticsEnabledKey = 'chrashlyticsEnabledPref';

  ///Firebase Chrashlytics enabled
  static bool get chrashlyticsEnabled {
    return _hiveBox.get(_chrashlyticsEnabledKey, defaultValue: true);
  }

  ///set if  setChrashlyticsEnabled were shown
  static void setChrashlyticsEnabled(bool val) {
    _hiveBox.put(_chrashlyticsEnabledKey, val);
  }

  static const String _pushNotificationsEnabledKey =
      'pushNotificationsEnabledPref';

  ///get pushNotificationsEnabled
  static bool get pushNotificationsEnabled {
    return _hiveBox.get(_pushNotificationsEnabledKey, defaultValue: true);
  }

  ///set if  setPushNotificationsEnabled were shown
  static Future<void> setPushNotificationsEnabled(bool val) async {
    await _hiveBox.put(_pushNotificationsEnabledKey, val);
  }

  static const String _appIdKey = 'appIdPref';

  ///get appId
  static String get appId {
    return _hiveBox.get(_appIdKey, defaultValue: '');
  }

  ///set if  setAppId were shown
  static Future<void> setAppId(String val) async {
    await _hiveBox.put(_appIdKey, val);
  }

  static const String oneSignalIdKey = 'oneSignalIdPref';

  ///get oneSignalId
  static String get oneSignalId {
    return _hiveBox.get(oneSignalIdKey, defaultValue: '');
  }

  ///set if  setOneSignalId were shown
  static Future<void> setOneSignalId(String val) async {
    _hiveBox.put(oneSignalIdKey, val);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(oneSignalId, val);
  }

  static const String serverPasswordKey = 'serverPasswordPref';

  ///get serverPassword
  static String? get serverPassword {
    return _hiveBox.get(serverPasswordKey, defaultValue: null);
  }

  ///set if  setServerPassword were shown
  static Future<void> setServerPassword(String? val) async {
    if (val == null) {
      _hiveBox.delete(serverPasswordKey);
      return;
    }
    await _hiveBox.put(serverPasswordKey, val);
  }

  static const String isBladeGuardKey = 'isBladeGuardPref';

  ///get isBladeGuard
  static bool get isBladeGuard {
    return _hiveBox.get(isBladeGuardKey, defaultValue: false);
  }

  ///set if  setIsBladeGuard user is bg
  static void setIsBladeGuard(bool val) {
    _hiveBox.put(isBladeGuardKey, val);
  }

  static const String _wasBladeGuardReqShownKey = 'wasBladeGuardReqShownPref';

  ///get wasBladeGuardReqShown
  static bool get wasBladeGuardReqShown {
    return _hiveBox.get(_wasBladeGuardReqShownKey, defaultValue: false);
  }

  ///set if  setWasBladeGuardReqShown were shown
  static void setWasBladeGuardReqShown(bool val) {
    _hiveBox.put(_wasBladeGuardReqShownKey, val);
  }

  static const String bladeguardLastSetOnsiteKey =
      'bladeguardLastSetOnsitePref';

  ///get bladeguardLastSetOnsite
  static DateTime get bladeguardLastSetOnsite {
    return _hiveBox.get(bladeguardLastSetOnsiteKey,
        defaultValue: DateTime.now().subtract(const Duration(days: 365)));
  }

  ///set Bladeguard onsite timestamp for Bladeguard
  static Future<void> setBladeguardLastSetOnsite(DateTime val) async {
    _hiveBox.put(bladeguardLastSetOnsiteKey, val);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(bladeguardEmailKey, val.toDateOnlyString());
  }

  static const String bladeguardEmailKey = 'bladeguardEmailPref';

  ///get bladeguardEmail
  static String get bladeguardEmail {
    return _hiveBox.get(bladeguardEmailKey, defaultValue: '');
  }

  ///get Bladeguard email as SHA512
  static String get bladeguardSHA512Hash {
    var email = _hiveBox.get(bladeguardEmailKey, defaultValue: '');
    if (email != null && email != '') {
      return sha512.convert(utf8.encode(email.trim().toLowerCase())).toString();
    }
    return '';
  }

  ///set BladeguardEmail for Bladeguard
  static Future<void> setBladeguardEmail(String val) async {
    checkBladeguardEmailValid(val);
    _hiveBox.put(bladeguardEmailKey, val.toLowerCase().trim());
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(bladeguardEmailKey, val);
  }

  static const String isBladeguardEmailValidKey = 'bladeguardEmailValidPref';

  ///get bladeguardEmailValid
  static bool get bladeguardEmailValid {
    return validateEmail(bladeguardEmail);
  }

  ///set if  setBladeguardEmailValid were shown
  static checkBladeguardEmailValid(String val) {
    _hiveBox.put(
        isBladeguardEmailValidKey, validateEmail(val.toLowerCase().trim()));
  }

  static const String bladeguardBirthdayKey = 'bladeguardBirthdayPref';

  ///get bladeguardBirthday
  static DateTime get bladeguardBirthday {
    return _hiveBox.get(bladeguardBirthdayKey,
        defaultValue:
            DateTime.now().subtract(const Duration(days: 16 * 365 + 4)));
  }

  ///set BladeguardPhone for Bladeguard
  static void setBladeguardBirthday(DateTime val) async {
    final prefs = await SharedPreferences.getInstance();
    _hiveBox.put(bladeguardBirthdayKey, val);
    prefs.setString(
        bladeguardBirthdayKey, '${val.year}-${val.month}-${val.day}');
  }

  static const String bladeguardPhoneKey = 'bladeguardPhonePref';

  ///get bladeguardPhone
  static String get bladeguardPhone {
    return _hiveBox.get(bladeguardPhoneKey, defaultValue: '');
  }

  ///set BladeguardPhone for Bladeguard
  static void setBladeguardPhone(String val) {
    _hiveBox.put(bladeguardPhoneKey, val);
  }

  static const String bladeguardPinKey = 'bladeguardPinPref';

  ///get bladeguardPin
  static String? get bladeguardPin {
    return _hiveBox.get(bladeguardPinKey);
  }

  ///set BladeguardPin for Bladeguard
  static Future<void> setBladeguardPin(String? val) async {
    await _hiveBox.put(bladeguardPinKey, val);
  }

  static const String _bgTeamKey = 'bgTeamPref';

  ///get teamId
  static String get bgTeam {
    return _hiveBox.get(_bgTeamKey, defaultValue: '');
  }

  ///set TeamId for Bladeguard
  static void setBgTeam(String val) {
    _hiveBox.put(_bgTeamKey, val);
  }

  static const String _bgIsAdminKey = 'bgIsAdminPref';

  ///get isAdmin
  static bool get bgIsAdmin {
    return _hiveBox.get(_bgIsAdminKey, defaultValue: false);
  }

  ///set IsAdmin for Bladeguard
  static Future<void> setBgIsAdmin(bool val) async {
    await _hiveBox.put(_bgIsAdminKey, val);
  }

  static const String setOnsiteGeoFencingKey = 'setOnsiteGeoFencingPref';

  ///Bladeguard is registered for GeoFencing
  static bool get onsiteGeoFencingActive {
    return _hiveBox.get(setOnsiteGeoFencingKey, defaultValue: false);
  }

  ///Set if Bladeguard is registered for OneSignalPush
  static Future<void> setSetOnsiteGeoFencingActive(bool val) async {
    _hiveBox.put(setOnsiteGeoFencingKey, val);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(setOnsiteGeoFencingKey, val);
  }

  ///Set if Bladeguard is registered for OneSignalPush
  static Future<void> setSetOnsiteGeoFencingActiveAsync(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.reload();
    prefs.setBool(setOnsiteGeoFencingKey, val);
    return _hiveBox.put(setOnsiteGeoFencingKey, val);
  }

  static const String _oneSignalRegisterBladeGuardPushKey =
      'oneSignalRegisterBladeGuardPushPref';

  ///Bladeguard is registered for OneSignalPush
  static bool get oneSignalRegisterBladeGuardPush {
    return _hiveBox.get(_oneSignalRegisterBladeGuardPushKey,
        defaultValue: false);
  }

  ///Set if Bladeguard is registered for OneSignalPush
  static void setOneSignalRegisterBladeGuardPush(bool val) {
    _hiveBox.put(_oneSignalRegisterBladeGuardPushKey, val);
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

  static const String autoStopTrackingEnabledKey = 'autoStopTrackingEnabledKey';

  ///get Tracking is Active means locations updating is active
  static bool get autoStopTrackingEnabled {
    return _hiveBox.get(autoStopTrackingEnabledKey, defaultValue: true);
  }

  ///set if  setAutoStopTrackingEnabled were requested
  static void setAutoStopTrackingEnabled(bool val) {
    _hiveBox.put(autoStopTrackingEnabledKey, val);
  }

  static const String autoStartTrackingEnabledKey =
      'autoStartTrackingEnabledKey';

  ///get Tracking is Active means locations updating is active
  static bool get autoStartTrackingEnabled {
    return _hiveBox.get(autoStartTrackingEnabledKey, defaultValue: false);
  }

  ///set if  setAutoStopEnabled were requested
  static void setAutoStartTrackingEnabled(bool val) {
    _hiveBox.put(autoStartTrackingEnabledKey, val);
  }

  static const String trackingFirstStartKey = 'trackingFirstStartKey';

  ///get Tracking is Active means locations updating is active
  static bool get trackingFirstStart {
    return _hiveBox.get(trackingFirstStartKey, defaultValue: true);
  }

  ///set if  setAutoStopEnabled were requested
  static void setTrackingFirstStart(bool val) {
    _hiveBox.put(trackingFirstStartKey, val);
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

  static const String serverVersionKey = 'serverVersionKey';

  ///get current serverversion
  static String get getServerVersion {
    return _hiveBox.get(serverVersionKey, defaultValue: '-----');
  }

  ///set if  serverversion on shakehand
  static void setServerVersion(String? val) {
    _hiveBox.put(serverVersionKey, val);
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

  static void setHasSpecialRightsPrefs(bool value) {
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

  static void setWantSeeFullOfProcession(bool value) {
    _hiveBox.put(wantSeeFullOfProcessionKey, value);
  }

  static void setSpecialRightsValuePrefs(int value) {
    _hiveBox.put(_specialRightsPref, value);
  }

  static int get specialCodeValue {
    var isBg = HiveSettingsDB.isBladeGuard;
    if (isBg &&
        !isHeadOfProcession &&
        !isTailOfProcession &&
        !wantSeeFullOfProcession) {
      return 98;
    }
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

  static const String _realTimeDataLastUpdate = 'realTimeDataLastUpdatePref';

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
  static Future<void> setActualEvent(Event event) async {
    event.lastUpdate = DateTime.now();
    String eventJson = MapperContainer.globals.toJson(event);
    _hiveBox.put(_actualEventStringKey, eventJson);
    setActualEventLastUpdate(DateTime.now());
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('eventConfirmed', event.status == EventStatus.confirmed);
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

  //Colors
  static const String meColorKey = 'meColorPref';

  ///get me Color for location icon etc.
  static Color get meColor {
    return _hiveBox.get(meColorKey, defaultValue: meDefaultColor);
  }

  ///set me Color for location icon etc.
  static void setMeColor(Color val) {
    _hiveBox.put(meColorKey, val);
  }

  static const String themePrimaryLightColorKey = 'primaryLightColorPref';

  ///get ThemePrimaryLightColor
  static Color get themePrimaryLightColor {
    return _hiveBox.get(themePrimaryLightColorKey,
        defaultValue: systemPrimaryDefaultColor);
  }

  ///set ThemePrimaryLightColor
  static void setThemePrimaryLightColor(Color val) {
    _hiveBox.put(themePrimaryLightColorKey, val);
  }

  static const String themePrimaryDarkColorKey = 'primaryDarkColorPref';

  ///get ThemePrimaryDarkColor
  static Color get themePrimaryDarkColor {
    var val = _hiveBox.get(themePrimaryDarkColorKey,
        defaultValue: systemPrimaryDarkDefaultColor);
    return val;
  }

  ///set ThemePrimaryDarkColor
  static void setThemePrimaryDarkColor(Color val) {
    _hiveBox.put(themePrimaryDarkColorKey, val);
  }
}

enum ThemeType { system, light, dark }
