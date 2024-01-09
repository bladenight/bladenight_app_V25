// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'admin.dart';

class AdminMessageMapper extends ClassMapperBase<AdminMessage> {
  AdminMessageMapper._();

  static AdminMessageMapper? _instance;
  static AdminMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdminMessageMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AdminMessage';

  static int _$timestamp(AdminMessage v) => v.timestamp;
  static const Field<AdminMessage, int> _f$timestamp =
      Field('timestamp', _$timestamp, key: 'tim');
  static String _$checksum(AdminMessage v) => v.checksum;
  static const Field<AdminMessage, String> _f$checksum =
      Field('checksum', _$checksum, key: 'chk');
  static int _$noise(AdminMessage v) => v.noise;
  static const Field<AdminMessage, int> _f$noise =
      Field('noise', _$noise, key: 'noi');
  static String _$deviceId(AdminMessage v) => v.deviceId;
  static const Field<AdminMessage, String> _f$deviceId =
      Field('deviceId', _$deviceId, key: 'did');

  @override
  final MappableFields<AdminMessage> fields = const {
    #timestamp: _f$timestamp,
    #checksum: _f$checksum,
    #noise: _f$noise,
    #deviceId: _f$deviceId,
  };

  static AdminMessage _instantiate(DecodingData data) {
    return AdminMessage(
        timestamp: data.dec(_f$timestamp),
        checksum: data.dec(_f$checksum),
        noise: data.dec(_f$noise),
        deviceId: data.dec(_f$deviceId));
  }

  @override
  final Function instantiate = _instantiate;

  static AdminMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdminMessage>(map);
  }

  static AdminMessage fromJson(String json) {
    return ensureInitialized().decodeJson<AdminMessage>(json);
  }
}

mixin AdminMessageMappable {
  String toJson() {
    return AdminMessageMapper.ensureInitialized()
        .encodeJson<AdminMessage>(this as AdminMessage);
  }

  Map<String, dynamic> toMap() {
    return AdminMessageMapper.ensureInitialized()
        .encodeMap<AdminMessage>(this as AdminMessage);
  }

  AdminMessageCopyWith<AdminMessage, AdminMessage, AdminMessage> get copyWith =>
      _AdminMessageCopyWithImpl(this as AdminMessage, $identity, $identity);
  @override
  String toString() {
    return AdminMessageMapper.ensureInitialized()
        .stringifyValue(this as AdminMessage);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            AdminMessageMapper.ensureInitialized()
                .isValueEqual(this as AdminMessage, other));
  }

  @override
  int get hashCode {
    return AdminMessageMapper.ensureInitialized()
        .hashValue(this as AdminMessage);
  }
}

extension AdminMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AdminMessage, $Out> {
  AdminMessageCopyWith<$R, AdminMessage, $Out> get $asAdminMessage =>
      $base.as((v, t, t2) => _AdminMessageCopyWithImpl(v, t, t2));
}

abstract class AdminMessageCopyWith<$R, $In extends AdminMessage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? timestamp, String? checksum, int? noise, String? deviceId});
  AdminMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AdminMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AdminMessage, $Out>
    implements AdminMessageCopyWith<$R, AdminMessage, $Out> {
  _AdminMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AdminMessage> $mapper =
      AdminMessageMapper.ensureInitialized();
  @override
  $R call({int? timestamp, String? checksum, int? noise, String? deviceId}) =>
      $apply(FieldCopyWithData({
        if (timestamp != null) #timestamp: timestamp,
        if (checksum != null) #checksum: checksum,
        if (noise != null) #noise: noise,
        if (deviceId != null) #deviceId: deviceId
      }));
  @override
  AdminMessage $make(CopyWithData data) => AdminMessage(
      timestamp: data.get(#timestamp, or: $value.timestamp),
      checksum: data.get(#checksum, or: $value.checksum),
      noise: data.get(#noise, or: $value.noise),
      deviceId: data.get(#deviceId, or: $value.deviceId));

  @override
  AdminMessageCopyWith<$R2, AdminMessage, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AdminMessageCopyWithImpl($value, $cast, t);
}
