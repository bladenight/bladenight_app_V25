import 'package:dart_mappable/dart_mappable.dart';

import 'admin.dart';

part 'kill_server.mapper.dart';

@MappableClass()
class KillServerMessage extends AdminMessage with KillServerMessageMappable{


  KillServerMessage({
    required int timestamp,
    required String checksum,
    required int noise,
    required String deviceId,
  }) : super(timestamp: timestamp, checksum: checksum, noise: noise,deviceId: deviceId);

  KillServerMessage.authenticate(
      { required String password, required deviceId,})
      : super.authenticate(password: password,deviceId: deviceId);
}
