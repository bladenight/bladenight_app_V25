import 'package:dart_mappable/dart_mappable.dart';

import 'admin.dart';

part 'kill_server.mapper.dart';

@MappableClass()
class KillServerMessage extends AdminMessage with KillServerMessageMappable{


  KillServerMessage({
    required super.timestamp,
    required super.checksum,
    required super.noise,
    required super.deviceId,
  });

  KillServerMessage.authenticate(
      { required String password, required deviceId,})
      : super.authenticate(password: password,deviceId: deviceId);
}
