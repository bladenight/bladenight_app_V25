// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_trackpoint.dart';

class UserTrackPointMapper extends ClassMapperBase<UserTrackPoint> {
  UserTrackPointMapper._();

  static UserTrackPointMapper? _instance;
  static UserTrackPointMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserTrackPointMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserTrackPoint';

  static double _$latitude(UserTrackPoint v) => v.latitude;
  static const Field<UserTrackPoint, double> _f$latitude =
      Field('latitude', _$latitude);
  static double _$longitude(UserTrackPoint v) => v.longitude;
  static const Field<UserTrackPoint, double> _f$longitude =
      Field('longitude', _$longitude);
  static double _$realSpeedKmh(UserTrackPoint v) => v.realSpeedKmh;
  static const Field<UserTrackPoint, double> _f$realSpeedKmh =
      Field('realSpeedKmh', _$realSpeedKmh);
  static double _$heading(UserTrackPoint v) => v.heading;
  static const Field<UserTrackPoint, double> _f$heading =
      Field('heading', _$heading);
  static double _$altitude(UserTrackPoint v) => v.altitude;
  static const Field<UserTrackPoint, double> _f$altitude =
      Field('altitude', _$altitude);
  static double _$odometer(UserTrackPoint v) => v.odometer;
  static const Field<UserTrackPoint, double> _f$odometer =
      Field('odometer', _$odometer);
  static DateTime _$timeStamp(UserTrackPoint v) => v.timeStamp;
  static const Field<UserTrackPoint, DateTime> _f$timeStamp =
      Field('timeStamp', _$timeStamp);

  @override
  final MappableFields<UserTrackPoint> fields = const {
    #latitude: _f$latitude,
    #longitude: _f$longitude,
    #realSpeedKmh: _f$realSpeedKmh,
    #heading: _f$heading,
    #altitude: _f$altitude,
    #odometer: _f$odometer,
    #timeStamp: _f$timeStamp,
  };

  static UserTrackPoint _instantiate(DecodingData data) {
    return UserTrackPoint(
        data.dec(_f$latitude),
        data.dec(_f$longitude),
        data.dec(_f$realSpeedKmh),
        data.dec(_f$heading),
        data.dec(_f$altitude),
        data.dec(_f$odometer),
        data.dec(_f$timeStamp));
  }

  @override
  final Function instantiate = _instantiate;

  static UserTrackPoint fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserTrackPoint>(map);
  }

  static UserTrackPoint fromJson(String json) {
    return ensureInitialized().decodeJson<UserTrackPoint>(json);
  }
}

mixin UserTrackPointMappable {
  String toJson() {
    return UserTrackPointMapper.ensureInitialized()
        .encodeJson<UserTrackPoint>(this as UserTrackPoint);
  }

  Map<String, dynamic> toMap() {
    return UserTrackPointMapper.ensureInitialized()
        .encodeMap<UserTrackPoint>(this as UserTrackPoint);
  }

  UserTrackPointCopyWith<UserTrackPoint, UserTrackPoint, UserTrackPoint>
      get copyWith => _UserTrackPointCopyWithImpl(
          this as UserTrackPoint, $identity, $identity);
  @override
  String toString() {
    return UserTrackPointMapper.ensureInitialized()
        .stringifyValue(this as UserTrackPoint);
  }

  @override
  bool operator ==(Object other) {
    return UserTrackPointMapper.ensureInitialized()
        .equalsValue(this as UserTrackPoint, other);
  }

  @override
  int get hashCode {
    return UserTrackPointMapper.ensureInitialized()
        .hashValue(this as UserTrackPoint);
  }
}

extension UserTrackPointValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserTrackPoint, $Out> {
  UserTrackPointCopyWith<$R, UserTrackPoint, $Out> get $asUserTrackPoint =>
      $base.as((v, t, t2) => _UserTrackPointCopyWithImpl(v, t, t2));
}

abstract class UserTrackPointCopyWith<$R, $In extends UserTrackPoint, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {double? latitude,
      double? longitude,
      double? realSpeedKmh,
      double? heading,
      double? altitude,
      double? odometer,
      DateTime? timeStamp});
  UserTrackPointCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _UserTrackPointCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserTrackPoint, $Out>
    implements UserTrackPointCopyWith<$R, UserTrackPoint, $Out> {
  _UserTrackPointCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserTrackPoint> $mapper =
      UserTrackPointMapper.ensureInitialized();
  @override
  $R call(
          {double? latitude,
          double? longitude,
          double? realSpeedKmh,
          double? heading,
          double? altitude,
          double? odometer,
          DateTime? timeStamp}) =>
      $apply(FieldCopyWithData({
        if (latitude != null) #latitude: latitude,
        if (longitude != null) #longitude: longitude,
        if (realSpeedKmh != null) #realSpeedKmh: realSpeedKmh,
        if (heading != null) #heading: heading,
        if (altitude != null) #altitude: altitude,
        if (odometer != null) #odometer: odometer,
        if (timeStamp != null) #timeStamp: timeStamp
      }));
  @override
  UserTrackPoint $make(CopyWithData data) => UserTrackPoint(
      data.get(#latitude, or: $value.latitude),
      data.get(#longitude, or: $value.longitude),
      data.get(#realSpeedKmh, or: $value.realSpeedKmh),
      data.get(#heading, or: $value.heading),
      data.get(#altitude, or: $value.altitude),
      data.get(#odometer, or: $value.odometer),
      data.get(#timeStamp, or: $value.timeStamp));

  @override
  UserTrackPointCopyWith<$R2, UserTrackPoint, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _UserTrackPointCopyWithImpl($value, $cast, t);
}

class UserTrackPointsMapper extends ClassMapperBase<UserTrackPoints> {
  UserTrackPointsMapper._();

  static UserTrackPointsMapper? _instance;
  static UserTrackPointsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserTrackPointsMapper._());
      UserTrackPointMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UserTrackPoints';

  static List<UserTrackPoint> _$utps(UserTrackPoints v) => v.utps;
  static const Field<UserTrackPoints, List<UserTrackPoint>> _f$utps =
      Field('utps', _$utps);

  @override
  final MappableFields<UserTrackPoints> fields = const {
    #utps: _f$utps,
  };

  static UserTrackPoints _instantiate(DecodingData data) {
    return UserTrackPoints(data.dec(_f$utps));
  }

  @override
  final Function instantiate = _instantiate;

  static UserTrackPoints fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserTrackPoints>(map);
  }

  static UserTrackPoints fromJson(String json) {
    return ensureInitialized().decodeJson<UserTrackPoints>(json);
  }
}

mixin UserTrackPointsMappable {
  String toJson() {
    return UserTrackPointsMapper.ensureInitialized()
        .encodeJson<UserTrackPoints>(this as UserTrackPoints);
  }

  Map<String, dynamic> toMap() {
    return UserTrackPointsMapper.ensureInitialized()
        .encodeMap<UserTrackPoints>(this as UserTrackPoints);
  }

  UserTrackPointsCopyWith<UserTrackPoints, UserTrackPoints, UserTrackPoints>
      get copyWith => _UserTrackPointsCopyWithImpl(
          this as UserTrackPoints, $identity, $identity);
  @override
  String toString() {
    return UserTrackPointsMapper.ensureInitialized()
        .stringifyValue(this as UserTrackPoints);
  }

  @override
  bool operator ==(Object other) {
    return UserTrackPointsMapper.ensureInitialized()
        .equalsValue(this as UserTrackPoints, other);
  }

  @override
  int get hashCode {
    return UserTrackPointsMapper.ensureInitialized()
        .hashValue(this as UserTrackPoints);
  }
}

extension UserTrackPointsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserTrackPoints, $Out> {
  UserTrackPointsCopyWith<$R, UserTrackPoints, $Out> get $asUserTrackPoints =>
      $base.as((v, t, t2) => _UserTrackPointsCopyWithImpl(v, t, t2));
}

abstract class UserTrackPointsCopyWith<$R, $In extends UserTrackPoints, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, UserTrackPoint,
      UserTrackPointCopyWith<$R, UserTrackPoint, UserTrackPoint>> get utps;
  $R call({List<UserTrackPoint>? utps});
  UserTrackPointsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _UserTrackPointsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserTrackPoints, $Out>
    implements UserTrackPointsCopyWith<$R, UserTrackPoints, $Out> {
  _UserTrackPointsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserTrackPoints> $mapper =
      UserTrackPointsMapper.ensureInitialized();
  @override
  ListCopyWith<$R, UserTrackPoint,
          UserTrackPointCopyWith<$R, UserTrackPoint, UserTrackPoint>>
      get utps => ListCopyWith(
          $value.utps, (v, t) => v.copyWith.$chain(t), (v) => call(utps: v));
  @override
  $R call({List<UserTrackPoint>? utps}) =>
      $apply(FieldCopyWithData({if (utps != null) #utps: utps}));
  @override
  UserTrackPoints $make(CopyWithData data) =>
      UserTrackPoints(data.get(#utps, or: $value.utps));

  @override
  UserTrackPointsCopyWith<$R2, UserTrackPoints, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _UserTrackPointsCopyWithImpl($value, $cast, t);
}
