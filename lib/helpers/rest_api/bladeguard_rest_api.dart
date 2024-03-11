import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../app_settings/server_connections.dart';
import '../logger.dart';

class IntOrError {
  int? integer;
  String? errorDescription;

  setInteger(int integer) {
    this.integer = integer;
  }

  setException(String errorDescription) {
    this.errorDescription = errorDescription;
  }
}

Future<IntOrError> checkBladeguardEmail(String hashcode) async {
  if (hashcode.contains('@')) {
    BnLog.error(
        text: 'invalid parameter --> not hashed',
        methodName: 'checkBladeguardEmail');
    return IntOrError().setException('invalid parameter --> not hashed');
  }
  var dio = Dio();
  var options = Options(
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10));
  options.contentType = 'application/json';
  Map<String, String> qParams = {
    'code': hashcode,
  };

  try {
    var apilink = '$bladenightRestApiServerLink/checkUserEmail';
    if (kDebugMode) {
      apilink = 'http://192.168.10.31:8888/checkUserEmail.php';
    }
    var response =
        await dio.get(apilink, options: options, queryParameters: qParams);
    if (response.statusCode == 200) {
      var jsonResult = jsonDecode(response.data);
      if (jsonResult is Map && jsonResult.keys.contains('team')) {
        var teamId = int.parse(jsonResult['team']);
        return IntOrError().setInteger(teamId);
      }
    } else {
      BnLog.warning(
          text: response.statusCode.toString(),
          methodName: 'checkBladeguardEmail');
    }
  } on DioException catch (e) {
    BnLog.warning(text: e.toString(), methodName: 'checkBladeguardEmail');
    return IntOrError().setException(e.response!.statusCode.toString());
  } catch (e) {
    BnLog.warning(text: e.toString(), methodName: 'checkBladeguardEmail');
  }
  return IntOrError().setException('unknown');
}

Future<IntOrError> checkBladeguardOnSite(bool onSite, String hash) async {
  var dio = Dio();
  var options = Options(
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10));
  options.contentType = 'application/json';
  Map<String, String> qParams = {'onsite': onSite.toString(), 'hash': hash};

  try {
    var apiLink = '$bladenightRestApiServerLink/checkBladeguardOnSite';
    if (kDebugMode) {
      apiLink = 'http://192.168.10.31:8888/checkBladeguardOnSite.php';
    }
    var response =
        await dio.get(apiLink, options: options, queryParameters: qParams);
    if (response.statusCode == 200) {
      return IntOrError().setInteger(response.data);
    } else {
      BnLog.warning(
          text: response.statusCode.toString(),
          methodName: 'checkBladeguardOnSite');
    }
  } on DioException catch (e) {
    BnLog.warning(text: e.toString(), methodName: 'checkBladeguardOnSite');
    return IntOrError().setException(e.response!.statusCode.toString());
  } catch (e) {
    BnLog.warning(text: e.toString(), methodName: 'checkBladeguardOnSite');
  }
  return IntOrError().setException('unknown');
}
