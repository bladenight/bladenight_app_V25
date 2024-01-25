// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'realtime_update.dart';

class RealtimeUpdateMapper extends ClassMapperBase<RealtimeUpdate> {
  RealtimeUpdateMapper._();

  static RealtimeUpdateMapper? _instance;
  static RealtimeUpdateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RealtimeUpdateMapper._());
      MovingPointMapper.ensureInitialized();
      FriendsMessageMapper.ensureInitialized();
      EventStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'RealtimeUpdate';

  static MovingPoint _$head(RealtimeUpdate v) => v.head;
  static const Field<RealtimeUpdate, MovingPoint> _f$head =
      Field('head', _$head, key: 'hea');
  static MovingPoint _$tail(RealtimeUpdate v) => v.tail;
  static const Field<RealtimeUpdate, MovingPoint> _f$tail =
      Field('tail', _$tail, key: 'tai');
  static MovingPoint _$user(RealtimeUpdate v) => v.user;
  static const Field<RealtimeUpdate, MovingPoint> _f$user =
      Field('user', _$user, key: 'up');
  static double _$runningLength(RealtimeUpdate v) => v.runningLength;
  static const Field<RealtimeUpdate, double> _f$runningLength =
      Field('runningLength', _$runningLength, key: 'rle');
  static String _$routeName(RealtimeUpdate v) => v.routeName;
  static const Field<RealtimeUpdate, String> _f$routeName =
      Field('routeName', _$routeName, key: 'rna');
  static String _$usersTracking(RealtimeUpdate v) => v.usersTracking;
  static const Field<RealtimeUpdate, String> _f$usersTracking =
      Field('usersTracking', _$usersTracking, key: 'ust');
  static String _$users(RealtimeUpdate v) => v.users;
  static const Field<RealtimeUpdate, String> _f$users =
      Field('users', _$users, key: 'usr');
  static FriendsMessage _$friends(RealtimeUpdate v) => v.friends;
  static const Field<RealtimeUpdate, FriendsMessage> _f$friends =
      Field('friends', _$friends, key: 'fri');
  static int? _$specialFunction(RealtimeUpdate v) => v.specialFunction;
  static const Field<RealtimeUpdate, int> _f$specialFunction =
      Field('specialFunction', _$specialFunction, key: 'spf', opt: true);
  static Exception? _$rpcException(RealtimeUpdate v) => v.rpcException;
  static const Field<RealtimeUpdate, Exception> _f$rpcException =
      Field('rpcException', _$rpcException, opt: true);
  static EventStatus? _$eventState(RealtimeUpdate v) => v.eventState;
  static const Field<RealtimeUpdate, EventStatus> _f$eventState =
      Field('eventState', _$eventState, key: 'sts', opt: true);
  static bool _$eventIsActive(RealtimeUpdate v) => v.eventIsActive;
  static const Field<RealtimeUpdate, bool> _f$eventIsActive =
      Field('eventIsActive', _$eventIsActive, key: 'isa', opt: true, def: true);

  @override
  final MappableFields<RealtimeUpdate> fields = const {
    #head: _f$head,
    #tail: _f$tail,
    #user: _f$user,
    #runningLength: _f$runningLength,
    #routeName: _f$routeName,
    #usersTracking: _f$usersTracking,
    #users: _f$users,
    #friends: _f$friends,
    #specialFunction: _f$specialFunction,
    #rpcException: _f$rpcException,
    #eventState: _f$eventState,
    #eventIsActive: _f$eventIsActive,
  };

  static RealtimeUpdate _instantiate(DecodingData data) {
    return RealtimeUpdate(
        head: data.dec(_f$head),
        tail: data.dec(_f$tail),
        user: data.dec(_f$user),
        runningLength: data.dec(_f$runningLength),
        routeName: data.dec(_f$routeName),
        usersTracking: data.dec(_f$usersTracking),
        users: data.dec(_f$users),
        friends: data.dec(_f$friends),
        specialFunction: data.dec(_f$specialFunction),
        rpcException: data.dec(_f$rpcException),
        eventState: data.dec(_f$eventState),
        eventIsActive: data.dec(_f$eventIsActive));
  }

  @override
  final Function instantiate = _instantiate;

  static RealtimeUpdate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RealtimeUpdate>(map);
  }

  static RealtimeUpdate fromJson(String json) {
    return ensureInitialized().decodeJson<RealtimeUpdate>(json);
  }
}

mixin RealtimeUpdateMappable {
  String toJson() {
    return RealtimeUpdateMapper.ensureInitialized()
        .encodeJson<RealtimeUpdate>(this as RealtimeUpdate);
  }

  Map<String, dynamic> toMap() {
    return RealtimeUpdateMapper.ensureInitialized()
        .encodeMap<RealtimeUpdate>(this as RealtimeUpdate);
  }

  RealtimeUpdateCopyWith<RealtimeUpdate, RealtimeUpdate, RealtimeUpdate>
      get copyWith => _RealtimeUpdateCopyWithImpl(
          this as RealtimeUpdate, $identity, $identity);
  @override
  String toString() {
    return RealtimeUpdateMapper.ensureInitialized()
        .stringifyValue(this as RealtimeUpdate);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            RealtimeUpdateMapper.ensureInitialized()
                .isValueEqual(this as RealtimeUpdate, other));
  }

  @override
  int get hashCode {
    return RealtimeUpdateMapper.ensureInitialized()
        .hashValue(this as RealtimeUpdate);
  }
}

extension RealtimeUpdateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RealtimeUpdate, $Out> {
  RealtimeUpdateCopyWith<$R, RealtimeUpdate, $Out> get $asRealtimeUpdate =>
      $base.as((v, t, t2) => _RealtimeUpdateCopyWithImpl(v, t, t2));
}

abstract class RealtimeUpdateCopyWith<$R, $In extends RealtimeUpdate, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MovingPointCopyWith<$R, MovingPoint, MovingPoint> get head;
  MovingPointCopyWith<$R, MovingPoint, MovingPoint> get tail;
  MovingPointCopyWith<$R, MovingPoint, MovingPoint> get user;
  FriendsMessageCopyWith<$R, FriendsMessage, FriendsMessage> get friends;
  $R call(
      {MovingPoint? head,
      MovingPoint? tail,
      MovingPoint? user,
      double? runningLength,
      String? routeName,
      String? usersTracking,
      String? users,
      FriendsMessage? friends,
      int? specialFunction,
      Exception? rpcException,
      EventStatus? eventState,
      bool? eventIsActive});
  RealtimeUpdateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _RealtimeUpdateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RealtimeUpdate, $Out>
    implements RealtimeUpdateCopyWith<$R, RealtimeUpdate, $Out> {
  _RealtimeUpdateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RealtimeUpdate> $mapper =
      RealtimeUpdateMapper.ensureInitialized();
  @override
  MovingPointCopyWith<$R, MovingPoint, MovingPoint> get head =>
      $value.head.copyWith.$chain((v) => call(head: v));
  @override
  MovingPointCopyWith<$R, MovingPoint, MovingPoint> get tail =>
      $value.tail.copyWith.$chain((v) => call(tail: v));
  @override
  MovingPointCopyWith<$R, MovingPoint, MovingPoint> get user =>
      $value.user.copyWith.$chain((v) => call(user: v));
  @override
  FriendsMessageCopyWith<$R, FriendsMessage, FriendsMessage> get friends =>
      $value.friends.copyWith.$chain((v) => call(friends: v));
  @override
  $R call(
          {MovingPoint? head,
          MovingPoint? tail,
          MovingPoint? user,
          double? runningLength,
          String? routeName,
          String? usersTracking,
          String? users,
          FriendsMessage? friends,
          Object? specialFunction = $none,
          Object? rpcException = $none,
          Object? eventState = $none,
          bool? eventIsActive}) =>
      $apply(FieldCopyWithData({
        if (head != null) #head: head,
        if (tail != null) #tail: tail,
        if (user != null) #user: user,
        if (runningLength != null) #runningLength: runningLength,
        if (routeName != null) #routeName: routeName,
        if (usersTracking != null) #usersTracking: usersTracking,
        if (users != null) #users: users,
        if (friends != null) #friends: friends,
        if (specialFunction != $none) #specialFunction: specialFunction,
        if (rpcException != $none) #rpcException: rpcException,
        if (eventState != $none) #eventState: eventState,
        if (eventIsActive != null) #eventIsActive: eventIsActive
      }));
  @override
  RealtimeUpdate $make(CopyWithData data) => RealtimeUpdate(
      head: data.get(#head, or: $value.head),
      tail: data.get(#tail, or: $value.tail),
      user: data.get(#user, or: $value.user),
      runningLength: data.get(#runningLength, or: $value.runningLength),
      routeName: data.get(#routeName, or: $value.routeName),
      usersTracking: data.get(#usersTracking, or: $value.usersTracking),
      users: data.get(#users, or: $value.users),
      friends: data.get(#friends, or: $value.friends),
      specialFunction: data.get(#specialFunction, or: $value.specialFunction),
      rpcException: data.get(#rpcException, or: $value.rpcException),
      eventState: data.get(#eventState, or: $value.eventState),
      eventIsActive: data.get(#eventIsActive, or: $value.eventIsActive));

  @override
  RealtimeUpdateCopyWith<$R2, RealtimeUpdate, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _RealtimeUpdateCopyWithImpl($value, $cast, t);
}
