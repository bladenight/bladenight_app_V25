// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'friends.dart';

class FriendsMapper extends ClassMapperBase<Friends> {
  FriendsMapper._();

  static FriendsMapper? _instance;
  static FriendsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FriendsMapper._());
      FriendMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Friends';

  static List<Friend> _$friends(Friends v) => v.friends;
  static const Field<Friends, List<Friend>> _f$friends =
      Field('friends', _$friends);

  @override
  final MappableFields<Friends> fields = const {
    #friends: _f$friends,
  };

  static Friends _instantiate(DecodingData data) {
    return Friends(friends: data.dec(_f$friends));
  }

  @override
  final Function instantiate = _instantiate;

  static Friends fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Friends>(map);
  }

  static Friends fromJson(String json) {
    return ensureInitialized().decodeJson<Friends>(json);
  }
}

mixin FriendsMappable {
  String toJson() {
    return FriendsMapper.ensureInitialized()
        .encodeJson<Friends>(this as Friends);
  }

  Map<String, dynamic> toMap() {
    return FriendsMapper.ensureInitialized()
        .encodeMap<Friends>(this as Friends);
  }

  FriendsCopyWith<Friends, Friends, Friends> get copyWith =>
      _FriendsCopyWithImpl(this as Friends, $identity, $identity);
  @override
  String toString() {
    return FriendsMapper.ensureInitialized().stringifyValue(this as Friends);
  }

  @override
  bool operator ==(Object other) {
    return FriendsMapper.ensureInitialized()
        .equalsValue(this as Friends, other);
  }

  @override
  int get hashCode {
    return FriendsMapper.ensureInitialized().hashValue(this as Friends);
  }
}

extension FriendsValueCopy<$R, $Out> on ObjectCopyWith<$R, Friends, $Out> {
  FriendsCopyWith<$R, Friends, $Out> get $asFriends =>
      $base.as((v, t, t2) => _FriendsCopyWithImpl(v, t, t2));
}

abstract class FriendsCopyWith<$R, $In extends Friends, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Friend, FriendCopyWith<$R, Friend, Friend>> get friends;
  $R call({List<Friend>? friends});
  FriendsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FriendsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Friends, $Out>
    implements FriendsCopyWith<$R, Friends, $Out> {
  _FriendsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Friends> $mapper =
      FriendsMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Friend, FriendCopyWith<$R, Friend, Friend>> get friends =>
      ListCopyWith($value.friends, (v, t) => v.copyWith.$chain(t),
          (v) => call(friends: v));
  @override
  $R call({List<Friend>? friends}) =>
      $apply(FieldCopyWithData({if (friends != null) #friends: friends}));
  @override
  Friends $make(CopyWithData data) =>
      Friends(friends: data.get(#friends, or: $value.friends));

  @override
  FriendsCopyWith<$R2, Friends, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FriendsCopyWithImpl($value, $cast, t);
}
