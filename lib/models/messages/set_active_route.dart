import 'package:dart_mappable/dart_mappable.dart';

import 'admin.dart';

part 'set_active_route.mapper.dart';

@MappableClass()
class SetActiveRouteMessage extends AdminMessage with SetActiveRouteMessageMappable{
  @MappableField(key: 'rou')
  final String route;

  SetActiveRouteMessage({
    required this.route,
    required int timestamp,
    required String checksum,
    required int noise,
    required deviceId
  }) : super(timestamp: timestamp, checksum: checksum, noise: noise,deviceId: deviceId);

  SetActiveRouteMessage.authenticate(
      {required this.route, required String password, required deviceId})
      : super.authenticate(password: password,deviceId: deviceId);
}
