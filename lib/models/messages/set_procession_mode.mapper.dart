// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'set_procession_mode.dart';

class AdminProcessionModeMapper extends EnumMapper<AdminProcessionMode> {
  AdminProcessionModeMapper._();

  static AdminProcessionModeMapper? _instance;
  static AdminProcessionModeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdminProcessionModeMapper._());
    }
    return _instance!;
  }

  static AdminProcessionMode fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  AdminProcessionMode decode(dynamic value) {
    switch (value) {
      case 'NON':
        return AdminProcessionMode.none;
      case 'HAT':
        return AdminProcessionMode.headAndTail;
      case 'OFF':
        return AdminProcessionMode.noHeadAndTail;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(AdminProcessionMode self) {
    switch (self) {
      case AdminProcessionMode.none:
        return 'NON';
      case AdminProcessionMode.headAndTail:
        return 'HAT';
      case AdminProcessionMode.noHeadAndTail:
        return 'OFF';
    }
  }
}

extension AdminProcessionModeMapperExtension on AdminProcessionMode {
  dynamic toValue() {
    AdminProcessionModeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<AdminProcessionMode>(this);
  }
}

class SetProcessionModeMessageMapper
    extends ClassMapperBase<SetProcessionModeMessage> {
  SetProcessionModeMessageMapper._();

  static SetProcessionModeMessageMapper? _instance;
  static SetProcessionModeMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = SetProcessionModeMessageMapper._());
      AdminMessageMapper.ensureInitialized();
      AdminProcessionModeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SetProcessionModeMessage';

  static AdminProcessionMode _$mode(SetProcessionModeMessage v) => v.mode;
  static const Field<SetProcessionModeMessage, AdminProcessionMode> _f$mode =
      Field('mode', _$mode, key: 'pmo');
  static int _$timestamp(SetProcessionModeMessage v) => v.timestamp;
  static const Field<SetProcessionModeMessage, int> _f$timestamp =
      Field('timestamp', _$timestamp, key: 'tim');
  static String _$checksum(SetProcessionModeMessage v) => v.checksum;
  static const Field<SetProcessionModeMessage, String> _f$checksum =
      Field('checksum', _$checksum, key: 'chk');
  static int _$noise(SetProcessionModeMessage v) => v.noise;
  static const Field<SetProcessionModeMessage, int> _f$noise =
      Field('noise', _$noise, key: 'noi');
  static String _$deviceId(SetProcessionModeMessage v) => v.deviceId;
  static const Field<SetProcessionModeMessage, String> _f$deviceId =
      Field('deviceId', _$deviceId, key: 'did');

  @override
  final MappableFields<SetProcessionModeMessage> fields = const {
    #mode: _f$mode,
    #timestamp: _f$timestamp,
    #checksum: _f$checksum,
    #noise: _f$noise,
    #deviceId: _f$deviceId,
  };

  static SetProcessionModeMessage _instantiate(DecodingData data) {
    return SetProcessionModeMessage(
        mode: data.dec(_f$mode),
        timestamp: data.dec(_f$timestamp),
        checksum: data.dec(_f$checksum),
        noise: data.dec(_f$noise),
        deviceId: data.dec(_f$deviceId));
  }

  @override
  final Function instantiate = _instantiate;

  static SetProcessionModeMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SetProcessionModeMessage>(map);
  }

  static SetProcessionModeMessage fromJson(String json) {
    return ensureInitialized().decodeJson<SetProcessionModeMessage>(json);
  }
}

mixin SetProcessionModeMessageMappable {
  String toJson() {
    return SetProcessionModeMessageMapper.ensureInitialized()
        .encodeJson<SetProcessionModeMessage>(this as SetProcessionModeMessage);
  }

  Map<String, dynamic> toMap() {
    return SetProcessionModeMessageMapper.ensureInitialized()
        .encodeMap<SetProcessionModeMessage>(this as SetProcessionModeMessage);
  }

  SetProcessionModeMessageCopyWith<SetProcessionModeMessage,
          SetProcessionModeMessage, SetProcessionModeMessage>
      get copyWith => _SetProcessionModeMessageCopyWithImpl(
          this as SetProcessionModeMessage, $identity, $identity);
  @override
  String toString() {
    return SetProcessionModeMessageMapper.ensureInitialized()
        .stringifyValue(this as SetProcessionModeMessage);
  }

  @override
  bool operator ==(Object other) {
    return SetProcessionModeMessageMapper.ensureInitialized()
        .equalsValue(this as SetProcessionModeMessage, other);
  }

  @override
  int get hashCode {
    return SetProcessionModeMessageMapper.ensureInitialized()
        .hashValue(this as SetProcessionModeMessage);
  }
}

extension SetProcessionModeMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SetProcessionModeMessage, $Out> {
  SetProcessionModeMessageCopyWith<$R, SetProcessionModeMessage, $Out>
      get $asSetProcessionModeMessage => $base
          .as((v, t, t2) => _SetProcessionModeMessageCopyWithImpl(v, t, t2));
}

abstract class SetProcessionModeMessageCopyWith<
    $R,
    $In extends SetProcessionModeMessage,
    $Out> implements AdminMessageCopyWith<$R, $In, $Out> {
  @override
  $R call(
      {AdminProcessionMode? mode,
      int? timestamp,
      String? checksum,
      int? noise,
      String? deviceId});
  SetProcessionModeMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SetProcessionModeMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SetProcessionModeMessage, $Out>
    implements
        SetProcessionModeMessageCopyWith<$R, SetProcessionModeMessage, $Out> {
  _SetProcessionModeMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SetProcessionModeMessage> $mapper =
      SetProcessionModeMessageMapper.ensureInitialized();
  @override
  $R call(
          {AdminProcessionMode? mode,
          int? timestamp,
          String? checksum,
          int? noise,
          String? deviceId}) =>
      $apply(FieldCopyWithData({
        if (mode != null) #mode: mode,
        if (timestamp != null) #timestamp: timestamp,
        if (checksum != null) #checksum: checksum,
        if (noise != null) #noise: noise,
        if (deviceId != null) #deviceId: deviceId
      }));
  @override
  SetProcessionModeMessage $make(CopyWithData data) => SetProcessionModeMessage(
      mode: data.get(#mode, or: $value.mode),
      timestamp: data.get(#timestamp, or: $value.timestamp),
      checksum: data.get(#checksum, or: $value.checksum),
      noise: data.get(#noise, or: $value.noise),
      deviceId: data.get(#deviceId, or: $value.deviceId));

  @override
  SetProcessionModeMessageCopyWith<$R2, SetProcessionModeMessage, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _SetProcessionModeMessageCopyWithImpl($value, $cast, t);
}
