// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'route_names.dart';

class RouteNamesMapper extends ClassMapperBase<RouteNames> {
  RouteNamesMapper._();

  static RouteNamesMapper? _instance;
  static RouteNamesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RouteNamesMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RouteNames';

  static List<String>? _$routeNames(RouteNames v) => v.routeNames;
  static const Field<RouteNames, List<String>> _f$routeNames =
      Field('routeNames', _$routeNames, key: 'rna');
  static Exception? _$exception(RouteNames v) => v.exception;
  static const Field<RouteNames, Exception> _f$exception =
      Field('exception', _$exception, opt: true);

  @override
  final MappableFields<RouteNames> fields = const {
    #routeNames: _f$routeNames,
    #exception: _f$exception,
  };

  static RouteNames _instantiate(DecodingData data) {
    return RouteNames(
        routeNames: data.dec(_f$routeNames), exception: data.dec(_f$exception));
  }

  @override
  final Function instantiate = _instantiate;

  static RouteNames fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RouteNames>(map);
  }

  static RouteNames fromJson(String json) {
    return ensureInitialized().decodeJson<RouteNames>(json);
  }
}

mixin RouteNamesMappable {
  String toJson() {
    return RouteNamesMapper.ensureInitialized()
        .encodeJson<RouteNames>(this as RouteNames);
  }

  Map<String, dynamic> toMap() {
    return RouteNamesMapper.ensureInitialized()
        .encodeMap<RouteNames>(this as RouteNames);
  }

  RouteNamesCopyWith<RouteNames, RouteNames, RouteNames> get copyWith =>
      _RouteNamesCopyWithImpl(this as RouteNames, $identity, $identity);
  @override
  String toString() {
    return RouteNamesMapper.ensureInitialized()
        .stringifyValue(this as RouteNames);
  }

  @override
  bool operator ==(Object other) {
    return RouteNamesMapper.ensureInitialized()
        .equalsValue(this as RouteNames, other);
  }

  @override
  int get hashCode {
    return RouteNamesMapper.ensureInitialized().hashValue(this as RouteNames);
  }
}

extension RouteNamesValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RouteNames, $Out> {
  RouteNamesCopyWith<$R, RouteNames, $Out> get $asRouteNames =>
      $base.as((v, t, t2) => _RouteNamesCopyWithImpl(v, t, t2));
}

abstract class RouteNamesCopyWith<$R, $In extends RouteNames, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get routeNames;
  $R call({List<String>? routeNames, Exception? exception});
  RouteNamesCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RouteNamesCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RouteNames, $Out>
    implements RouteNamesCopyWith<$R, RouteNames, $Out> {
  _RouteNamesCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RouteNames> $mapper =
      RouteNamesMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
      get routeNames => $value.routeNames != null
          ? ListCopyWith(
              $value.routeNames!,
              (v, t) => ObjectCopyWith(v, $identity, t),
              (v) => call(routeNames: v))
          : null;
  @override
  $R call({Object? routeNames = $none, Object? exception = $none}) =>
      $apply(FieldCopyWithData({
        if (routeNames != $none) #routeNames: routeNames,
        if (exception != $none) #exception: exception
      }));
  @override
  RouteNames $make(CopyWithData data) => RouteNames(
      routeNames: data.get(#routeNames, or: $value.routeNames),
      exception: data.get(#exception, or: $value.exception));

  @override
  RouteNamesCopyWith<$R2, RouteNames, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _RouteNamesCopyWithImpl($value, $cast, t);
}
