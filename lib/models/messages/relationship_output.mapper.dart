// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'relationship_output.dart';

class RelationshipOutputMessageMapper
    extends ClassMapperBase<RelationshipOutputMessage> {
  RelationshipOutputMessageMapper._();

  static RelationshipOutputMessageMapper? _instance;
  static RelationshipOutputMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = RelationshipOutputMessageMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RelationshipOutputMessage';

  static int _$friendId(RelationshipOutputMessage v) => v.friendId;
  static const Field<RelationshipOutputMessage, int> _f$friendId =
      Field('friendId', _$friendId, key: r'fid');
  static int _$requestId(RelationshipOutputMessage v) => v.requestId;
  static const Field<RelationshipOutputMessage, int> _f$requestId =
      Field('requestId', _$requestId, key: r'rid');
  static Exception? _$rpcException(RelationshipOutputMessage v) =>
      v.rpcException;
  static const Field<RelationshipOutputMessage, Exception> _f$rpcException =
      Field('rpcException', _$rpcException, opt: true);

  @override
  final MappableFields<RelationshipOutputMessage> fields = const {
    #friendId: _f$friendId,
    #requestId: _f$requestId,
    #rpcException: _f$rpcException,
  };

  static RelationshipOutputMessage _instantiate(DecodingData data) {
    return RelationshipOutputMessage(
        friendId: data.dec(_f$friendId),
        requestId: data.dec(_f$requestId),
        rpcException: data.dec(_f$rpcException));
  }

  @override
  final Function instantiate = _instantiate;

  static RelationshipOutputMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RelationshipOutputMessage>(map);
  }

  static RelationshipOutputMessage fromJson(String json) {
    return ensureInitialized().decodeJson<RelationshipOutputMessage>(json);
  }
}

mixin RelationshipOutputMessageMappable {
  String toJson() {
    return RelationshipOutputMessageMapper.ensureInitialized()
        .encodeJson<RelationshipOutputMessage>(
            this as RelationshipOutputMessage);
  }

  Map<String, dynamic> toMap() {
    return RelationshipOutputMessageMapper.ensureInitialized()
        .encodeMap<RelationshipOutputMessage>(
            this as RelationshipOutputMessage);
  }

  RelationshipOutputMessageCopyWith<RelationshipOutputMessage,
          RelationshipOutputMessage, RelationshipOutputMessage>
      get copyWith => _RelationshipOutputMessageCopyWithImpl(
          this as RelationshipOutputMessage, $identity, $identity);
  @override
  String toString() {
    return RelationshipOutputMessageMapper.ensureInitialized()
        .stringifyValue(this as RelationshipOutputMessage);
  }

  @override
  bool operator ==(Object other) {
    return RelationshipOutputMessageMapper.ensureInitialized()
        .equalsValue(this as RelationshipOutputMessage, other);
  }

  @override
  int get hashCode {
    return RelationshipOutputMessageMapper.ensureInitialized()
        .hashValue(this as RelationshipOutputMessage);
  }
}

extension RelationshipOutputMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RelationshipOutputMessage, $Out> {
  RelationshipOutputMessageCopyWith<$R, RelationshipOutputMessage, $Out>
      get $asRelationshipOutputMessage => $base
          .as((v, t, t2) => _RelationshipOutputMessageCopyWithImpl(v, t, t2));
}

abstract class RelationshipOutputMessageCopyWith<
    $R,
    $In extends RelationshipOutputMessage,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? friendId, int? requestId, Exception? rpcException});
  RelationshipOutputMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _RelationshipOutputMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RelationshipOutputMessage, $Out>
    implements
        RelationshipOutputMessageCopyWith<$R, RelationshipOutputMessage, $Out> {
  _RelationshipOutputMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RelationshipOutputMessage> $mapper =
      RelationshipOutputMessageMapper.ensureInitialized();
  @override
  $R call({int? friendId, int? requestId, Object? rpcException = $none}) =>
      $apply(FieldCopyWithData({
        if (friendId != null) #friendId: friendId,
        if (requestId != null) #requestId: requestId,
        if (rpcException != $none) #rpcException: rpcException
      }));
  @override
  RelationshipOutputMessage $make(CopyWithData data) =>
      RelationshipOutputMessage(
          friendId: data.get(#friendId, or: $value.friendId),
          requestId: data.get(#requestId, or: $value.requestId),
          rpcException: data.get(#rpcException, or: $value.rpcException));

  @override
  RelationshipOutputMessageCopyWith<$R2, RelationshipOutputMessage, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _RelationshipOutputMessageCopyWithImpl($value, $cast, t);
}
