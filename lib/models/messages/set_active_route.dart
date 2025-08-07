import 'package:dart_mappable/dart_mappable.dart';

import 'admin.dart';

part 'set_active_route.mapper.dart';

@MappableClass()
class SetActiveRouteMessage extends AdminMessage with SetActiveRouteMessageMappable{
  @MappableField(key: 'rou')
  final String route;

  SetActiveRouteMessage({
    required this.route,
    required super.timestamp,
    required super.checksum,
    required super.noise,
    required super.deviceId
  });

  SetActiveRouteMessage.authenticate(
      {required this.route, required super.password, required deviceId})
      : super.authenticate(deviceId: deviceId);
}
