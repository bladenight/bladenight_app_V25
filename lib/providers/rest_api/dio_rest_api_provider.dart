import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_rest_api_provider.g.dart';

@riverpod
Dio dio(DioRef ref) {
  var options = BaseOptions(
      receiveTimeout: const Duration(seconds: 5),
      contentType: 'application/json',
      headers: {'Access-Control-Allow-Origin': '*'},
      sendTimeout: const Duration(seconds: 5));
  return Dio(options);
}
