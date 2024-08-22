import 'package:dart_mappable/dart_mappable.dart';

import 'admin.dart';

part 'kill_server.mapper.dart';

@MappableClass()
class KillServerMessage extends AdminMessage with KillServerMessageMappable {
  @MappableField(key: 'cmd')
  final bool killValue;

  KillServerMessage({
    required this.killValue,
    required super.timestamp,
    required super.checksum,
    required super.noise,
    required super.deviceId,
  });

  KillServerMessage.authenticate({
    required this.killValue,
    required String password,
    required deviceId,
  }) : super.authenticate(password: password, deviceId: deviceId);
}
