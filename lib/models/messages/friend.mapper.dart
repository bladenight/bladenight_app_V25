// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element

part of 'friend.dart';

class FriendMessageMapper extends ClassMapperBase<FriendMessage> {
  FriendMessageMapper._();

  static FriendMessageMapper? _instance;
  static FriendMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FriendMessageMapper._());
    }
    return _instance!;
  }

  static T _guard<T>(T Function(MapperContainer) fn) {
    ensureInitialized();
    return fn(MapperContainer.globals);
  }

  @override
  final String id = 'FriendMessage';

  static int _$requestId(FriendMessage v) => v.requestId;
  static const Field<FriendMessage, int> _f$requestId =
      Field('requestId', _$requestId, key: 'req');
  static bool _$online(FriendMessage v) => v.online;
  static const Field<FriendMessage, bool> _f$online =
      Field('online', _$online, key: 'onl');
  static int _$specialValue(FriendMessage v) => v.specialValue;
  static const Field<FriendMessage, int> _f$specialValue =
      Field('specialValue', _$specialValue, key: 'spv');
  static int? _$eta(FriendMessage v) => v.eta;
  static const Field<FriendMessage, int> _f$eta =
      Field('eta', _$eta, opt: true);
  static bool _$isOnRoute(FriendMessage v) => v.isOnRoute;
  static const Field<FriendMessage, bool> _f$isOnRoute =
      Field('isOnRoute', _$isOnRoute, key: 'ior');
  static bool _$isInProcession(FriendMessage v) => v.isInProcession;
  static const Field<FriendMessage, bool> _f$isInProcession =
      Field('isInProcession', _$isInProcession, key: 'iip');
  static double? _$latitude(FriendMessage v) => v.latitude;
  static const Field<FriendMessage, double> _f$latitude =
      Field('latitude', _$latitude, key: 'lat', opt: true);
  static double? _$longitude(FriendMessage v) => v.longitude;
  static const Field<FriendMessage, double> _f$longitude =
      Field('longitude', _$longitude, key: 'lon', opt: true);
  static int? _$accuracy(FriendMessage v) => v.accuracy;
  static const Field<FriendMessage, int> _f$accuracy =
      Field('accuracy', _$accuracy, key: 'acc', opt: true);
  static double? _$realSpeed(FriendMessage v) => v.realSpeed;
  static const Field<FriendMessage, double> _f$realSpeed =
      Field('realSpeed', _$realSpeed, key: 'rsp', opt: true);
  static int _$position(FriendMessage v) => v.position;
  static const Field<FriendMessage, int> _f$position =
      Field('position', _$position, key: 'pos');
  static double _$speed(FriendMessage v) => v.speed;
  static const Field<FriendMessage, double> _f$speed =
      Field('speed', _$speed, key: 'spd');
  static int _$friendId(FriendMessage v) => v.friendId;
  static const Field<FriendMessage, int> _f$friendId =
      Field('friendId', _$friendId, key: 'fid');

  @override
  final Map<Symbol, Field<FriendMessage, dynamic>> fields = const {
    #requestId: _f$requestId,
    #online: _f$online,
    #specialValue: _f$specialValue,
    #eta: _f$eta,
    #isOnRoute: _f$isOnRoute,
    #isInProcession: _f$isInProcession,
    #latitude: _f$latitude,
    #longitude: _f$longitude,
    #accuracy: _f$accuracy,
    #realSpeed: _f$realSpeed,
    #position: _f$position,
    #speed: _f$speed,
    #friendId: _f$friendId,
  };

  static FriendMessage _instantiate(DecodingData data) {
    return FriendMessage(
        requestId: data.dec(_f$requestId),
        online: data.dec(_f$online),
        specialValue: data.dec(_f$specialValue),
        eta: data.dec(_f$eta),
        isOnRoute: data.dec(_f$isOnRoute),
        isInProcession: data.dec(_f$isInProcession),
        latitude: data.dec(_f$latitude),
        longitude: data.dec(_f$longitude),
        accuracy: data.dec(_f$accuracy),
        realSpeed: data.dec(_f$realSpeed),
        position: data.dec(_f$position),
        speed: data.dec(_f$speed),
        friendId: data.dec(_f$friendId));
  }

  @override
  final Function instantiate = _instantiate;

  static FriendMessage fromMap(Map<String, dynamic> map) {
    return _guard((c) => c.fromMap<FriendMessage>(map));
  }

  static FriendMessage fromJson(String json) {
    return _guard((c) => c.fromJson<FriendMessage>(json));
  }
}

mixin FriendMessageMappable {
  String toJson() {
    return FriendMessageMapper._guard((c) => c.toJson(this as FriendMessage));
  }

  Map<String, dynamic> toMap() {
    return FriendMessageMapper._guard((c) => c.toMap(this as FriendMessage));
  }

  FriendMessageCopyWith<FriendMessage, FriendMessage, FriendMessage>
      get copyWith => _FriendMessageCopyWithImpl(
          this as FriendMessage, $identity, $identity);
  @override
  String toString() {
    return FriendMessageMapper._guard((c) => c.asString(this));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            FriendMessageMapper._guard((c) => c.isEqual(this, other)));
  }

  @override
  int get hashCode {
    return FriendMessageMapper._guard((c) => c.hash(this));
  }
}

extension FriendMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FriendMessage, $Out> {
  FriendMessageCopyWith<$R, FriendMessage, $Out> get $asFriendMessage =>
      $base.as((v, t, t2) => _FriendMessageCopyWithImpl(v, t, t2));
}

abstract class FriendMessageCopyWith<$R, $In extends FriendMessage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? requestId,
      bool? online,
      int? specialValue,
      int? eta,
      bool? isOnRoute,
      bool? isInProcession,
      double? latitude,
      double? longitude,
      int? accuracy,
      double? realSpeed,
      int? position,
      double? speed,
      int? friendId});
  FriendMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FriendMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FriendMessage, $Out>
    implements FriendMessageCopyWith<$R, FriendMessage, $Out> {
  _FriendMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FriendMessage> $mapper =
      FriendMessageMapper.ensureInitialized();
  @override
  $R call(
          {int? requestId,
          bool? online,
          int? specialValue,
          Object? eta = $none,
          bool? isOnRoute,
          bool? isInProcession,
          Object? latitude = $none,
          Object? longitude = $none,
          Object? accuracy = $none,
          Object? realSpeed = $none,
          int? position,
          double? speed,
          int? friendId}) =>
      $apply(FieldCopyWithData({
        if (requestId != null) #requestId: requestId,
        if (online != null) #online: online,
        if (specialValue != null) #specialValue: specialValue,
        if (eta != $none) #eta: eta,
        if (isOnRoute != null) #isOnRoute: isOnRoute,
        if (isInProcession != null) #isInProcession: isInProcession,
        if (latitude != $none) #latitude: latitude,
        if (longitude != $none) #longitude: longitude,
        if (accuracy != $none) #accuracy: accuracy,
        if (realSpeed != $none) #realSpeed: realSpeed,
        if (position != null) #position: position,
        if (speed != null) #speed: speed,
        if (friendId != null) #friendId: friendId
      }));
  @override
  FriendMessage $make(CopyWithData data) => FriendMessage(
      requestId: data.get(#requestId, or: $value.requestId),
      online: data.get(#online, or: $value.online),
      specialValue: data.get(#specialValue, or: $value.specialValue),
      eta: data.get(#eta, or: $value.eta),
      isOnRoute: data.get(#isOnRoute, or: $value.isOnRoute),
      isInProcession: data.get(#isInProcession, or: $value.isInProcession),
      latitude: data.get(#latitude, or: $value.latitude),
      longitude: data.get(#longitude, or: $value.longitude),
      accuracy: data.get(#accuracy, or: $value.accuracy),
      realSpeed: data.get(#realSpeed, or: $value.realSpeed),
      position: data.get(#position, or: $value.position),
      speed: data.get(#speed, or: $value.speed),
      friendId: data.get(#friendId, or: $value.friendId));

  @override
  FriendMessageCopyWith<$R2, FriendMessage, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _FriendMessageCopyWithImpl($value, $cast, t);
}
