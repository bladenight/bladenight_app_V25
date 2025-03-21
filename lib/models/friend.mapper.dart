// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'friend.dart';

class FriendMapper extends ClassMapperBase<Friend> {
  FriendMapper._();

  static FriendMapper? _instance;
  static FriendMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FriendMapper._());
      MapperContainer.globals.useAll([ColorMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'Friend';

  static String _$name(Friend v) => v.name;
  static const Field<Friend, String> _f$name = Field('name', _$name);
  static int _$friendId(Friend v) => v.friendId;
  static const Field<Friend, int> _f$friendId =
      Field('friendId', _$friendId, key: r'friendid');
  static Color _$color(Friend v) => v.color;
  static const Field<Friend, Color> _f$color =
      Field('color', _$color, opt: true, def: Colors.white24);
  static bool _$isActive(Friend v) => v.isActive;
  static const Field<Friend, bool> _f$isActive =
      Field('isActive', _$isActive, opt: true, def: true);
  static int _$requestId(Friend v) => v.requestId;
  static const Field<Friend, int> _f$requestId =
      Field('requestId', _$requestId, opt: true, def: 0);
  static bool _$isOnline(Friend v) => v.isOnline;
  static const Field<Friend, bool> _f$isOnline =
      Field('isOnline', _$isOnline, opt: true, def: false);
  static double _$speed(Friend v) => v.speed;
  static const Field<Friend, double> _f$speed =
      Field('speed', _$speed, opt: true, def: 0);
  static double? _$longitude(Friend v) => v.longitude;
  static const Field<Friend, double> _f$longitude =
      Field('longitude', _$longitude, opt: true, def: 0.0);
  static double? _$latitude(Friend v) => v.latitude;
  static const Field<Friend, double> _f$latitude =
      Field('latitude', _$latitude, opt: true, def: 0.0);
  static int? _$relativeTime(Friend v) => v.relativeTime;
  static const Field<Friend, int> _f$relativeTime =
      Field('relativeTime', _$relativeTime, opt: true, def: 0);
  static int _$relativeDistance(Friend v) => v.relativeDistance;
  static const Field<Friend, int> _f$relativeDistance =
      Field('relativeDistance', _$relativeDistance, opt: true, def: 0);
  static int _$absolutePosition(Friend v) => v.absolutePosition;
  static const Field<Friend, int> _f$absolutePosition =
      Field('absolutePosition', _$absolutePosition, opt: true, def: 0);
  static int? _$distanceToUser(Friend v) => v.distanceToUser;
  static const Field<Friend, int> _f$distanceToUser =
      Field('distanceToUser', _$distanceToUser, opt: true, def: 0);
  static int _$specialValue(Friend v) => v.specialValue;
  static const Field<Friend, int> _f$specialValue =
      Field('specialValue', _$specialValue, key: r'spv', opt: true, def: 0);
  static int? _$timeToUser(Friend v) => v.timeToUser;
  static const Field<Friend, int> _f$timeToUser =
      Field('timeToUser', _$timeToUser, opt: true, def: 0);
  static int? _$timestamp(Friend v) => v.timestamp;
  static const Field<Friend, int> _f$timestamp =
      Field('timestamp', _$timestamp, opt: true, def: 0);
  static int? _$codeTimestamp(Friend v) => v.codeTimestamp;
  static const Field<Friend, int> _f$codeTimestamp =
      Field('codeTimestamp', _$codeTimestamp, opt: true, def: 0);
  static bool _$hasServerEntry(Friend v) => v.hasServerEntry;
  static const Field<Friend, bool> _f$hasServerEntry =
      Field('hasServerEntry', _$hasServerEntry, opt: true, def: true);
  static double _$realSpeed(Friend v) => v.realSpeed;
  static const Field<Friend, double> _f$realSpeed =
      Field('realSpeed', _$realSpeed, key: r'rsp');

  @override
  final MappableFields<Friend> fields = const {
    #name: _f$name,
    #friendId: _f$friendId,
    #color: _f$color,
    #isActive: _f$isActive,
    #requestId: _f$requestId,
    #isOnline: _f$isOnline,
    #speed: _f$speed,
    #longitude: _f$longitude,
    #latitude: _f$latitude,
    #relativeTime: _f$relativeTime,
    #relativeDistance: _f$relativeDistance,
    #absolutePosition: _f$absolutePosition,
    #distanceToUser: _f$distanceToUser,
    #specialValue: _f$specialValue,
    #timeToUser: _f$timeToUser,
    #timestamp: _f$timestamp,
    #codeTimestamp: _f$codeTimestamp,
    #hasServerEntry: _f$hasServerEntry,
    #realSpeed: _f$realSpeed,
  };

  static Friend _instantiate(DecodingData data) {
    return Friend(
        name: data.dec(_f$name),
        friendId: data.dec(_f$friendId),
        color: data.dec(_f$color),
        isActive: data.dec(_f$isActive),
        requestId: data.dec(_f$requestId),
        isOnline: data.dec(_f$isOnline),
        speed: data.dec(_f$speed),
        longitude: data.dec(_f$longitude),
        latitude: data.dec(_f$latitude),
        relativeTime: data.dec(_f$relativeTime),
        relativeDistance: data.dec(_f$relativeDistance),
        absolutePosition: data.dec(_f$absolutePosition),
        distanceToUser: data.dec(_f$distanceToUser),
        specialValue: data.dec(_f$specialValue),
        timeToUser: data.dec(_f$timeToUser),
        timestamp: data.dec(_f$timestamp),
        codeTimestamp: data.dec(_f$codeTimestamp),
        hasServerEntry: data.dec(_f$hasServerEntry));
  }

  @override
  final Function instantiate = _instantiate;

  static Friend fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Friend>(map);
  }

  static Friend fromJson(String json) {
    return ensureInitialized().decodeJson<Friend>(json);
  }
}

mixin FriendMappable {
  String toJson() {
    return FriendMapper.ensureInitialized().encodeJson<Friend>(this as Friend);
  }

  Map<String, dynamic> toMap() {
    return FriendMapper.ensureInitialized().encodeMap<Friend>(this as Friend);
  }

  FriendCopyWith<Friend, Friend, Friend> get copyWith =>
      _FriendCopyWithImpl(this as Friend, $identity, $identity);
  @override
  String toString() {
    return FriendMapper.ensureInitialized().stringifyValue(this as Friend);
  }

  @override
  bool operator ==(Object other) {
    return FriendMapper.ensureInitialized().equalsValue(this as Friend, other);
  }

  @override
  int get hashCode {
    return FriendMapper.ensureInitialized().hashValue(this as Friend);
  }
}

extension FriendValueCopy<$R, $Out> on ObjectCopyWith<$R, Friend, $Out> {
  FriendCopyWith<$R, Friend, $Out> get $asFriend =>
      $base.as((v, t, t2) => _FriendCopyWithImpl(v, t, t2));
}

abstract class FriendCopyWith<$R, $In extends Friend, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? name,
      int? friendId,
      Color? color,
      bool? isActive,
      int? requestId,
      bool? isOnline,
      double? speed,
      double? longitude,
      double? latitude,
      int? relativeTime,
      int? relativeDistance,
      int? absolutePosition,
      int? distanceToUser,
      int? specialValue,
      int? timeToUser,
      int? timestamp,
      int? codeTimestamp,
      bool? hasServerEntry});
  FriendCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FriendCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Friend, $Out>
    implements FriendCopyWith<$R, Friend, $Out> {
  _FriendCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Friend> $mapper = FriendMapper.ensureInitialized();
  @override
  $R call(
          {String? name,
          int? friendId,
          Color? color,
          bool? isActive,
          int? requestId,
          bool? isOnline,
          double? speed,
          Object? longitude = $none,
          Object? latitude = $none,
          Object? relativeTime = $none,
          int? relativeDistance,
          int? absolutePosition,
          Object? distanceToUser = $none,
          int? specialValue,
          Object? timeToUser = $none,
          Object? timestamp = $none,
          Object? codeTimestamp = $none,
          bool? hasServerEntry}) =>
      $apply(FieldCopyWithData({
        if (name != null) #name: name,
        if (friendId != null) #friendId: friendId,
        if (color != null) #color: color,
        if (isActive != null) #isActive: isActive,
        if (requestId != null) #requestId: requestId,
        if (isOnline != null) #isOnline: isOnline,
        if (speed != null) #speed: speed,
        if (longitude != $none) #longitude: longitude,
        if (latitude != $none) #latitude: latitude,
        if (relativeTime != $none) #relativeTime: relativeTime,
        if (relativeDistance != null) #relativeDistance: relativeDistance,
        if (absolutePosition != null) #absolutePosition: absolutePosition,
        if (distanceToUser != $none) #distanceToUser: distanceToUser,
        if (specialValue != null) #specialValue: specialValue,
        if (timeToUser != $none) #timeToUser: timeToUser,
        if (timestamp != $none) #timestamp: timestamp,
        if (codeTimestamp != $none) #codeTimestamp: codeTimestamp,
        if (hasServerEntry != null) #hasServerEntry: hasServerEntry
      }));
  @override
  Friend $make(CopyWithData data) => Friend(
      name: data.get(#name, or: $value.name),
      friendId: data.get(#friendId, or: $value.friendId),
      color: data.get(#color, or: $value.color),
      isActive: data.get(#isActive, or: $value.isActive),
      requestId: data.get(#requestId, or: $value.requestId),
      isOnline: data.get(#isOnline, or: $value.isOnline),
      speed: data.get(#speed, or: $value.speed),
      longitude: data.get(#longitude, or: $value.longitude),
      latitude: data.get(#latitude, or: $value.latitude),
      relativeTime: data.get(#relativeTime, or: $value.relativeTime),
      relativeDistance:
          data.get(#relativeDistance, or: $value.relativeDistance),
      absolutePosition:
          data.get(#absolutePosition, or: $value.absolutePosition),
      distanceToUser: data.get(#distanceToUser, or: $value.distanceToUser),
      specialValue: data.get(#specialValue, or: $value.specialValue),
      timeToUser: data.get(#timeToUser, or: $value.timeToUser),
      timestamp: data.get(#timestamp, or: $value.timestamp),
      codeTimestamp: data.get(#codeTimestamp, or: $value.codeTimestamp),
      hasServerEntry: data.get(#hasServerEntry, or: $value.hasServerEntry));

  @override
  FriendCopyWith<$R2, Friend, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FriendCopyWithImpl($value, $cast, t);
}
