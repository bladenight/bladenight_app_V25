// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element

part of 'shake_hand_result.dart';

class ShakeHandResultMapper extends ClassMapperBase<ShakeHandResult> {
  ShakeHandResultMapper._();

  static ShakeHandResultMapper? _instance;
  static ShakeHandResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ShakeHandResultMapper._());
    }
    return _instance!;
  }

  static T _guard<T>(T Function(MapperContainer) fn) {
    ensureInitialized();
    return fn(MapperContainer.globals);
  }

  @override
  final String id = 'ShakeHandResult';

  static bool _$status(ShakeHandResult v) => v.status;
  static const Field<ShakeHandResult, bool> _f$status =
      Field('status', _$status, key: 'sta');
  static int _$minBuild(ShakeHandResult v) => v.minBuild;
  static const Field<ShakeHandResult, int> _f$minBuild =
      Field('minBuild', _$minBuild, key: 'mbu');
  static Exception? _$rpcException(ShakeHandResult v) => v.rpcException;
  static const Field<ShakeHandResult, Exception> _f$rpcException =
      Field('rpcException', _$rpcException, opt: true);

  @override
  final Map<Symbol, Field<ShakeHandResult, dynamic>> fields = const {
    #status: _f$status,
    #minBuild: _f$minBuild,
    #rpcException: _f$rpcException,
  };

  static ShakeHandResult _instantiate(DecodingData data) {
    return ShakeHandResult(
        status: data.dec(_f$status),
        minBuild: data.dec(_f$minBuild),
        rpcException: data.dec(_f$rpcException));
  }

  @override
  final Function instantiate = _instantiate;

  static ShakeHandResult fromMap(Map<String, dynamic> map) {
    return _guard((c) => c.fromMap<ShakeHandResult>(map));
  }

  static ShakeHandResult fromJson(String json) {
    return _guard((c) => c.fromJson<ShakeHandResult>(json));
  }
}

mixin ShakeHandResultMappable {
  String toJson() {
    return ShakeHandResultMapper._guard(
        (c) => c.toJson(this as ShakeHandResult));
  }

  Map<String, dynamic> toMap() {
    return ShakeHandResultMapper._guard(
        (c) => c.toMap(this as ShakeHandResult));
  }

  ShakeHandResultCopyWith<ShakeHandResult, ShakeHandResult, ShakeHandResult>
      get copyWith => _ShakeHandResultCopyWithImpl(
          this as ShakeHandResult, $identity, $identity);
  @override
  String toString() {
    return ShakeHandResultMapper._guard((c) => c.asString(this));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            ShakeHandResultMapper._guard((c) => c.isEqual(this, other)));
  }

  @override
  int get hashCode {
    return ShakeHandResultMapper._guard((c) => c.hash(this));
  }
}

extension ShakeHandResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ShakeHandResult, $Out> {
  ShakeHandResultCopyWith<$R, ShakeHandResult, $Out> get $asShakeHandResult =>
      $base.as((v, t, t2) => _ShakeHandResultCopyWithImpl(v, t, t2));
}

abstract class ShakeHandResultCopyWith<$R, $In extends ShakeHandResult, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({bool? status, int? minBuild, Exception? rpcException});
  ShakeHandResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _ShakeHandResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ShakeHandResult, $Out>
    implements ShakeHandResultCopyWith<$R, ShakeHandResult, $Out> {
  _ShakeHandResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ShakeHandResult> $mapper =
      ShakeHandResultMapper.ensureInitialized();
  @override
  $R call({bool? status, int? minBuild, Object? rpcException = $none}) =>
      $apply(FieldCopyWithData({
        if (status != null) #status: status,
        if (minBuild != null) #minBuild: minBuild,
        if (rpcException != $none) #rpcException: rpcException
      }));
  @override
  ShakeHandResult $make(CopyWithData data) => ShakeHandResult(
      status: data.get(#status, or: $value.status),
      minBuild: data.get(#minBuild, or: $value.minBuild),
      rpcException: data.get(#rpcException, or: $value.rpcException));

  @override
  ShakeHandResultCopyWith<$R2, ShakeHandResult, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ShakeHandResultCopyWithImpl($value, $cast, t);
}
