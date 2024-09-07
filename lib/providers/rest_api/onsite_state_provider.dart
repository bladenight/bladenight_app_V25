import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../generated/l10n.dart';
import '../../helpers/hive_box/app_server_config_db.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/location_bearing_distance.dart';
import '../../helpers/location_permission_dialogs.dart';
import '../../helpers/logger.dart';
import '../../helpers/notification/notification_helper.dart';
import '../../models/event.dart';
import '../../models/result_or_error.dart';
import '../active_event_provider.dart';
import '../images_and_links/geofence_image_and_link_provider.dart';
import '../location_provider.dart';
import 'dio_rest_api_provider.dart';

part 'onsite_state_provider.g.dart';

class BladeGuardApiRepository {
  BladeGuardApiRepository({required this.dioClient});

  final Dio dioClient;

  String _getUrl({String? parameter}) {
    final url = ServerConfigDb.restApiLinkBg;
    if (parameter != null) {
      return '$url$parameter';
    } else {
      return url;
    }
  }

  ///Get TeamId
  Future<ResultStringOrError> checkBladeguardEmail(
      String email, DateTime birthday, String phone, String? pin) async {
    if (!email.contains('@')) {
      BnLog.error(
          text: 'invalid parameter --> not hashed',
          methodName: 'checkBladeguardEmail');
      return ResultStringOrError(null, 'invalid parameter --> email');
    }
    Map<String, String> qParams = {
      'code':
          sha512.convert(utf8.encode(email.trim().toLowerCase())).toString(),
      'email': email.toLowerCase().trim(),
      'birth':
          '${birthday.year}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}',
      'oneSignalId': HiveSettingsDB.oneSignalId
    };

    if (phone.length > 7) {
      qParams['phone'] = phone;
    }
    if (pin != null && pin.length > 4) {
      qParams['pin'] = pin;
    }

    try {
      final url = _getUrl(parameter: '/check');
      final response =
          await dioClient.post<String>(url, queryParameters: qParams);
      if (response.statusCode == 200) {
        if (response.data == '') {
          return ResultStringOrError(null, Localize.current.invalidLoginData);
        }
        var jsonResult = jsonDecode(response.data!);
        if (jsonResult is Map && jsonResult.keys.contains('fail')) {
          return ResultStringOrError(null, Localize.current.invalidLoginData);
        }
        if (jsonResult is Map) {
          return ResultStringOrError(response.data!, null);
        }
      } else {
        BnLog.warning(
            text: response.statusCode.toString(),
            methodName: 'checkBladeguardEmail');
      }
    } on DioException catch (e) {
      BnLog.warning(text: e.toString(), methodName: 'checkBladeguardEmail');
      if (e.response == null) {
        return ResultStringOrError(null, e.toString());
      }
      return ResultStringOrError(null, e.response!.statusCode.toString());
    } catch (e) {
      BnLog.warning(text: e.toString(), methodName: 'checkBladeguardEmail');
    }
    var res = ResultStringOrError(null, 'unknown');
    return res;
  }

  Future<ResultStringOrError> checkLoginState(String email) async {
    if (!email.contains('@')) {
      BnLog.error(
          text: 'invalid parameter --> email invalid $email',
          methodName: 'checkBladeguardEmail');
      return ResultStringOrError(null, 'invalid parameter --> email');
    }
    Map<String, String> qParams = {
      'code':
          sha512.convert(utf8.encode(email.trim().toLowerCase())).toString(),
      'email': email.toLowerCase().trim(),
    };

    try {
      final url = _getUrl(parameter: '/check');
      final response =
          await dioClient.get<String>(url, queryParameters: qParams);

      if (response.statusCode == 200) {
        if (response.data == '') {
          return ResultStringOrError(null, Localize.current.failed);
        }
        var jsonResult = jsonDecode(response.data!);
        if (jsonResult is Map && jsonResult.keys.contains('fail')) {
          return ResultStringOrError(null, Localize.current.failed);
        }
        if (jsonResult is Map) {
          return ResultStringOrError(response.data!, null);
        }
      } else {
        BnLog.warning(
            text: response.statusCode.toString(),
            methodName: 'checkLoginState');
      }
    } on DioException catch (e) {
      BnLog.warning(text: e.toString(), methodName: 'checkLoginState');
      if (e.response == null) {
        return ResultStringOrError(null, e.toString());
      }
      return ResultStringOrError(null, e.response!.statusCode.toString());
    } catch (e) {
      BnLog.warning(text: e.toString(), methodName: 'checkLoginState');
    }
    var res = ResultStringOrError(null, 'unknown');
    return res;
  }

  Future<ResultBoolOrError> checkBladeguardIsOnSite() async {
    var birthday = HiveSettingsDB.bladeguardBirthday;
    Map<String, dynamic> qParams = {
      'code': HiveSettingsDB.bladeguardSHA512Hash,
      'email': HiveSettingsDB.bladeguardEmail,
      'birth':
          '${birthday.year}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}',
    };
    try {
      var host = ServerConfigDb.restApiLinkBg;
      var apiLink = '$host/isOnSite';
      var response = await dioClient.get(apiLink, queryParameters: qParams);
      if (response.statusCode == 200) {
        if (response.data == '') {
          return ResultBoolOrError(null, Localize.current.failed);
        }
        if (response.data is Map && response.data.keys.contains('isOnSite')) {
          return ResultBoolOrError(response.data['isOnSite'], null);
        }
      } else {
        BnLog.warning(
            text: response.statusCode.toString(),
            methodName: 'checkBladeguardOnSite');
      }
    } on DioException catch (e) {
      BnLog.warning(text: e.toString(), methodName: 'checkBladeguardOnSite $e');
      if (e.response == null) {
        return ResultBoolOrError(null, e.toString());
      }
      return ResultBoolOrError(null, e.response!.statusCode.toString());
    } catch (e) {
      BnLog.warning(text: e.toString(), methodName: 'checkBladeguardOnSite');
    }
    return ResultBoolOrError(null, Localize.current.unknownerror);
  }

  Future<ResultBoolOrError> setBladeguardOnSite(bool onSite) async {
    var birthday = HiveSettingsDB.bladeguardBirthday;
    Map<String, dynamic> qParams = {
      'onSite': onSite,
      'code': HiveSettingsDB.bladeguardSHA512Hash,
      'email': HiveSettingsDB.bladeguardEmail,
      'birth':
          '${birthday.year}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}',
      'oneSignalId': HiveSettingsDB.oneSignalId
    };

    try {
      var host = ServerConfigDb.restApiLinkBg;
      var apiLink = '$host/setOnsite';
      var response = await dioClient.get(apiLink, queryParameters: qParams);
      if (response.statusCode == 200) {
        if (response.data == '') {
          return ResultBoolOrError(null, Localize.current.failed);
        }
        if (response.data is Map && response.data.keys.contains('isOnSite')) {
          return ResultBoolOrError(response.data['isOnSite'], null);
        } else if (response.data is Map &&
            response.data.keys.contains('fail')) {
          return ResultBoolOrError(null, response.data['error']);
        }
      } else {
        BnLog.warning(
            text: response.statusCode.toString(),
            methodName: 'setBladeguardOnSite');
      }
    } on DioException catch (e) {
      BnLog.warning(text: e.toString(), methodName: 'setBladeguardOnSite $e');
      if (e.response == null) {
        return ResultBoolOrError(null, e.toString());
      }
      return ResultBoolOrError(null, e.response!.statusCode.toString());
    } catch (e) {
      BnLog.warning(text: e.toString(), methodName: 'setBladeguardOnSite');
    }
    return ResultBoolOrError(null, 'unknown');
  }
}

@riverpod
BladeGuardApiRepository bladeGuardApiRepository(
        BladeGuardApiRepositoryRef ref) =>
    BladeGuardApiRepository(dioClient: ref.read(dioProvider));

@riverpod
Future<ResultStringOrError> checkBladeguardMail(CheckBladeguardMailRef ref,
    String email, DateTime birthday, String phone, String? pin) async {
  final repo = ref.read(bladeGuardApiRepositoryProvider);
  return repo.checkBladeguardEmail(email, birthday, phone, pin);
}

@riverpod
class BgIsOnSite extends _$BgIsOnSite {
  @override
  FutureOr<bool> build() async {
    if (!HiveSettingsDB.bgSettingVisible) {
      state = const AsyncValue.data(false);
      return false;
    }
    var gfEvPrv = ref.listen(geoFenceEventProvider, (previous, next) {
      ref.invalidateSelf();
    });
    ref.onDispose(() {
      gfEvPrv.close();
    });
    final repo = ref.read(bladeGuardApiRepositoryProvider);
    try {
      var res = await repo.checkBladeguardIsOnSite();
      if (res.errorDescription != null) {
        state = AsyncValue.error(res.errorDescription!, StackTrace.current);
        return false;
      }
      if (res.result != null) {
        state = AsyncValue.data(res.result!);
        return res.result!;
      }
    } catch (e) {
      state = AsyncValue.error(Localize.current.failed, StackTrace.current);
    }

    return true;
  }

  /// Set onsite state related to current position
  Future<void> setOnSiteState(bool isOnsite,
      {bool triggeredByGeofence = false}) async {
    var minDist = double.maxFinite;
    if (state == const AsyncValue.loading()) {
      return;
    }
    state = const AsyncValue.loading();
    if (!isOnsite) {
      await _sendToServer(isOnsite);
      return;
    }

    if (state == const AsyncValue.data(true)) {
      return;
    }

    //validate position
    var geofence = await ref.read(geofencePointsProvider.future);
    var event = ref.read(activeEventProvider);

    if (event.status != EventStatus.confirmed) {
      final repo = ref.read(bladeGuardApiRepositoryProvider);
      try {
        var res = await repo.checkBladeguardIsOnSite();
        if (res.errorDescription != null) {
          state = AsyncValue.error(res.errorDescription!, StackTrace.current);
          return;
        }
        if (res.result != null) {
          state = AsyncValue.data(res.result!);
          return;
        }
      } catch (e) {
        state = AsyncValue.error(Localize.current.failed, StackTrace.current);
      }
      return;
    }

    if (triggeredByGeofence) {
      var res = await _sendToServer(isOnsite);
      if (res == true) {
        NotificationHelper().showString(
            id: Random().nextInt(2 ^ 8),
            text: Localize.current.bgTodayIsRegistered,
            title: 'Bladeguard am Startpunkt');
        HiveSettingsDB.setBladeguardLastSetOnsite(DateTime.now());
      }
    } else {
      if (LocationProvider().gpsLocationPermissionsStatus !=
              LocationPermissionStatus.always &&
          LocationProvider().gpsLocationPermissionsStatus !=
              LocationPermissionStatus.whenInUse) {
        state = AsyncValue.error(
            Localize.current.noLocationPermitted, StackTrace.current);
      }

      var location = await LocationProvider().getLocation();
      if (location == null) {
        state = AsyncValue.error(
            Localize.current.noLocationAvailable, StackTrace.current);
        return;
      }
      for (var geofencePoint in geofence) {
        var dist = GeoLocationHelper.haversine(location.coords.latitude,
            location.coords.longitude, geofencePoint.lat, geofencePoint.lon);
        minDist = min(dist, minDist);
        if (dist <= geofencePoint.radius || kDebugMode) {
          await _sendToServer(isOnsite);
          return;
        }
      }
    }
    state = AsyncValue.error(
        Localize.current.mustNearbyStartingPoint(minDist.toStringAsFixed(0)),
        StackTrace.current);
    return;
  }

  Future<bool> _sendToServer(bool isOnsite) async {
    BnLog.info(
        text: 'SendOnsite to Server $isOnsite',
        methodName: '_sendToServer',
        className: toString());
    final repo = ref.read(bladeGuardApiRepositoryProvider);
    var res = await repo.setBladeguardOnSite(isOnsite);
    if (res.errorDescription != null) {
      state = AsyncValue.error(res.errorDescription!, StackTrace.current);
      BnLog.info(
          text: 'SendOnsite to Server $isOnsite failed',
          methodName: '_sendToServer',
          className: toString());
      return false;
    } else {
      state = AsyncValue.data(res.result!);
      BnLog.info(
          text: 'SendOnsite to Server $isOnsite successful ',
          methodName: '_sendToServer',
          className: toString());
      return true;
    }
  }
}
