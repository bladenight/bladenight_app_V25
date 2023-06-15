// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element

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

  static T _guard<T>(T Function(MapperContainer) fn) {
    ensureInitialized();
    return fn(MapperContainer.globals);
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
  final Map<Symbol, Field<AdminMessage, dynamic>> fields = const {
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
    return _guard((c) => c.fromMap<AdminMessage>(map));
  }

  static AdminMessage fromJson(String json) {
    return _guard((c) => c.fromJson<AdminMessage>(json));
  }
}

mixin AdminMessageMappable {
  String toJson() {
    return AdminMessageMapper._guard((c) => c.toJson(this as AdminMessage));
  }

  Map<String, dynamic> toMap() {
    return AdminMessageMapper._guard((c) => c.toMap(this as AdminMessage));
  }

  AdminMessageCopyWith<AdminMessage, AdminMessage, AdminMessage> get copyWith =>
      _AdminMessageCopyWithImpl(this as AdminMessage, $identity, $identity);
  @override
  String toString() {
    return AdminMessageMapper._guard((c) => c.asString(this));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            AdminMessageMapper._guard((c) => c.isEqual(this, other)));
  }

  @override
  int get hashCode {
    return AdminMessageMapper._guard((c) => c.hash(this));
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
