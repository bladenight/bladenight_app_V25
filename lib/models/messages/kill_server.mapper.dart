// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'kill_server.dart';

class KillServerMessageMapper extends ClassMapperBase<KillServerMessage> {
  KillServerMessageMapper._();

  static KillServerMessageMapper? _instance;
  static KillServerMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = KillServerMessageMapper._());
      AdminMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'KillServerMessage';

  static bool _$killValue(KillServerMessage v) => v.killValue;
  static const Field<KillServerMessage, bool> _f$killValue =
      Field('killValue', _$killValue, key: r'cmd');
  static int _$timestamp(KillServerMessage v) => v.timestamp;
  static const Field<KillServerMessage, int> _f$timestamp =
      Field('timestamp', _$timestamp, key: r'tim');
  static String _$checksum(KillServerMessage v) => v.checksum;
  static const Field<KillServerMessage, String> _f$checksum =
      Field('checksum', _$checksum, key: r'chk');
  static int _$noise(KillServerMessage v) => v.noise;
  static const Field<KillServerMessage, int> _f$noise =
      Field('noise', _$noise, key: r'noi');
  static String _$deviceId(KillServerMessage v) => v.deviceId;
  static const Field<KillServerMessage, String> _f$deviceId =
      Field('deviceId', _$deviceId, key: r'did');

  @override
  final MappableFields<KillServerMessage> fields = const {
    #killValue: _f$killValue,
    #timestamp: _f$timestamp,
    #checksum: _f$checksum,
    #noise: _f$noise,
    #deviceId: _f$deviceId,
  };

  static KillServerMessage _instantiate(DecodingData data) {
    return KillServerMessage(
        killValue: data.dec(_f$killValue),
        timestamp: data.dec(_f$timestamp),
        checksum: data.dec(_f$checksum),
        noise: data.dec(_f$noise),
        deviceId: data.dec(_f$deviceId));
  }

  @override
  final Function instantiate = _instantiate;

  static KillServerMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<KillServerMessage>(map);
  }

  static KillServerMessage fromJson(String json) {
    return ensureInitialized().decodeJson<KillServerMessage>(json);
  }
}

mixin KillServerMessageMappable {
  String toJson() {
    return KillServerMessageMapper.ensureInitialized()
        .encodeJson<KillServerMessage>(this as KillServerMessage);
  }

  Map<String, dynamic> toMap() {
    return KillServerMessageMapper.ensureInitialized()
        .encodeMap<KillServerMessage>(this as KillServerMessage);
  }

  KillServerMessageCopyWith<KillServerMessage, KillServerMessage,
          KillServerMessage>
      get copyWith => _KillServerMessageCopyWithImpl(
          this as KillServerMessage, $identity, $identity);
  @override
  String toString() {
    return KillServerMessageMapper.ensureInitialized()
        .stringifyValue(this as KillServerMessage);
  }

  @override
  bool operator ==(Object other) {
    return KillServerMessageMapper.ensureInitialized()
        .equalsValue(this as KillServerMessage, other);
  }

  @override
  int get hashCode {
    return KillServerMessageMapper.ensureInitialized()
        .hashValue(this as KillServerMessage);
  }
}

extension KillServerMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, KillServerMessage, $Out> {
  KillServerMessageCopyWith<$R, KillServerMessage, $Out>
      get $asKillServerMessage =>
          $base.as((v, t, t2) => _KillServerMessageCopyWithImpl(v, t, t2));
}

abstract class KillServerMessageCopyWith<$R, $In extends KillServerMessage,
    $Out> implements AdminMessageCopyWith<$R, $In, $Out> {
  @override
  $R call(
      {bool? killValue,
      int? timestamp,
      String? checksum,
      int? noise,
      String? deviceId});
  KillServerMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _KillServerMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, KillServerMessage, $Out>
    implements KillServerMessageCopyWith<$R, KillServerMessage, $Out> {
  _KillServerMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<KillServerMessage> $mapper =
      KillServerMessageMapper.ensureInitialized();
  @override
  $R call(
          {bool? killValue,
          int? timestamp,
          String? checksum,
          int? noise,
          String? deviceId}) =>
      $apply(FieldCopyWithData({
        if (killValue != null) #killValue: killValue,
        if (timestamp != null) #timestamp: timestamp,
        if (checksum != null) #checksum: checksum,
        if (noise != null) #noise: noise,
        if (deviceId != null) #deviceId: deviceId
      }));
  @override
  KillServerMessage $make(CopyWithData data) => KillServerMessage(
      killValue: data.get(#killValue, or: $value.killValue),
      timestamp: data.get(#timestamp, or: $value.timestamp),
      checksum: data.get(#checksum, or: $value.checksum),
      noise: data.get(#noise, or: $value.noise),
      deviceId: data.get(#deviceId, or: $value.deviceId));

  @override
  KillServerMessageCopyWith<$R2, KillServerMessage, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _KillServerMessageCopyWithImpl($value, $cast, t);
}
