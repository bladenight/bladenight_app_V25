// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element

part of 'moving_point.dart';

class MovingPointMapper extends ClassMapperBase<MovingPoint> {
  MovingPointMapper._();

  static MovingPointMapper? _instance;
  static MovingPointMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MovingPointMapper._());
    }
    return _instance!;
  }

  static T _guard<T>(T Function(MapperContainer) fn) {
    ensureInitialized();
    return fn(MapperContainer.globals);
  }

  @override
  final String id = 'MovingPoint';

  static int _$position(MovingPoint v) => v.position;
  static const Field<MovingPoint, int> _f$position =
      Field('position', _$position, key: 'pos');
  static int _$speed(MovingPoint v) => v.speed;
  static const Field<MovingPoint, int> _f$speed =
      Field('speed', _$speed, key: 'spd');
  static double? _$realSpeed(MovingPoint v) => v.realSpeed;
  static const Field<MovingPoint, double> _f$realSpeed =
      Field('realSpeed', _$realSpeed, key: 'rsp', opt: true);
  static int? _$eta(MovingPoint v) => v.eta;
  static const Field<MovingPoint, int> _f$eta = Field('eta', _$eta, opt: true);
  static bool _$isOnRoute(MovingPoint v) => v.isOnRoute;
  static const Field<MovingPoint, bool> _f$isOnRoute =
      Field('isOnRoute', _$isOnRoute, key: 'ior', opt: true, def: true);
  static bool _$isInProcession(MovingPoint v) => v.isInProcession;
  static const Field<MovingPoint, bool> _f$isInProcession = Field(
      'isInProcession', _$isInProcession,
      key: 'iip', opt: true, def: true);
  static double? _$latitude(MovingPoint v) => v.latitude;
  static const Field<MovingPoint, double> _f$latitude =
      Field('latitude', _$latitude, key: 'lat', opt: true);
  static double? _$longitude(MovingPoint v) => v.longitude;
  static const Field<MovingPoint, double> _f$longitude =
      Field('longitude', _$longitude, key: 'lon', opt: true);
  static int? _$accuracy(MovingPoint v) => v.accuracy;
  static const Field<MovingPoint, int> _f$accuracy =
      Field('accuracy', _$accuracy, key: 'acc', opt: true);

  @override
  final Map<Symbol, Field<MovingPoint, dynamic>> fields = const {
    #position: _f$position,
    #speed: _f$speed,
    #realSpeed: _f$realSpeed,
    #eta: _f$eta,
    #isOnRoute: _f$isOnRoute,
    #isInProcession: _f$isInProcession,
    #latitude: _f$latitude,
    #longitude: _f$longitude,
    #accuracy: _f$accuracy,
  };

  static MovingPoint _instantiate(DecodingData data) {
    return MovingPoint(
        position: data.dec(_f$position),
        speed: data.dec(_f$speed),
        realSpeed: data.dec(_f$realSpeed),
        eta: data.dec(_f$eta),
        isOnRoute: data.dec(_f$isOnRoute),
        isInProcession: data.dec(_f$isInProcession),
        latitude: data.dec(_f$latitude),
        longitude: data.dec(_f$longitude),
        accuracy: data.dec(_f$accuracy));
  }

  @override
  final Function instantiate = _instantiate;

  static MovingPoint fromMap(Map<String, dynamic> map) {
    return _guard((c) => c.fromMap<MovingPoint>(map));
  }

  static MovingPoint fromJson(String json) {
    return _guard((c) => c.fromJson<MovingPoint>(json));
  }
}

mixin MovingPointMappable {
  String toJson() {
    return MovingPointMapper._guard((c) => c.toJson(this as MovingPoint));
  }

  Map<String, dynamic> toMap() {
    return MovingPointMapper._guard((c) => c.toMap(this as MovingPoint));
  }

  MovingPointCopyWith<MovingPoint, MovingPoint, MovingPoint> get copyWith =>
      _MovingPointCopyWithImpl(this as MovingPoint, $identity, $identity);
  @override
  String toString() {
    return MovingPointMapper._guard((c) => c.asString(this));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            MovingPointMapper._guard((c) => c.isEqual(this, other)));
  }

  @override
  int get hashCode {
    return MovingPointMapper._guard((c) => c.hash(this));
  }
}

extension MovingPointValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MovingPoint, $Out> {
  MovingPointCopyWith<$R, MovingPoint, $Out> get $asMovingPoint =>
      $base.as((v, t, t2) => _MovingPointCopyWithImpl(v, t, t2));
}

abstract class MovingPointCopyWith<$R, $In extends MovingPoint, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? position,
      int? speed,
      double? realSpeed,
      int? eta,
      bool? isOnRoute,
      bool? isInProcession,
      double? latitude,
      double? longitude,
      int? accuracy});
  MovingPointCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MovingPointCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MovingPoint, $Out>
    implements MovingPointCopyWith<$R, MovingPoint, $Out> {
  _MovingPointCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MovingPoint> $mapper =
      MovingPointMapper.ensureInitialized();
  @override
  $R call(
          {int? position,
          int? speed,
          Object? realSpeed = $none,
          Object? eta = $none,
          bool? isOnRoute,
          bool? isInProcession,
          Object? latitude = $none,
          Object? longitude = $none,
          Object? accuracy = $none}) =>
      $apply(FieldCopyWithData({
        if (position != null) #position: position,
        if (speed != null) #speed: speed,
        if (realSpeed != $none) #realSpeed: realSpeed,
        if (eta != $none) #eta: eta,
        if (isOnRoute != null) #isOnRoute: isOnRoute,
        if (isInProcession != null) #isInProcession: isInProcession,
        if (latitude != $none) #latitude: latitude,
        if (longitude != $none) #longitude: longitude,
        if (accuracy != $none) #accuracy: accuracy
      }));
  @override
  MovingPoint $make(CopyWithData data) => MovingPoint(
      position: data.get(#position, or: $value.position),
      speed: data.get(#speed, or: $value.speed),
      realSpeed: data.get(#realSpeed, or: $value.realSpeed),
      eta: data.get(#eta, or: $value.eta),
      isOnRoute: data.get(#isOnRoute, or: $value.isOnRoute),
      isInProcession: data.get(#isInProcession, or: $value.isInProcession),
      latitude: data.get(#latitude, or: $value.latitude),
      longitude: data.get(#longitude, or: $value.longitude),
      accuracy: data.get(#accuracy, or: $value.accuracy));

  @override
  MovingPointCopyWith<$R2, MovingPoint, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MovingPointCopyWithImpl($value, $cast, t);
}
