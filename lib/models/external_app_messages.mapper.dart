// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'external_app_messages.dart';

class ExternalAppMessagesMapper extends ClassMapperBase<ExternalAppMessages> {
  ExternalAppMessagesMapper._();

  static ExternalAppMessagesMapper? _instance;
  static ExternalAppMessagesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExternalAppMessagesMapper._());
      ExternalAppMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExternalAppMessages';

  static List<ExternalAppMessage> _$messages(ExternalAppMessages v) =>
      v.messages;
  static const Field<ExternalAppMessages, List<ExternalAppMessage>>
      _f$messages = Field('messages', _$messages);

  @override
  final MappableFields<ExternalAppMessages> fields = const {
    #messages: _f$messages,
  };

  static ExternalAppMessages _instantiate(DecodingData data) {
    return ExternalAppMessages(messages: data.dec(_f$messages));
  }

  @override
  final Function instantiate = _instantiate;

  static ExternalAppMessages fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExternalAppMessages>(map);
  }

  static ExternalAppMessages fromJson(String json) {
    return ensureInitialized().decodeJson<ExternalAppMessages>(json);
  }
}

mixin ExternalAppMessagesMappable {
  String toJson() {
    return ExternalAppMessagesMapper.ensureInitialized()
        .encodeJson<ExternalAppMessages>(this as ExternalAppMessages);
  }

  Map<String, dynamic> toMap() {
    return ExternalAppMessagesMapper.ensureInitialized()
        .encodeMap<ExternalAppMessages>(this as ExternalAppMessages);
  }

  ExternalAppMessagesCopyWith<ExternalAppMessages, ExternalAppMessages,
      ExternalAppMessages> get copyWith => _ExternalAppMessagesCopyWithImpl<
          ExternalAppMessages, ExternalAppMessages>(
      this as ExternalAppMessages, $identity, $identity);
  @override
  String toString() {
    return ExternalAppMessagesMapper.ensureInitialized()
        .stringifyValue(this as ExternalAppMessages);
  }

  @override
  bool operator ==(Object other) {
    return ExternalAppMessagesMapper.ensureInitialized()
        .equalsValue(this as ExternalAppMessages, other);
  }

  @override
  int get hashCode {
    return ExternalAppMessagesMapper.ensureInitialized()
        .hashValue(this as ExternalAppMessages);
  }
}

extension ExternalAppMessagesValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExternalAppMessages, $Out> {
  ExternalAppMessagesCopyWith<$R, ExternalAppMessages, $Out>
      get $asExternalAppMessages => $base.as(
          (v, t, t2) => _ExternalAppMessagesCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ExternalAppMessagesCopyWith<$R, $In extends ExternalAppMessages,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
      $R,
      ExternalAppMessage,
      ExternalAppMessageCopyWith<$R, ExternalAppMessage,
          ExternalAppMessage>> get messages;
  $R call({List<ExternalAppMessage>? messages});
  ExternalAppMessagesCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _ExternalAppMessagesCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExternalAppMessages, $Out>
    implements ExternalAppMessagesCopyWith<$R, ExternalAppMessages, $Out> {
  _ExternalAppMessagesCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExternalAppMessages> $mapper =
      ExternalAppMessagesMapper.ensureInitialized();
  @override
  ListCopyWith<
      $R,
      ExternalAppMessage,
      ExternalAppMessageCopyWith<$R, ExternalAppMessage,
          ExternalAppMessage>> get messages => ListCopyWith($value.messages,
      (v, t) => v.copyWith.$chain(t), (v) => call(messages: v));
  @override
  $R call({List<ExternalAppMessage>? messages}) =>
      $apply(FieldCopyWithData({if (messages != null) #messages: messages}));
  @override
  ExternalAppMessages $make(CopyWithData data) =>
      ExternalAppMessages(messages: data.get(#messages, or: $value.messages));

  @override
  ExternalAppMessagesCopyWith<$R2, ExternalAppMessages, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _ExternalAppMessagesCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
