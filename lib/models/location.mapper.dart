// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element

part of 'location.dart';

class LocationInfoMapper extends ClassMapperBase<LocationInfo> {
  LocationInfoMapper._();

  static LocationInfoMapper? _instance;
  static LocationInfoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LocationInfoMapper._());
      MapperContainer.globals.useAll([LatLngMapper()]);
    }
    return _instance!;
  }

  static T _guard<T>(T Function(MapperContainer) fn) {
    ensureInitialized();
    return fn(MapperContainer.globals);
  }

  @override
  final String id = 'LocationInfo';

  static LatLng _$coords(LocationInfo v) => v.coords;
  static const Field<LocationInfo, LatLng> _f$coords =
      Field('coords', _$coords, key: 'coo');
  static bool _$isParticipating(LocationInfo v) => v.isParticipating;
  static const Field<LocationInfo, bool> _f$isParticipating =
      Field('isParticipating', _$isParticipating, key: 'par');
  static String _$deviceId(LocationInfo v) => v.deviceId;
  static const Field<LocationInfo, String> _f$deviceId =
      Field('deviceId', _$deviceId, key: 'did');
  static int? _$specialFunction(LocationInfo v) => v.specialFunction;
  static const Field<LocationInfo, int> _f$specialFunction =
      Field('specialFunction', _$specialFunction, key: 'spf', opt: true);
  static double? _$userSpeed(LocationInfo v) => v.userSpeed;
  static const Field<LocationInfo, double> _f$userSpeed =
      Field('userSpeed', _$userSpeed, key: 'spd', opt: true);
  static double? _$realSpeed(LocationInfo v) => v.realSpeed;
  static const Field<LocationInfo, double> _f$realSpeed =
      Field('realSpeed', _$realSpeed, key: 'rsp', opt: true);

  @override
  final Map<Symbol, Field<LocationInfo, dynamic>> fields = const {
    #coords: _f$coords,
    #isParticipating: _f$isParticipating,
    #deviceId: _f$deviceId,
    #specialFunction: _f$specialFunction,
    #userSpeed: _f$userSpeed,
    #realSpeed: _f$realSpeed,
  };

  static LocationInfo _instantiate(DecodingData data) {
    return LocationInfo(
        coords: data.dec(_f$coords),
        isParticipating: data.dec(_f$isParticipating),
        deviceId: data.dec(_f$deviceId),
        specialFunction: data.dec(_f$specialFunction),
        userSpeed: data.dec(_f$userSpeed),
        realSpeed: data.dec(_f$realSpeed));
  }

  @override
  final Function instantiate = _instantiate;

  static LocationInfo fromMap(Map<String, dynamic> map) {
    return _guard((c) => c.fromMap<LocationInfo>(map));
  }

  static LocationInfo fromJson(String json) {
    return _guard((c) => c.fromJson<LocationInfo>(json));
  }
}

mixin LocationInfoMappable {
  String toJson() {
    return LocationInfoMapper._guard((c) => c.toJson(this as LocationInfo));
  }

  Map<String, dynamic> toMap() {
    return LocationInfoMapper._guard((c) => c.toMap(this as LocationInfo));
  }

  LocationInfoCopyWith<LocationInfo, LocationInfo, LocationInfo> get copyWith =>
      _LocationInfoCopyWithImpl(this as LocationInfo, $identity, $identity);
  @override
  String toString() {
    return LocationInfoMapper._guard((c) => c.asString(this));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            LocationInfoMapper._guard((c) => c.isEqual(this, other)));
  }

  @override
  int get hashCode {
    return LocationInfoMapper._guard((c) => c.hash(this));
  }
}

extension LocationInfoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LocationInfo, $Out> {
  LocationInfoCopyWith<$R, LocationInfo, $Out> get $asLocationInfo =>
      $base.as((v, t, t2) => _LocationInfoCopyWithImpl(v, t, t2));
}

abstract class LocationInfoCopyWith<$R, $In extends LocationInfo, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {LatLng? coords,
      bool? isParticipating,
      String? deviceId,
      int? specialFunction,
      double? userSpeed,
      double? realSpeed});
  LocationInfoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LocationInfoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LocationInfo, $Out>
    implements LocationInfoCopyWith<$R, LocationInfo, $Out> {
  _LocationInfoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LocationInfo> $mapper =
      LocationInfoMapper.ensureInitialized();
  @override
  $R call(
          {LatLng? coords,
          bool? isParticipating,
          String? deviceId,
          Object? specialFunction = $none,
          Object? userSpeed = $none,
          Object? realSpeed = $none}) =>
      $apply(FieldCopyWithData({
        if (coords != null) #coords: coords,
        if (isParticipating != null) #isParticipating: isParticipating,
        if (deviceId != null) #deviceId: deviceId,
        if (specialFunction != $none) #specialFunction: specialFunction,
        if (userSpeed != $none) #userSpeed: userSpeed,
        if (realSpeed != $none) #realSpeed: realSpeed
      }));
  @override
  LocationInfo $make(CopyWithData data) => LocationInfo(
      coords: data.get(#coords, or: $value.coords),
      isParticipating: data.get(#isParticipating, or: $value.isParticipating),
      deviceId: data.get(#deviceId, or: $value.deviceId),
      specialFunction: data.get(#specialFunction, or: $value.specialFunction),
      userSpeed: data.get(#userSpeed, or: $value.userSpeed),
      realSpeed: data.get(#realSpeed, or: $value.realSpeed));

  @override
  LocationInfoCopyWith<$R2, LocationInfo, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _LocationInfoCopyWithImpl($value, $cast, t);
}
