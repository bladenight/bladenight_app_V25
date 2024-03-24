import 'package:dio/dio.dart';

class OnSiteHandler {
  OnSiteHandler({required this.client, required this.mailHashCode});

  final Dio client;
  final String mailHashCode;

}
