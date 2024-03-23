import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../generated/l10n.dart';
import '../../helpers/hive_box/app_server_config_db.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/logger.dart';
import '../../models/result_or_error.dart';
import 'dio_rest_api_provider.dart';

part 'onsite_state_provider.g.dart';

class BladeGuardApiRepository {
  BladeGuardApiRepository({required this.dioClient});

  final Dio dioClient;

  String _getUrl({String? parameter}) {
    final url = ServerConfigDb.restApiLink;
    if (parameter != null) {
      return '$url$parameter';
    } else {
      return url;
    }
  }

  ///Get TeamId
  Future<ResultOrError> checkBladeguardEmail(
      String hashcode, DateTime birthday, String phone, String? pin) async {
    if (hashcode.contains('@')) {
      BnLog.error(
          text: 'invalid parameter --> not hashed',
          methodName: 'checkBladeguardEmail');
      return ResultOrError(null, 'invalid parameter --> not hashed');
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
          return ResultOrError(null, Localize.current.invalidLoginData);
        }
        var jsonResult = jsonDecode(response.data!);
        if (jsonResult is Map && jsonResult.keys.contains('fail')) {
          return ResultOrError(null, Localize.current.invalidLoginData);
        }
        if (jsonResult is Map) {
          return ResultOrError(response.data!, null);
        }
      } else {
        BnLog.warning(
            text: response.statusCode.toString(),
            methodName: 'checkBladeguardEmail');
      }
    } on DioException catch (e) {
      BnLog.warning(text: e.toString(), methodName: 'checkBladeguardEmail');
      if (e.response == null) {
        return ResultOrError(null, e.toString());
      }
      return ResultOrError(null, e.response!.statusCode.toString());
    } catch (e) {
      BnLog.warning(text: e.toString(), methodName: 'checkBladeguardEmail');
    }
    var res = ResultOrError(null, 'unknown');
    return res;
  }

  Future<ResultOrError> checkLoginState(String hashcode) async {
    if (hashcode.contains('@')) {
      BnLog.error(
          text: 'invalid parameter --> not hashed',
          methodName: 'checkBladeguardEmail');
      return ResultOrError(null, 'invalid parameter --> not hashed');
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
          return ResultOrError(null, Localize.current.invalidEMail);
        }

        return ResultOrError(response.data!, null);
      } else {
        BnLog.warning(
            text: response.statusCode.toString(),
            methodName: 'checkLoginState');
      }
    } on DioException catch (e) {
      BnLog.warning(text: e.toString(), methodName: 'checkLoginState');
      if (e.response == null) {
        return ResultOrError(null, e.toString());
      }
      return ResultOrError(null, e.response!.statusCode.toString());
    } catch (e) {
      BnLog.warning(text: e.toString(), methodName: 'checkLoginState');
    }
    var res = ResultOrError(null, 'unknown');
    return res;
  }

  Future<ResultOrError> checkBladeguardIsOnSite(String hash) async {
    Map<String, String> qParams = {
      'code': hash,
    };

    try {
      var host = ServerConfigDb.restApiLink;
      var apiLink = '$host/isOnSite';
      var response = await dioClient.get(apiLink, queryParameters: qParams);
      if (response.statusCode == 200) {
        if (response.data == '') {
          return ResultOrError(null, Localize.current.failed);
        }
        if (response.data is Map && response.data.keys.contains('isOnSite')) {
          return ResultOrError(response.data['isOnSite'].toString(), null);
        }
      } else {
        BnLog.warning(
            text: response.statusCode.toString(),
            methodName: 'checkBladeguardOnSite');
      }
    } on DioException catch (e) {
      BnLog.warning(text: e.toString(), methodName: 'checkBladeguardOnSite $e');
      if (e.response == null) {
        return ResultOrError(null, e.toString());
      }
      return ResultOrError(null, e.response!.statusCode.toString());
    } catch (e) {
      BnLog.warning(text: e.toString(), methodName: 'checkBladeguardOnSite');
    }
    return ResultOrError(null, 'unknown');
  }

  Future<ResultOrError> setBladeguardOnSite(bool onSite, String hash) async {
    Map<String, dynamic> qParams = {
      'onSite': onSite,
      'code': hash,
      'birth':HiveSettingsDB.bladeguardBirthday,
      'oneSignalId': HiveSettingsDB.oneSignalId
    };

    try {
      var host = ServerConfigDb.restApiLink;
      var apiLink = '$host/setOnsite';
      var response = await dioClient.get(apiLink, queryParameters: qParams);
      if (response.statusCode == 200) {
        if (response.data == '') {
          return ResultOrError(null, Localize.current.failed);
        }
        if (response.data is Map && response.data.keys.contains('result')) {
          return ResultOrError(response.data['result'].toString(), null);
        }
      } else {
        BnLog.warning(
            text: response.statusCode.toString(),
            methodName: 'setBladeguardOnSite');
      }
    } on DioException catch (e) {
      BnLog.warning(text: e.toString(), methodName: 'setBladeguardOnSite $e');
      if (e.response == null) {
        return ResultOrError(null, e.toString());
      }
      return ResultOrError(null, e.response!.statusCode.toString());
    } catch (e) {
      BnLog.warning(text: e.toString(), methodName: 'setBladeguardOnSite');
    }
    return ResultOrError(null, 'unknown');
  }

  Future<ResultOrError> getOnSiteState(bool onSite, String hash) async {
    Map<String, String> qParams = {
      'onsite': onSite.toString(),
      'code': hash,
      'oneSignalId': HiveSettingsDB.oneSignalId
    };

    try {
      var host = ServerConfigDb.restApiLink;
      var apiLink = '$host/check';
      var response = await dioClient.get(apiLink, queryParameters: qParams);
      if (response.statusCode == 200) {
        return ResultOrError(response.data, null);
      } else {
        BnLog.warning(
            text: response.statusCode.toString(),
            methodName: 'checkBladeguardOnSite');
      }
    } on DioException catch (e) {
      BnLog.warning(text: e.toString(), methodName: 'checkBladeguardOnSite $e');
      if (e.response == null) {
        return ResultOrError(null, e.toString());
      }
      return ResultOrError(null, e.response!.statusCode.toString());
    } catch (e) {
      BnLog.warning(text: e.toString(), methodName: 'checkBladeguardOnSite');
    }
    return ResultOrError(null, 'unknown');
  }
}

@riverpod
BladeGuardApiRepository bladeGuardApiRepository(
        BladeGuardApiRepositoryRef ref) =>
    BladeGuardApiRepository(dioClient: ref.read(dioProvider));

@riverpod
Future<ResultOrError> setOnSiteState(
    SetOnSiteStateRef ref, bool isOnSite, String emailHash) async {
  BnLog.info(text: 'setOnSiteState $isOnSite');
  final repo = ref.read(bladeGuardApiRepositoryProvider);
  return repo.setBladeguardOnSite(isOnSite, emailHash);
}

@riverpod
Future<ResultOrError> fetchOnSiteState(
    FetchOnSiteStateRef ref, String emailHash) async {
  BnLog.info(text: 'fetchOnSiteState');
  final repo = ref.read(bladeGuardApiRepositoryProvider);
  return repo.checkBladeguardIsOnSite(emailHash);
}

@riverpod
Future<ResultOrError> checkBladeguardMail(CheckBladeguardMailRef ref,
    String emailHash, DateTime birthday, String phone, String? pin) async {
  final repo = ref.read(bladeGuardApiRepositoryProvider);
  return repo.checkBladeguardEmail(emailHash, birthday, phone, pin);
}
