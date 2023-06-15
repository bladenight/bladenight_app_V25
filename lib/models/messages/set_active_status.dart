import 'package:dart_mappable/dart_mappable.dart';

import '../event.dart';
import 'admin.dart';

part 'set_active_status.mapper.dart';

@MappableClass()
class SetActiveStatusMessage extends AdminMessage  with SetActiveStatusMessageMappable{
  @MappableField(key: 'sta')
  final EventStatus status;

  SetActiveStatusMessage({
    required this.status,
    required int timestamp,
    required String checksum,
    required int noise,
    required String deviceId,
  }) : super(timestamp: timestamp, checksum: checksum, noise: noise, deviceId: deviceId);

  SetActiveStatusMessage.authenticate(
      {required this.status, required String password,required String deviceId})
      : super.authenticate(password: password,deviceId: deviceId);
}
