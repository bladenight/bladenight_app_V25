// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'friends.dart';

class FriendsMessageMapper extends ClassMapperBase<FriendsMessage> {
  FriendsMessageMapper._();

  static FriendsMessageMapper? _instance;
  static FriendsMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FriendsMessageMapper._());
      FriendMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FriendsMessage';

  static Map<String, FriendMessage> _$friends(FriendsMessage v) => v.friends;
  static const Field<FriendsMessage, Map<String, FriendMessage>> _f$friends =
      Field('friends', _$friends, key: 'fri');
  static Exception? _$exception(FriendsMessage v) => v.exception;
  static const Field<FriendsMessage, Exception> _f$exception =
      Field('exception', _$exception, opt: true);

  @override
  final MappableFields<FriendsMessage> fields = const {
    #friends: _f$friends,
    #exception: _f$exception,
  };

  static FriendsMessage _instantiate(DecodingData data) {
    return FriendsMessage(data.dec(_f$friends), data.dec(_f$exception));
  }

  @override
  final Function instantiate = _instantiate;

  static FriendsMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FriendsMessage>(map);
  }

  static FriendsMessage fromJson(String json) {
    return ensureInitialized().decodeJson<FriendsMessage>(json);
  }
}

mixin FriendsMessageMappable {
  String toJson() {
    return FriendsMessageMapper.ensureInitialized()
        .encodeJson<FriendsMessage>(this as FriendsMessage);
  }

  Map<String, dynamic> toMap() {
    return FriendsMessageMapper.ensureInitialized()
        .encodeMap<FriendsMessage>(this as FriendsMessage);
  }

  FriendsMessageCopyWith<FriendsMessage, FriendsMessage, FriendsMessage>
      get copyWith => _FriendsMessageCopyWithImpl(
          this as FriendsMessage, $identity, $identity);
  @override
  String toString() {
    return FriendsMessageMapper.ensureInitialized()
        .stringifyValue(this as FriendsMessage);
  }

  @override
  bool operator ==(Object other) {
    return FriendsMessageMapper.ensureInitialized()
        .equalsValue(this as FriendsMessage, other);
  }

  @override
  int get hashCode {
    return FriendsMessageMapper.ensureInitialized()
        .hashValue(this as FriendsMessage);
  }
}

extension FriendsMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FriendsMessage, $Out> {
  FriendsMessageCopyWith<$R, FriendsMessage, $Out> get $asFriendsMessage =>
      $base.as((v, t, t2) => _FriendsMessageCopyWithImpl(v, t, t2));
}

abstract class FriendsMessageCopyWith<$R, $In extends FriendsMessage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, FriendMessage,
      FriendMessageCopyWith<$R, FriendMessage, FriendMessage>> get friends;
  $R call({Map<String, FriendMessage>? friends, Exception? exception});
  FriendsMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _FriendsMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FriendsMessage, $Out>
    implements FriendsMessageCopyWith<$R, FriendsMessage, $Out> {
  _FriendsMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FriendsMessage> $mapper =
      FriendsMessageMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, FriendMessage,
          FriendMessageCopyWith<$R, FriendMessage, FriendMessage>>
      get friends => MapCopyWith($value.friends, (v, t) => v.copyWith.$chain(t),
          (v) => call(friends: v));
  @override
  $R call({Map<String, FriendMessage>? friends, Object? exception = $none}) =>
      $apply(FieldCopyWithData({
        if (friends != null) #friends: friends,
        if (exception != $none) #exception: exception
      }));
  @override
  FriendsMessage $make(CopyWithData data) => FriendsMessage(
      data.get(#friends, or: $value.friends),
      data.get(#exception, or: $value.exception));

  @override
  FriendsMessageCopyWith<$R2, FriendsMessage, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _FriendsMessageCopyWithImpl($value, $cast, t);
}
