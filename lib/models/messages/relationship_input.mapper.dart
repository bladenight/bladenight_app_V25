// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element

part of 'relationship_input.dart';

class RelationshipInputMessageMapper
    extends ClassMapperBase<RelationshipInputMessage> {
  RelationshipInputMessageMapper._();

  static RelationshipInputMessageMapper? _instance;
  static RelationshipInputMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = RelationshipInputMessageMapper._());
      GetFriendsListMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  static T _guard<T>(T Function(MapperContainer) fn) {
    ensureInitialized();
    return fn(MapperContainer.globals);
  }

  @override
  final String id = 'RelationshipInputMessage';

  static String _$deviceId(RelationshipInputMessage v) => v.deviceId;
  static const Field<RelationshipInputMessage, String> _f$deviceId =
      Field('deviceId', _$deviceId, key: 'did');
  static int _$friendId(RelationshipInputMessage v) => v.friendId;
  static const Field<RelationshipInputMessage, int> _f$friendId =
      Field('friendId', _$friendId, key: 'fid');
  static int _$requestId(RelationshipInputMessage v) => v.requestId;
  static const Field<RelationshipInputMessage, int> _f$requestId =
      Field('requestId', _$requestId, key: 'req');

  @override
  final Map<Symbol, Field<RelationshipInputMessage, dynamic>> fields = const {
    #deviceId: _f$deviceId,
    #friendId: _f$friendId,
    #requestId: _f$requestId,
  };

  static RelationshipInputMessage _instantiate(DecodingData data) {
    return RelationshipInputMessage(
        deviceId: data.dec(_f$deviceId),
        friendId: data.dec(_f$friendId),
        requestId: data.dec(_f$requestId));
  }

  @override
  final Function instantiate = _instantiate;

  static RelationshipInputMessage fromMap(Map<String, dynamic> map) {
    return _guard((c) => c.fromMap<RelationshipInputMessage>(map));
  }

  static RelationshipInputMessage fromJson(String json) {
    return _guard((c) => c.fromJson<RelationshipInputMessage>(json));
  }
}

mixin RelationshipInputMessageMappable {
  String toJson() {
    return RelationshipInputMessageMapper._guard(
        (c) => c.toJson(this as RelationshipInputMessage));
  }

  Map<String, dynamic> toMap() {
    return RelationshipInputMessageMapper._guard(
        (c) => c.toMap(this as RelationshipInputMessage));
  }

  RelationshipInputMessageCopyWith<RelationshipInputMessage,
          RelationshipInputMessage, RelationshipInputMessage>
      get copyWith => _RelationshipInputMessageCopyWithImpl(
          this as RelationshipInputMessage, $identity, $identity);
  @override
  String toString() {
    return RelationshipInputMessageMapper._guard((c) => c.asString(this));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            RelationshipInputMessageMapper._guard(
                (c) => c.isEqual(this, other)));
  }

  @override
  int get hashCode {
    return RelationshipInputMessageMapper._guard((c) => c.hash(this));
  }
}

extension RelationshipInputMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RelationshipInputMessage, $Out> {
  RelationshipInputMessageCopyWith<$R, RelationshipInputMessage, $Out>
      get $asRelationshipInputMessage => $base
          .as((v, t, t2) => _RelationshipInputMessageCopyWithImpl(v, t, t2));
}

abstract class RelationshipInputMessageCopyWith<
    $R,
    $In extends RelationshipInputMessage,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? deviceId, int? friendId, int? requestId});
  RelationshipInputMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _RelationshipInputMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RelationshipInputMessage, $Out>
    implements
        RelationshipInputMessageCopyWith<$R, RelationshipInputMessage, $Out> {
  _RelationshipInputMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RelationshipInputMessage> $mapper =
      RelationshipInputMessageMapper.ensureInitialized();
  @override
  $R call({String? deviceId, int? friendId, int? requestId}) =>
      $apply(FieldCopyWithData({
        if (deviceId != null) #deviceId: deviceId,
        if (friendId != null) #friendId: friendId,
        if (requestId != null) #requestId: requestId
      }));
  @override
  RelationshipInputMessage $make(CopyWithData data) => RelationshipInputMessage(
      deviceId: data.get(#deviceId, or: $value.deviceId),
      friendId: data.get(#friendId, or: $value.friendId),
      requestId: data.get(#requestId, or: $value.requestId));

  @override
  RelationshipInputMessageCopyWith<$R2, RelationshipInputMessage, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _RelationshipInputMessageCopyWithImpl($value, $cast, t);
}

class GetFriendsListMessageMapper
    extends ClassMapperBase<GetFriendsListMessage> {
  GetFriendsListMessageMapper._();

  static GetFriendsListMessageMapper? _instance;
  static GetFriendsListMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GetFriendsListMessageMapper._());
      RelationshipInputMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  static T _guard<T>(T Function(MapperContainer) fn) {
    ensureInitialized();
    return fn(MapperContainer.globals);
  }

  @override
  final String id = 'GetFriendsListMessage';

  static String _$deviceId(GetFriendsListMessage v) => v.deviceId;
  static const Field<GetFriendsListMessage, String> _f$deviceId =
      Field('deviceId', _$deviceId, key: 'did');
  static int _$friendId(GetFriendsListMessage v) => v.friendId;
  static const Field<GetFriendsListMessage, int> _f$friendId =
      Field('friendId', _$friendId, key: 'fid');
  static int _$requestId(GetFriendsListMessage v) => v.requestId;
  static const Field<GetFriendsListMessage, int> _f$requestId =
      Field('requestId', _$requestId, key: 'req');

  @override
  final Map<Symbol, Field<GetFriendsListMessage, dynamic>> fields = const {
    #deviceId: _f$deviceId,
    #friendId: _f$friendId,
    #requestId: _f$requestId,
  };

  static GetFriendsListMessage _instantiate(DecodingData data) {
    return GetFriendsListMessage(
        deviceid: data.dec(_f$deviceId),
        friendid: data.dec(_f$friendId),
        requestid: data.dec(_f$requestId));
  }

  @override
  final Function instantiate = _instantiate;

  static GetFriendsListMessage fromMap(Map<String, dynamic> map) {
    return _guard((c) => c.fromMap<GetFriendsListMessage>(map));
  }

  static GetFriendsListMessage fromJson(String json) {
    return _guard((c) => c.fromJson<GetFriendsListMessage>(json));
  }
}

mixin GetFriendsListMessageMappable {
  String toJson() {
    return GetFriendsListMessageMapper._guard(
        (c) => c.toJson(this as GetFriendsListMessage));
  }

  Map<String, dynamic> toMap() {
    return GetFriendsListMessageMapper._guard(
        (c) => c.toMap(this as GetFriendsListMessage));
  }

  GetFriendsListMessageCopyWith<GetFriendsListMessage, GetFriendsListMessage,
          GetFriendsListMessage>
      get copyWith => _GetFriendsListMessageCopyWithImpl(
          this as GetFriendsListMessage, $identity, $identity);
  @override
  String toString() {
    return GetFriendsListMessageMapper._guard((c) => c.asString(this));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            GetFriendsListMessageMapper._guard((c) => c.isEqual(this, other)));
  }

  @override
  int get hashCode {
    return GetFriendsListMessageMapper._guard((c) => c.hash(this));
  }
}

extension GetFriendsListMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, GetFriendsListMessage, $Out> {
  GetFriendsListMessageCopyWith<$R, GetFriendsListMessage, $Out>
      get $asGetFriendsListMessage =>
          $base.as((v, t, t2) => _GetFriendsListMessageCopyWithImpl(v, t, t2));
}

abstract class GetFriendsListMessageCopyWith<
    $R,
    $In extends GetFriendsListMessage,
    $Out> implements RelationshipInputMessageCopyWith<$R, $In, $Out> {
  @override
  $R call({String? deviceId, int? friendId, int? requestId});
  GetFriendsListMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _GetFriendsListMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, GetFriendsListMessage, $Out>
    implements GetFriendsListMessageCopyWith<$R, GetFriendsListMessage, $Out> {
  _GetFriendsListMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<GetFriendsListMessage> $mapper =
      GetFriendsListMessageMapper.ensureInitialized();
  @override
  $R call({String? deviceId, int? friendId, int? requestId}) =>
      $apply(FieldCopyWithData({
        if (deviceId != null) #deviceId: deviceId,
        if (friendId != null) #friendId: friendId,
        if (requestId != null) #requestId: requestId
      }));
  @override
  GetFriendsListMessage $make(CopyWithData data) => GetFriendsListMessage(
      deviceid: data.get(#deviceId, or: $value.deviceId),
      friendid: data.get(#friendId, or: $value.friendId),
      requestid: data.get(#requestId, or: $value.requestId));

  @override
  GetFriendsListMessageCopyWith<$R2, GetFriendsListMessage, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _GetFriendsListMessageCopyWithImpl($value, $cast, t);
}
