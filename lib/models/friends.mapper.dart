// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element

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

  static T _guard<T>(T Function(MapperContainer) fn) {
    ensureInitialized();
    return fn(MapperContainer.globals);
  }

  @override
  final String id = 'Friends';

  static List<Friend> _$friends(Friends v) => v.friends;
  static const Field<Friends, List<Friend>> _f$friends =
      Field('friends', _$friends);

  @override
  final Map<Symbol, Field<Friends, dynamic>> fields = const {
    #friends: _f$friends,
  };

  static Friends _instantiate(DecodingData data) {
    return Friends(friends: data.dec(_f$friends));
  }

  @override
  final Function instantiate = _instantiate;

  static Friends fromMap(Map<String, dynamic> map) {
    return _guard((c) => c.fromMap<Friends>(map));
  }

  static Friends fromJson(String json) {
    return _guard((c) => c.fromJson<Friends>(json));
  }
}

mixin FriendsMappable {
  String toJson() {
    return FriendsMapper._guard((c) => c.toJson(this as Friends));
  }

  Map<String, dynamic> toMap() {
    return FriendsMapper._guard((c) => c.toMap(this as Friends));
  }

  FriendsCopyWith<Friends, Friends, Friends> get copyWith =>
      _FriendsCopyWithImpl(this as Friends, $identity, $identity);
  @override
  String toString() {
    return FriendsMapper._guard((c) => c.asString(this));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            FriendsMapper._guard((c) => c.isEqual(this, other)));
  }

  @override
  int get hashCode {
    return FriendsMapper._guard((c) => c.hash(this));
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
