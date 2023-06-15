// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element

part of 'set_active_route.dart';

class SetActiveRouteMessageMapper
    extends ClassMapperBase<SetActiveRouteMessage> {
  SetActiveRouteMessageMapper._();

  static SetActiveRouteMessageMapper? _instance;
  static SetActiveRouteMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SetActiveRouteMessageMapper._());
      AdminMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  static T _guard<T>(T Function(MapperContainer) fn) {
    ensureInitialized();
    return fn(MapperContainer.globals);
  }

  @override
  final String id = 'SetActiveRouteMessage';

  static String _$route(SetActiveRouteMessage v) => v.route;
  static const Field<SetActiveRouteMessage, String> _f$route =
      Field('route', _$route, key: 'rou');
  static int _$timestamp(SetActiveRouteMessage v) => v.timestamp;
  static const Field<SetActiveRouteMessage, int> _f$timestamp =
      Field('timestamp', _$timestamp, key: 'tim');
  static String _$checksum(SetActiveRouteMessage v) => v.checksum;
  static const Field<SetActiveRouteMessage, String> _f$checksum =
      Field('checksum', _$checksum, key: 'chk');
  static int _$noise(SetActiveRouteMessage v) => v.noise;
  static const Field<SetActiveRouteMessage, int> _f$noise =
      Field('noise', _$noise, key: 'noi');
  static String _$deviceId(SetActiveRouteMessage v) => v.deviceId;
  static const Field<SetActiveRouteMessage, dynamic> _f$deviceId =
      Field('deviceId', _$deviceId, key: 'did');

  @override
  final Map<Symbol, Field<SetActiveRouteMessage, dynamic>> fields = const {
    #route: _f$route,
    #timestamp: _f$timestamp,
    #checksum: _f$checksum,
    #noise: _f$noise,
    #deviceId: _f$deviceId,
  };

  static SetActiveRouteMessage _instantiate(DecodingData data) {
    return SetActiveRouteMessage(
        route: data.dec(_f$route),
        timestamp: data.dec(_f$timestamp),
        checksum: data.dec(_f$checksum),
        noise: data.dec(_f$noise),
        deviceId: data.dec(_f$deviceId));
  }

  @override
  final Function instantiate = _instantiate;

  static SetActiveRouteMessage fromMap(Map<String, dynamic> map) {
    return _guard((c) => c.fromMap<SetActiveRouteMessage>(map));
  }

  static SetActiveRouteMessage fromJson(String json) {
    return _guard((c) => c.fromJson<SetActiveRouteMessage>(json));
  }
}

mixin SetActiveRouteMessageMappable {
  String toJson() {
    return SetActiveRouteMessageMapper._guard(
        (c) => c.toJson(this as SetActiveRouteMessage));
  }

  Map<String, dynamic> toMap() {
    return SetActiveRouteMessageMapper._guard(
        (c) => c.toMap(this as SetActiveRouteMessage));
  }

  SetActiveRouteMessageCopyWith<SetActiveRouteMessage, SetActiveRouteMessage,
          SetActiveRouteMessage>
      get copyWith => _SetActiveRouteMessageCopyWithImpl(
          this as SetActiveRouteMessage, $identity, $identity);
  @override
  String toString() {
    return SetActiveRouteMessageMapper._guard((c) => c.asString(this));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            SetActiveRouteMessageMapper._guard((c) => c.isEqual(this, other)));
  }

  @override
  int get hashCode {
    return SetActiveRouteMessageMapper._guard((c) => c.hash(this));
  }
}

extension SetActiveRouteMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SetActiveRouteMessage, $Out> {
  SetActiveRouteMessageCopyWith<$R, SetActiveRouteMessage, $Out>
      get $asSetActiveRouteMessage =>
          $base.as((v, t, t2) => _SetActiveRouteMessageCopyWithImpl(v, t, t2));
}

abstract class SetActiveRouteMessageCopyWith<
    $R,
    $In extends SetActiveRouteMessage,
    $Out> implements AdminMessageCopyWith<$R, $In, $Out> {
  @override
  $R call(
      {String? route,
      int? timestamp,
      String? checksum,
      int? noise,
      dynamic deviceId});
  SetActiveRouteMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SetActiveRouteMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SetActiveRouteMessage, $Out>
    implements SetActiveRouteMessageCopyWith<$R, SetActiveRouteMessage, $Out> {
  _SetActiveRouteMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SetActiveRouteMessage> $mapper =
      SetActiveRouteMessageMapper.ensureInitialized();
  @override
  $R call(
          {String? route,
          int? timestamp,
          String? checksum,
          int? noise,
          Object? deviceId = $none}) =>
      $apply(FieldCopyWithData({
        if (route != null) #route: route,
        if (timestamp != null) #timestamp: timestamp,
        if (checksum != null) #checksum: checksum,
        if (noise != null) #noise: noise,
        if (deviceId != $none) #deviceId: deviceId
      }));
  @override
  SetActiveRouteMessage $make(CopyWithData data) => SetActiveRouteMessage(
      route: data.get(#route, or: $value.route),
      timestamp: data.get(#timestamp, or: $value.timestamp),
      checksum: data.get(#checksum, or: $value.checksum),
      noise: data.get(#noise, or: $value.noise),
      deviceId: data.get(#deviceId, or: $value.deviceId));

  @override
  SetActiveRouteMessageCopyWith<$R2, SetActiveRouteMessage, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _SetActiveRouteMessageCopyWithImpl($value, $cast, t);
}
