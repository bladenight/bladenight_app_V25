import 'package:dart_mappable/dart_mappable.dart';

import '../event.dart';
import 'admin.dart';

part 'edit_event_on_server.mapper.dart';

@MappableClass()
class EditEventOnServerMessage extends AdminMessage
    with EditEventOnServerMessageMappable {
  @MappableField(key: 'evt')
  final Event event;

  EditEventOnServerMessage(
      {required super.timestamp,
      required super.checksum,
      required super.noise,
      required super.deviceId,
      required this.event});

  EditEventOnServerMessage.authenticate(
      {required String password, required deviceId, required this.event})
      : super.authenticate(password: password, deviceId: deviceId);
}
