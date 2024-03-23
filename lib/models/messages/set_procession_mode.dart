import 'package:dart_mappable/dart_mappable.dart';

import 'admin.dart';

part 'set_procession_mode.mapper.dart';

@MappableEnum()
enum AdminProcessionMode {
  @MappableValue('HAT')
  headAndTail,
  @MappableValue('OFF')
  noHeadAndTail,

}


@MappableClass()
class SetProcessionModeMessage extends AdminMessage with SetProcessionModeMessageMappable
{
  @MappableField(key: 'pmo')
  final AdminProcessionMode mode;

  SetProcessionModeMessage({
    required this.mode,
    required super.timestamp,
    required super.checksum,
    required super.noise,
    required super.deviceId,
  });

  SetProcessionModeMessage.authenticate(
      {required this.mode, required super.password,required super.deviceId})
      : super.authenticate();
}
