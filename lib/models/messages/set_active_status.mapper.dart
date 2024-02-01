// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'set_active_status.dart';

class SetActiveStatusMessageMapper
    extends ClassMapperBase<SetActiveStatusMessage> {
  SetActiveStatusMessageMapper._();

  static SetActiveStatusMessageMapper? _instance;
  static SetActiveStatusMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SetActiveStatusMessageMapper._());
      AdminMessageMapper.ensureInitialized();
      EventStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SetActiveStatusMessage';

  static EventStatus _$status(SetActiveStatusMessage v) => v.status;
  static const Field<SetActiveStatusMessage, EventStatus> _f$status =
      Field('status', _$status, key: 'sta');
  static int _$timestamp(SetActiveStatusMessage v) => v.timestamp;
  static const Field<SetActiveStatusMessage, int> _f$timestamp =
      Field('timestamp', _$timestamp, key: 'tim');
  static String _$checksum(SetActiveStatusMessage v) => v.checksum;
  static const Field<SetActiveStatusMessage, String> _f$checksum =
      Field('checksum', _$checksum, key: 'chk');
  static int _$noise(SetActiveStatusMessage v) => v.noise;
  static const Field<SetActiveStatusMessage, int> _f$noise =
      Field('noise', _$noise, key: 'noi');
  static String _$deviceId(SetActiveStatusMessage v) => v.deviceId;
  static const Field<SetActiveStatusMessage, String> _f$deviceId =
      Field('deviceId', _$deviceId, key: 'did');

  @override
  final MappableFields<SetActiveStatusMessage> fields = const {
    #status: _f$status,
    #timestamp: _f$timestamp,
    #checksum: _f$checksum,
    #noise: _f$noise,
    #deviceId: _f$deviceId,
  };

  static SetActiveStatusMessage _instantiate(DecodingData data) {
    return SetActiveStatusMessage(
        status: data.dec(_f$status),
        timestamp: data.dec(_f$timestamp),
        checksum: data.dec(_f$checksum),
        noise: data.dec(_f$noise),
        deviceId: data.dec(_f$deviceId));
  }

  @override
  final Function instantiate = _instantiate;

  static SetActiveStatusMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SetActiveStatusMessage>(map);
  }

  static SetActiveStatusMessage fromJson(String json) {
    return ensureInitialized().decodeJson<SetActiveStatusMessage>(json);
  }
}

mixin SetActiveStatusMessageMappable {
  String toJson() {
    return SetActiveStatusMessageMapper.ensureInitialized()
        .encodeJson<SetActiveStatusMessage>(this as SetActiveStatusMessage);
  }

  Map<String, dynamic> toMap() {
    return SetActiveStatusMessageMapper.ensureInitialized()
        .encodeMap<SetActiveStatusMessage>(this as SetActiveStatusMessage);
  }

  SetActiveStatusMessageCopyWith<SetActiveStatusMessage, SetActiveStatusMessage,
          SetActiveStatusMessage>
      get copyWith => _SetActiveStatusMessageCopyWithImpl(
          this as SetActiveStatusMessage, $identity, $identity);
  @override
  String toString() {
    return SetActiveStatusMessageMapper.ensureInitialized()
        .stringifyValue(this as SetActiveStatusMessage);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            SetActiveStatusMessageMapper.ensureInitialized()
                .isValueEqual(this as SetActiveStatusMessage, other));
  }

  @override
  int get hashCode {
    return SetActiveStatusMessageMapper.ensureInitialized()
        .hashValue(this as SetActiveStatusMessage);
  }
}

extension SetActiveStatusMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SetActiveStatusMessage, $Out> {
  SetActiveStatusMessageCopyWith<$R, SetActiveStatusMessage, $Out>
      get $asSetActiveStatusMessage =>
          $base.as((v, t, t2) => _SetActiveStatusMessageCopyWithImpl(v, t, t2));
}

abstract class SetActiveStatusMessageCopyWith<
    $R,
    $In extends SetActiveStatusMessage,
    $Out> implements AdminMessageCopyWith<$R, $In, $Out> {
  @override
  $R call(
      {EventStatus? status,
      int? timestamp,
      String? checksum,
      int? noise,
      String? deviceId});
  SetActiveStatusMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SetActiveStatusMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SetActiveStatusMessage, $Out>
    implements
        SetActiveStatusMessageCopyWith<$R, SetActiveStatusMessage, $Out> {
  _SetActiveStatusMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SetActiveStatusMessage> $mapper =
      SetActiveStatusMessageMapper.ensureInitialized();
  @override
  $R call(
          {EventStatus? status,
          int? timestamp,
          String? checksum,
          int? noise,
          String? deviceId}) =>
      $apply(FieldCopyWithData({
        if (status != null) #status: status,
        if (timestamp != null) #timestamp: timestamp,
        if (checksum != null) #checksum: checksum,
        if (noise != null) #noise: noise,
        if (deviceId != null) #deviceId: deviceId
      }));
  @override
  SetActiveStatusMessage $make(CopyWithData data) => SetActiveStatusMessage(
      status: data.get(#status, or: $value.status),
      timestamp: data.get(#timestamp, or: $value.timestamp),
      checksum: data.get(#checksum, or: $value.checksum),
      noise: data.get(#noise, or: $value.noise),
      deviceId: data.get(#deviceId, or: $value.deviceId));

  @override
  SetActiveStatusMessageCopyWith<$R2, SetActiveStatusMessage, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _SetActiveStatusMessageCopyWithImpl($value, $cast, t);
}
