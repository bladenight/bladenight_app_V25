// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'route.dart';

class RoutePointsMapper extends ClassMapperBase<RoutePoints> {
  RoutePointsMapper._();

  static RoutePointsMapper? _instance;
  static RoutePointsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RoutePointsMapper._());
      MapperContainer.globals.useAll([LatLngMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'RoutePoints';

  static String _$name(RoutePoints v) => v.name;
  static const Field<RoutePoints, String> _f$name =
      Field('name', _$name, key: 'nam');
  static List<LatLng> _$points(RoutePoints v) => v.points;
  static const Field<RoutePoints, List<LatLng>> _f$points =
      Field('points', _$points, key: 'nod');
  static Exception? _$rpcException(RoutePoints v) => v.rpcException;
  static const Field<RoutePoints, Exception> _f$rpcException =
      Field('rpcException', _$rpcException, opt: true);
  static DateTime? _$lastUpdate(RoutePoints v) => v.lastUpdate;
  static const Field<RoutePoints, DateTime> _f$lastUpdate =
      Field('lastUpdate', _$lastUpdate, mode: FieldMode.member);

  @override
  final MappableFields<RoutePoints> fields = const {
    #name: _f$name,
    #points: _f$points,
    #rpcException: _f$rpcException,
    #lastUpdate: _f$lastUpdate,
  };

  static RoutePoints _instantiate(DecodingData data) {
    return RoutePoints(
        data.dec(_f$name), data.dec(_f$points), data.dec(_f$rpcException));
  }

  @override
  final Function instantiate = _instantiate;

  static RoutePoints fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RoutePoints>(map);
  }

  static RoutePoints fromJson(String json) {
    return ensureInitialized().decodeJson<RoutePoints>(json);
  }
}

mixin RoutePointsMappable {
  String toJson() {
    return RoutePointsMapper.ensureInitialized()
        .encodeJson<RoutePoints>(this as RoutePoints);
  }

  Map<String, dynamic> toMap() {
    return RoutePointsMapper.ensureInitialized()
        .encodeMap<RoutePoints>(this as RoutePoints);
  }

  RoutePointsCopyWith<RoutePoints, RoutePoints, RoutePoints> get copyWith =>
      _RoutePointsCopyWithImpl(this as RoutePoints, $identity, $identity);
  @override
  String toString() {
    return RoutePointsMapper.ensureInitialized()
        .stringifyValue(this as RoutePoints);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            RoutePointsMapper.ensureInitialized()
                .isValueEqual(this as RoutePoints, other));
  }

  @override
  int get hashCode {
    return RoutePointsMapper.ensureInitialized().hashValue(this as RoutePoints);
  }
}

extension RoutePointsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RoutePoints, $Out> {
  RoutePointsCopyWith<$R, RoutePoints, $Out> get $asRoutePoints =>
      $base.as((v, t, t2) => _RoutePointsCopyWithImpl(v, t, t2));
}

abstract class RoutePointsCopyWith<$R, $In extends RoutePoints, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, LatLng, ObjectCopyWith<$R, LatLng, LatLng>> get points;
  $R call({String? name, List<LatLng>? points, Exception? rpcException});
  RoutePointsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RoutePointsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RoutePoints, $Out>
    implements RoutePointsCopyWith<$R, RoutePoints, $Out> {
  _RoutePointsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RoutePoints> $mapper =
      RoutePointsMapper.ensureInitialized();
  @override
  ListCopyWith<$R, LatLng, ObjectCopyWith<$R, LatLng, LatLng>> get points =>
      ListCopyWith($value.points, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(points: v));
  @override
  $R call({String? name, List<LatLng>? points, Object? rpcException = $none}) =>
      $apply(FieldCopyWithData({
        if (name != null) #name: name,
        if (points != null) #points: points,
        if (rpcException != $none) #rpcException: rpcException
      }));
  @override
  RoutePoints $make(CopyWithData data) => RoutePoints(
      data.get(#name, or: $value.name),
      data.get(#points, or: $value.points),
      data.get(#rpcException, or: $value.rpcException));

  @override
  RoutePointsCopyWith<$R2, RoutePoints, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _RoutePointsCopyWithImpl($value, $cast, t);
}
