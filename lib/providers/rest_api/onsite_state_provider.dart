import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../generated/l10n.dart';
import '../../helpers/hive_box/app_server_config_db.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/logger.dart';
import '../../models/result_or_error.dart';
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
      String hashcode, DateTime birthday, String phone, String? pin) async {
    if (hashcode.contains('@')) {
      BnLog.error(
          text: 'invalid parameter --> not hashed',
          methodName: 'checkBladeguardEmail');
      return ResultStringOrError(null, 'invalid parameter --> not hashed');
    }
    Map<String, String> qParams = {
      'code': hashcode,
      'birth':
          '${birthday.year}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}'
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

  Future<ResultStringOrError> checkLoginState(String hashcode) async {
    if (hashcode.contains('@')) {
      BnLog.error(
          text: 'invalid parameter --> not hashed',
          methodName: 'checkBladeguardEmail');
      return ResultStringOrError(null, 'invalid parameter --> not hashed');
    }
    Map<String, String> qParams = {
      'code': hashcode,
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
        }
        else if (response.data is Map && response.data.keys.contains('fail')) {
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
    String emailHash, DateTime birthday, String phone, String? pin) async {
  final repo = ref.read(bladeGuardApiRepositoryProvider);
  return repo.checkBladeguardEmail(emailHash, birthday, phone, pin);
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

  Future<void> setOnSiteState(bool isOnSite) async {
    if (state == const AsyncValue.loading()) {
      return;
    }
    state = const AsyncValue.loading();
    final repo = ref.read(bladeGuardApiRepositoryProvider);
    var res = await repo.setBladeguardOnSite(isOnSite);
    if (res.errorDescription != null) {
      state = AsyncValue.error(res.errorDescription!, StackTrace.current);
    } else {
      state = AsyncValue.data(res.result!);
    }
  }
}
