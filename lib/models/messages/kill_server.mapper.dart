// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element

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

  static T _guard<T>(T Function(MapperContainer) fn) {
    ensureInitialized();
    return fn(MapperContainer.globals);
  }

  @override
  final String id = 'KillServerMessage';

  static int _$timestamp(KillServerMessage v) => v.timestamp;
  static const Field<KillServerMessage, int> _f$timestamp =
      Field('timestamp', _$timestamp, key: 'tim');
  static String _$checksum(KillServerMessage v) => v.checksum;
  static const Field<KillServerMessage, String> _f$checksum =
      Field('checksum', _$checksum, key: 'chk');
  static int _$noise(KillServerMessage v) => v.noise;
  static const Field<KillServerMessage, int> _f$noise =
      Field('noise', _$noise, key: 'noi');
  static String _$deviceId(KillServerMessage v) => v.deviceId;
  static const Field<KillServerMessage, String> _f$deviceId =
      Field('deviceId', _$deviceId, key: 'did');

  @override
  final Map<Symbol, Field<KillServerMessage, dynamic>> fields = const {
    #timestamp: _f$timestamp,
    #checksum: _f$checksum,
    #noise: _f$noise,
    #deviceId: _f$deviceId,
  };

  static KillServerMessage _instantiate(DecodingData data) {
    return KillServerMessage(
        timestamp: data.dec(_f$timestamp),
        checksum: data.dec(_f$checksum),
        noise: data.dec(_f$noise),
        deviceId: data.dec(_f$deviceId));
  }

  @override
  final Function instantiate = _instantiate;

  static KillServerMessage fromMap(Map<String, dynamic> map) {
    return _guard((c) => c.fromMap<KillServerMessage>(map));
  }

  static KillServerMessage fromJson(String json) {
    return _guard((c) => c.fromJson<KillServerMessage>(json));
  }
}

mixin KillServerMessageMappable {
  String toJson() {
    return KillServerMessageMapper._guard(
        (c) => c.toJson(this as KillServerMessage));
  }

  Map<String, dynamic> toMap() {
    return KillServerMessageMapper._guard(
        (c) => c.toMap(this as KillServerMessage));
  }

  KillServerMessageCopyWith<KillServerMessage, KillServerMessage,
          KillServerMessage>
      get copyWith => _KillServerMessageCopyWithImpl(
          this as KillServerMessage, $identity, $identity);
  @override
  String toString() {
    return KillServerMessageMapper._guard((c) => c.asString(this));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            KillServerMessageMapper._guard((c) => c.isEqual(this, other)));
  }

  @override
  int get hashCode {
    return KillServerMessageMapper._guard((c) => c.hash(this));
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
  $R call({int? timestamp, String? checksum, int? noise, String? deviceId});
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
  $R call({int? timestamp, String? checksum, int? noise, String? deviceId}) =>
      $apply(FieldCopyWithData({
        if (timestamp != null) #timestamp: timestamp,
        if (checksum != null) #checksum: checksum,
        if (noise != null) #noise: noise,
        if (deviceId != null) #deviceId: deviceId
      }));
  @override
  KillServerMessage $make(CopyWithData data) => KillServerMessage(
      timestamp: data.get(#timestamp, or: $value.timestamp),
      checksum: data.get(#checksum, or: $value.checksum),
      noise: data.get(#noise, or: $value.noise),
      deviceId: data.get(#deviceId, or: $value.deviceId));

  @override
  KillServerMessageCopyWith<$R2, KillServerMessage, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _KillServerMessageCopyWithImpl($value, $cast, t);
}
