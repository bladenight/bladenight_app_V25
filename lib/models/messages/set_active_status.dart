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
    required super.timestamp,
    required super.checksum,
    required super.noise,
    required super.deviceId,
  });

  SetActiveStatusMessage.authenticate(
      {required this.status, required super.password,required super.deviceId})
      : super.authenticate();
}
