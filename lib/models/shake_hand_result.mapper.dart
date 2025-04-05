// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

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

  @override
  final String id = 'ShakeHandResult';

  static bool _$status(ShakeHandResult v) => v.status;
  static const Field<ShakeHandResult, bool> _f$status =
      Field('status', _$status, key: r'sta');
  static int _$minBuild(ShakeHandResult v) => v.minBuild;
  static const Field<ShakeHandResult, int> _f$minBuild =
      Field('minBuild', _$minBuild, key: r'mbu');
  static String? _$serverVersion(ShakeHandResult v) => v.serverVersion;
  static const Field<ShakeHandResult, String> _f$serverVersion =
      Field('serverVersion', _$serverVersion, key: r'ver', opt: true);
  static Exception? _$rpcException(ShakeHandResult v) => v.rpcException;
  static const Field<ShakeHandResult, Exception> _f$rpcException =
      Field('rpcException', _$rpcException, opt: true);

  @override
  final MappableFields<ShakeHandResult> fields = const {
    #status: _f$status,
    #minBuild: _f$minBuild,
    #serverVersion: _f$serverVersion,
    #rpcException: _f$rpcException,
  };

  static ShakeHandResult _instantiate(DecodingData data) {
    return ShakeHandResult(
        status: data.dec(_f$status),
        minBuild: data.dec(_f$minBuild),
        serverVersion: data.dec(_f$serverVersion),
        rpcException: data.dec(_f$rpcException));
  }

  @override
  final Function instantiate = _instantiate;

  static ShakeHandResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ShakeHandResult>(map);
  }

  static ShakeHandResult fromJson(String json) {
    return ensureInitialized().decodeJson<ShakeHandResult>(json);
  }
}

mixin ShakeHandResultMappable {
  String toJson() {
    return ShakeHandResultMapper.ensureInitialized()
        .encodeJson<ShakeHandResult>(this as ShakeHandResult);
  }

  Map<String, dynamic> toMap() {
    return ShakeHandResultMapper.ensureInitialized()
        .encodeMap<ShakeHandResult>(this as ShakeHandResult);
  }

  ShakeHandResultCopyWith<ShakeHandResult, ShakeHandResult, ShakeHandResult>
      get copyWith =>
          _ShakeHandResultCopyWithImpl<ShakeHandResult, ShakeHandResult>(
              this as ShakeHandResult, $identity, $identity);
  @override
  String toString() {
    return ShakeHandResultMapper.ensureInitialized()
        .stringifyValue(this as ShakeHandResult);
  }

  @override
  bool operator ==(Object other) {
    return ShakeHandResultMapper.ensureInitialized()
        .equalsValue(this as ShakeHandResult, other);
  }

  @override
  int get hashCode {
    return ShakeHandResultMapper.ensureInitialized()
        .hashValue(this as ShakeHandResult);
  }
}

extension ShakeHandResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ShakeHandResult, $Out> {
  ShakeHandResultCopyWith<$R, ShakeHandResult, $Out> get $asShakeHandResult =>
      $base.as((v, t, t2) => _ShakeHandResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ShakeHandResultCopyWith<$R, $In extends ShakeHandResult, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {bool? status,
      int? minBuild,
      String? serverVersion,
      Exception? rpcException});
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
  $R call(
          {bool? status,
          int? minBuild,
          Object? serverVersion = $none,
          Object? rpcException = $none}) =>
      $apply(FieldCopyWithData({
        if (status != null) #status: status,
        if (minBuild != null) #minBuild: minBuild,
        if (serverVersion != $none) #serverVersion: serverVersion,
        if (rpcException != $none) #rpcException: rpcException
      }));
  @override
  ShakeHandResult $make(CopyWithData data) => ShakeHandResult(
      status: data.get(#status, or: $value.status),
      minBuild: data.get(#minBuild, or: $value.minBuild),
      serverVersion: data.get(#serverVersion, or: $value.serverVersion),
      rpcException: data.get(#rpcException, or: $value.rpcException));

  @override
  ShakeHandResultCopyWith<$R2, ShakeHandResult, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ShakeHandResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
