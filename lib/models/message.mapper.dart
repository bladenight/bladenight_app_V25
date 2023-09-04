// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element

part of 'message.dart';

class MessageMapper extends ClassMapperBase<Message> {
  MessageMapper._();

  static MessageMapper? _instance;
  static MessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageMapper._());
    }
    return _instance!;
  }

  static T _guard<T>(T Function(MapperContainer) fn) {
    ensureInitialized();
    return fn(MapperContainer.globals);
  }

  @override
  final String id = 'Message';

  static String _$uid(Message v) => v.uid;
  static const Field<Message, String> _f$uid = Field('uid', _$uid);
  static String _$title(Message v) => v.title;
  static const Field<Message, String> _f$title =
      Field('title', _$title, key: 'tit');
  static String _$body(Message v) => v.body;
  static const Field<Message, String> _f$body =
      Field('body', _$body, key: 'bod');
  static int _$timeStamp(Message v) => v.timeStamp;
  static const Field<Message, int> _f$timeStamp =
      Field('timeStamp', _$timeStamp, key: 'tim');
  static bool _$read(Message v) => v.read;
  static const Field<Message, bool> _f$read =
      Field('read', _$read, opt: true, def: false);
  static Map<String, dynamic>? _$additionalData(Message v) => v.additionalData;
  static const Field<Message, Map<String, dynamic>> _f$additionalData =
      Field('additionalData', _$additionalData);
  static String? _$url(Message v) => v.url;
  static const Field<Message, String> _f$url = Field('url', _$url);
  static String? _$button1Text(Message v) => v.button1Text;
  static const Field<Message, String> _f$button1Text =
      Field('button1Text', _$button1Text);
  static String? _$button2Text(Message v) => v.button2Text;
  static const Field<Message, String> _f$button2Text =
      Field('button2Text', _$button2Text);
  static String? _$button3Text(Message v) => v.button3Text;
  static const Field<Message, String> _f$button3Text =
      Field('button3Text', _$button3Text);

  @override
  final Map<Symbol, Field<Message, dynamic>> fields = const {
    #uid: _f$uid,
    #title: _f$title,
    #body: _f$body,
    #timeStamp: _f$timeStamp,
    #read: _f$read,
    #additionalData: _f$additionalData,
    #url: _f$url,
    #button1Text: _f$button1Text,
    #button2Text: _f$button2Text,
    #button3Text: _f$button3Text,
  };

  static Message _instantiate(DecodingData data) {
    return Message(
        uid: data.dec(_f$uid),
        title: data.dec(_f$title),
        body: data.dec(_f$body),
        timeStamp: data.dec(_f$timeStamp),
        read: data.dec(_f$read));
  }

  @override
  final Function instantiate = _instantiate;

  static Message fromMap(Map<String, dynamic> map) {
    return _guard((c) => c.fromMap<Message>(map));
  }

  static Message fromJson(String json) {
    return _guard((c) => c.fromJson<Message>(json));
  }
}

mixin MessageMappable {
  String toJson() {
    return MessageMapper._guard((c) => c.toJson(this as Message));
  }

  Map<String, dynamic> toMap() {
    return MessageMapper._guard((c) => c.toMap(this as Message));
  }

  MessageCopyWith<Message, Message, Message> get copyWith =>
      _MessageCopyWithImpl(this as Message, $identity, $identity);
  @override
  String toString() {
    return MessageMapper._guard((c) => c.asString(this));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            MessageMapper._guard((c) => c.isEqual(this, other)));
  }

  @override
  int get hashCode {
    return MessageMapper._guard((c) => c.hash(this));
  }
}

extension MessageValueCopy<$R, $Out> on ObjectCopyWith<$R, Message, $Out> {
  MessageCopyWith<$R, Message, $Out> get $asMessage =>
      $base.as((v, t, t2) => _MessageCopyWithImpl(v, t, t2));
}

abstract class MessageCopyWith<$R, $In extends Message, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? uid, String? title, String? body, int? timeStamp, bool? read});
  MessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Message, $Out>
    implements MessageCopyWith<$R, Message, $Out> {
  _MessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Message> $mapper =
      MessageMapper.ensureInitialized();
  @override
  $R call(
          {String? uid,
          String? title,
          String? body,
          int? timeStamp,
          bool? read}) =>
      $apply(FieldCopyWithData({
        if (uid != null) #uid: uid,
        if (title != null) #title: title,
        if (body != null) #body: body,
        if (timeStamp != null) #timeStamp: timeStamp,
        if (read != null) #read: read
      }));
  @override
  Message $make(CopyWithData data) => Message(
      uid: data.get(#uid, or: $value.uid),
      title: data.get(#title, or: $value.title),
      body: data.get(#body, or: $value.body),
      timeStamp: data.get(#timeStamp, or: $value.timeStamp),
      read: data.get(#read, or: $value.read));

  @override
  MessageCopyWith<$R2, Message, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MessageCopyWithImpl($value, $cast, t);
}
