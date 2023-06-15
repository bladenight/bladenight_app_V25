// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element

part of 'shake_hands.dart';

class ShakeHandMapper extends ClassMapperBase<ShakeHand> {
  ShakeHandMapper._();

  static ShakeHandMapper? _instance;
  static ShakeHandMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ShakeHandMapper._());
    }
    return _instance!;
  }

  static T _guard<T>(T Function(MapperContainer) fn) {
    ensureInitialized();
    return fn(MapperContainer.globals);
  }

  @override
  final String id = 'ShakeHand';

  static int _$build(ShakeHand v) => v.build;
  static const Field<ShakeHand, int> _f$build =
      Field('build', _$build, key: 'bui');
  static String _$deviceId(ShakeHand v) => v.deviceId;
  static const Field<ShakeHand, String> _f$deviceId =
      Field('deviceId', _$deviceId, key: 'did');
  static String _$manufacturer(ShakeHand v) => v.manufacturer;
  static const Field<ShakeHand, String> _f$manufacturer = Field(
      'manufacturer', _$manufacturer,
      key: 'man', opt: true, def: 'unknown');
  static String _$model(ShakeHand v) => v.model;
  static const Field<ShakeHand, String> _f$model =
      Field('model', _$model, key: 'mod', opt: true, def: 'unknown');
  static String _$osversion(ShakeHand v) => v.osversion;
  static const Field<ShakeHand, String> _f$osversion =
      Field('osversion', _$osversion, key: 'rel', opt: true, def: 'unknown');

  @override
  final Map<Symbol, Field<ShakeHand, dynamic>> fields = const {
    #build: _f$build,
    #deviceId: _f$deviceId,
    #manufacturer: _f$manufacturer,
    #model: _f$model,
    #osversion: _f$osversion,
  };

  static ShakeHand _instantiate(DecodingData data) {
    return ShakeHand(
        build: data.dec(_f$build),
        deviceId: data.dec(_f$deviceId),
        manufacturer: data.dec(_f$manufacturer),
        model: data.dec(_f$model),
        osversion: data.dec(_f$osversion));
  }

  @override
  final Function instantiate = _instantiate;

  static ShakeHand fromMap(Map<String, dynamic> map) {
    return _guard((c) => c.fromMap<ShakeHand>(map));
  }

  static ShakeHand fromJson(String json) {
    return _guard((c) => c.fromJson<ShakeHand>(json));
  }
}

mixin ShakeHandMappable {
  String toJson() {
    return ShakeHandMapper._guard((c) => c.toJson(this as ShakeHand));
  }

  Map<String, dynamic> toMap() {
    return ShakeHandMapper._guard((c) => c.toMap(this as ShakeHand));
  }

  ShakeHandCopyWith<ShakeHand, ShakeHand, ShakeHand> get copyWith =>
      _ShakeHandCopyWithImpl(this as ShakeHand, $identity, $identity);
  @override
  String toString() {
    return ShakeHandMapper._guard((c) => c.asString(this));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            ShakeHandMapper._guard((c) => c.isEqual(this, other)));
  }

  @override
  int get hashCode {
    return ShakeHandMapper._guard((c) => c.hash(this));
  }
}

extension ShakeHandValueCopy<$R, $Out> on ObjectCopyWith<$R, ShakeHand, $Out> {
  ShakeHandCopyWith<$R, ShakeHand, $Out> get $asShakeHand =>
      $base.as((v, t, t2) => _ShakeHandCopyWithImpl(v, t, t2));
}

abstract class ShakeHandCopyWith<$R, $In extends ShakeHand, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? build,
      String? deviceId,
      String? manufacturer,
      String? model,
      String? osversion});
  ShakeHandCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ShakeHandCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ShakeHand, $Out>
    implements ShakeHandCopyWith<$R, ShakeHand, $Out> {
  _ShakeHandCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ShakeHand> $mapper =
      ShakeHandMapper.ensureInitialized();
  @override
  $R call(
          {int? build,
          String? deviceId,
          String? manufacturer,
          String? model,
          String? osversion}) =>
      $apply(FieldCopyWithData({
        if (build != null) #build: build,
        if (deviceId != null) #deviceId: deviceId,
        if (manufacturer != null) #manufacturer: manufacturer,
        if (model != null) #model: model,
        if (osversion != null) #osversion: osversion
      }));
  @override
  ShakeHand $make(CopyWithData data) => ShakeHand(
      build: data.get(#build, or: $value.build),
      deviceId: data.get(#deviceId, or: $value.deviceId),
      manufacturer: data.get(#manufacturer, or: $value.manufacturer),
      model: data.get(#model, or: $value.model),
      osversion: data.get(#osversion, or: $value.osversion));

  @override
  ShakeHandCopyWith<$R2, ShakeHand, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ShakeHandCopyWithImpl($value, $cast, t);
}
