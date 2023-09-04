// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element

part of 'messages.dart';

class MessagesMapper extends ClassMapperBase<Messages> {
  MessagesMapper._();

  static MessagesMapper? _instance;
  static MessagesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessagesMapper._());
      MessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  static T _guard<T>(T Function(MapperContainer) fn) {
    ensureInitialized();
    return fn(MapperContainer.globals);
  }

  @override
  final String id = 'Messages';

  static List<Message> _$messages(Messages v) => v.messages;
  static const Field<Messages, List<Message>> _f$messages =
      Field('messages', _$messages);

  @override
  final Map<Symbol, Field<Messages, dynamic>> fields = const {
    #messages: _f$messages,
  };

  static Messages _instantiate(DecodingData data) {
    return Messages(messages: data.dec(_f$messages));
  }

  @override
  final Function instantiate = _instantiate;

  static Messages fromMap(Map<String, dynamic> map) {
    return _guard((c) => c.fromMap<Messages>(map));
  }

  static Messages fromJson(String json) {
    return _guard((c) => c.fromJson<Messages>(json));
  }
}

mixin MessagesMappable {
  String toJson() {
    return MessagesMapper._guard((c) => c.toJson(this as Messages));
  }

  Map<String, dynamic> toMap() {
    return MessagesMapper._guard((c) => c.toMap(this as Messages));
  }

  MessagesCopyWith<Messages, Messages, Messages> get copyWith =>
      _MessagesCopyWithImpl(this as Messages, $identity, $identity);
  @override
  String toString() {
    return MessagesMapper._guard((c) => c.asString(this));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            MessagesMapper._guard((c) => c.isEqual(this, other)));
  }

  @override
  int get hashCode {
    return MessagesMapper._guard((c) => c.hash(this));
  }
}

extension MessagesValueCopy<$R, $Out> on ObjectCopyWith<$R, Messages, $Out> {
  MessagesCopyWith<$R, Messages, $Out> get $asMessages =>
      $base.as((v, t, t2) => _MessagesCopyWithImpl(v, t, t2));
}

abstract class MessagesCopyWith<$R, $In extends Messages, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Message, MessageCopyWith<$R, Message, Message>> get messages;
  $R call({List<Message>? messages});
  MessagesCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MessagesCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Messages, $Out>
    implements MessagesCopyWith<$R, Messages, $Out> {
  _MessagesCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Messages> $mapper =
      MessagesMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Message, MessageCopyWith<$R, Message, Message>>
      get messages => ListCopyWith($value.messages,
          (v, t) => v.copyWith.$chain(t), (v) => call(messages: v));
  @override
  $R call({List<Message>? messages}) =>
      $apply(FieldCopyWithData({if (messages != null) #messages: messages}));
  @override
  Messages $make(CopyWithData data) =>
      Messages(messages: data.get(#messages, or: $value.messages));

  @override
  MessagesCopyWith<$R2, Messages, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MessagesCopyWithImpl($value, $cast, t);
}
