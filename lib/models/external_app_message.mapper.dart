// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'external_app_message.dart';

class ExternalAppMessageMapper extends ClassMapperBase<ExternalAppMessage> {
  ExternalAppMessageMapper._();

  static ExternalAppMessageMapper? _instance;
  static ExternalAppMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExternalAppMessageMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ExternalAppMessage';

  static String _$uid(ExternalAppMessage v) => v.uid;
  static const Field<ExternalAppMessage, String> _f$uid = Field('uid', _$uid);
  static String _$title(ExternalAppMessage v) => v.title;
  static const Field<ExternalAppMessage, String> _f$title =
      Field('title', _$title);
  static String _$body(ExternalAppMessage v) => v.body;
  static const Field<ExternalAppMessage, String> _f$body =
      Field('body', _$body, key: r'bod');
  static int _$timeStamp(ExternalAppMessage v) => v.timeStamp;
  static const Field<ExternalAppMessage, int> _f$timeStamp =
      Field('timeStamp', _$timeStamp, key: r'tim');
  static int _$lastChange(ExternalAppMessage v) => v.lastChange;
  static const Field<ExternalAppMessage, int> _f$lastChange =
      Field('lastChange', _$lastChange, key: r'lch');
  static bool _$deleted(ExternalAppMessage v) => v.deleted;
  static const Field<ExternalAppMessage, bool> _f$deleted =
      Field('deleted', _$deleted, key: r'del', opt: true, def: false);
  static bool _$read(ExternalAppMessage v) => v.read;
  static const Field<ExternalAppMessage, bool> _f$read =
      Field('read', _$read, key: r'msgRead', opt: true, def: false);
  static String? _$url(ExternalAppMessage v) => v.url;
  static const Field<ExternalAppMessage, String> _f$url =
      Field('url', _$url, opt: true);
  static Map<String, dynamic>? _$additionalData(ExternalAppMessage v) =>
      v.additionalData;
  static const Field<ExternalAppMessage, Map<String, dynamic>>
      _f$additionalData =
      Field('additionalData', _$additionalData, key: r'add', opt: true);
  static String? _$button1Text(ExternalAppMessage v) => v.button1Text;
  static const Field<ExternalAppMessage, String> _f$button1Text =
      Field('button1Text', _$button1Text, key: r'bt1', opt: true);
  static String? _$button2Text(ExternalAppMessage v) => v.button2Text;
  static const Field<ExternalAppMessage, String> _f$button2Text =
      Field('button2Text', _$button2Text, key: r'bt2', opt: true);
  static String? _$button3Text(ExternalAppMessage v) => v.button3Text;
  static const Field<ExternalAppMessage, String> _f$button3Text =
      Field('button3Text', _$button3Text, key: r'bt3', opt: true);
  static String? _$button1Link(ExternalAppMessage v) => v.button1Link;
  static const Field<ExternalAppMessage, String> _f$button1Link =
      Field('button1Link', _$button1Link, key: r'btl1', opt: true);
  static String? _$button2Link(ExternalAppMessage v) => v.button2Link;
  static const Field<ExternalAppMessage, String> _f$button2Link =
      Field('button2Link', _$button2Link, key: r'btl2', opt: true);
  static String? _$button3Link(ExternalAppMessage v) => v.button3Link;
  static const Field<ExternalAppMessage, String> _f$button3Link =
      Field('button3Link', _$button3Link, key: r'btl3', opt: true);
  static String? _$groupId(ExternalAppMessage v) => v.groupId;
  static const Field<ExternalAppMessage, String> _f$groupId =
      Field('groupId', _$groupId, key: r'gid', opt: true);
  static int? _$validToTimeStamp(ExternalAppMessage v) => v.validToTimeStamp;
  static const Field<ExternalAppMessage, int> _f$validToTimeStamp =
      Field('validToTimeStamp', _$validToTimeStamp, key: r'validTo', opt: true);

  @override
  final MappableFields<ExternalAppMessage> fields = const {
    #uid: _f$uid,
    #title: _f$title,
    #body: _f$body,
    #timeStamp: _f$timeStamp,
    #lastChange: _f$lastChange,
    #deleted: _f$deleted,
    #read: _f$read,
    #url: _f$url,
    #additionalData: _f$additionalData,
    #button1Text: _f$button1Text,
    #button2Text: _f$button2Text,
    #button3Text: _f$button3Text,
    #button1Link: _f$button1Link,
    #button2Link: _f$button2Link,
    #button3Link: _f$button3Link,
    #groupId: _f$groupId,
    #validToTimeStamp: _f$validToTimeStamp,
  };

  static ExternalAppMessage _instantiate(DecodingData data) {
    return ExternalAppMessage(
        uid: data.dec(_f$uid),
        title: data.dec(_f$title),
        body: data.dec(_f$body),
        timeStamp: data.dec(_f$timeStamp),
        lastChange: data.dec(_f$lastChange),
        deleted: data.dec(_f$deleted),
        read: data.dec(_f$read),
        url: data.dec(_f$url),
        additionalData: data.dec(_f$additionalData),
        button1Text: data.dec(_f$button1Text),
        button2Text: data.dec(_f$button2Text),
        button3Text: data.dec(_f$button3Text),
        button1Link: data.dec(_f$button1Link),
        button2Link: data.dec(_f$button2Link),
        button3Link: data.dec(_f$button3Link),
        groupId: data.dec(_f$groupId),
        validToTimeStamp: data.dec(_f$validToTimeStamp));
  }

  @override
  final Function instantiate = _instantiate;

  static ExternalAppMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExternalAppMessage>(map);
  }

  static ExternalAppMessage fromJson(String json) {
    return ensureInitialized().decodeJson<ExternalAppMessage>(json);
  }
}

mixin ExternalAppMessageMappable {
  String toJson() {
    return ExternalAppMessageMapper.ensureInitialized()
        .encodeJson<ExternalAppMessage>(this as ExternalAppMessage);
  }

  Map<String, dynamic> toMap() {
    return ExternalAppMessageMapper.ensureInitialized()
        .encodeMap<ExternalAppMessage>(this as ExternalAppMessage);
  }

  ExternalAppMessageCopyWith<ExternalAppMessage, ExternalAppMessage,
          ExternalAppMessage>
      get copyWith => _ExternalAppMessageCopyWithImpl<ExternalAppMessage,
          ExternalAppMessage>(this as ExternalAppMessage, $identity, $identity);
  @override
  String toString() {
    return ExternalAppMessageMapper.ensureInitialized()
        .stringifyValue(this as ExternalAppMessage);
  }

  @override
  bool operator ==(Object other) {
    return ExternalAppMessageMapper.ensureInitialized()
        .equalsValue(this as ExternalAppMessage, other);
  }

  @override
  int get hashCode {
    return ExternalAppMessageMapper.ensureInitialized()
        .hashValue(this as ExternalAppMessage);
  }
}

extension ExternalAppMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExternalAppMessage, $Out> {
  ExternalAppMessageCopyWith<$R, ExternalAppMessage, $Out>
      get $asExternalAppMessage => $base.as(
          (v, t, t2) => _ExternalAppMessageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ExternalAppMessageCopyWith<$R, $In extends ExternalAppMessage,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
      get additionalData;
  $R call(
      {String? uid,
      String? title,
      String? body,
      int? timeStamp,
      int? lastChange,
      bool? deleted,
      bool? read,
      String? url,
      Map<String, dynamic>? additionalData,
      String? button1Text,
      String? button2Text,
      String? button3Text,
      String? button1Link,
      String? button2Link,
      String? button3Link,
      String? groupId,
      int? validToTimeStamp});
  ExternalAppMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _ExternalAppMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExternalAppMessage, $Out>
    implements ExternalAppMessageCopyWith<$R, ExternalAppMessage, $Out> {
  _ExternalAppMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExternalAppMessage> $mapper =
      ExternalAppMessageMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
      get additionalData => $value.additionalData != null
          ? MapCopyWith(
              $value.additionalData!,
              (v, t) => ObjectCopyWith(v, $identity, t),
              (v) => call(additionalData: v))
          : null;
  @override
  $R call(
          {String? uid,
          String? title,
          String? body,
          int? timeStamp,
          int? lastChange,
          bool? deleted,
          bool? read,
          Object? url = $none,
          Object? additionalData = $none,
          Object? button1Text = $none,
          Object? button2Text = $none,
          Object? button3Text = $none,
          Object? button1Link = $none,
          Object? button2Link = $none,
          Object? button3Link = $none,
          Object? groupId = $none,
          Object? validToTimeStamp = $none}) =>
      $apply(FieldCopyWithData({
        if (uid != null) #uid: uid,
        if (title != null) #title: title,
        if (body != null) #body: body,
        if (timeStamp != null) #timeStamp: timeStamp,
        if (lastChange != null) #lastChange: lastChange,
        if (deleted != null) #deleted: deleted,
        if (read != null) #read: read,
        if (url != $none) #url: url,
        if (additionalData != $none) #additionalData: additionalData,
        if (button1Text != $none) #button1Text: button1Text,
        if (button2Text != $none) #button2Text: button2Text,
        if (button3Text != $none) #button3Text: button3Text,
        if (button1Link != $none) #button1Link: button1Link,
        if (button2Link != $none) #button2Link: button2Link,
        if (button3Link != $none) #button3Link: button3Link,
        if (groupId != $none) #groupId: groupId,
        if (validToTimeStamp != $none) #validToTimeStamp: validToTimeStamp
      }));
  @override
  ExternalAppMessage $make(CopyWithData data) => ExternalAppMessage(
      uid: data.get(#uid, or: $value.uid),
      title: data.get(#title, or: $value.title),
      body: data.get(#body, or: $value.body),
      timeStamp: data.get(#timeStamp, or: $value.timeStamp),
      lastChange: data.get(#lastChange, or: $value.lastChange),
      deleted: data.get(#deleted, or: $value.deleted),
      read: data.get(#read, or: $value.read),
      url: data.get(#url, or: $value.url),
      additionalData: data.get(#additionalData, or: $value.additionalData),
      button1Text: data.get(#button1Text, or: $value.button1Text),
      button2Text: data.get(#button2Text, or: $value.button2Text),
      button3Text: data.get(#button3Text, or: $value.button3Text),
      button1Link: data.get(#button1Link, or: $value.button1Link),
      button2Link: data.get(#button2Link, or: $value.button2Link),
      button3Link: data.get(#button3Link, or: $value.button3Link),
      groupId: data.get(#groupId, or: $value.groupId),
      validToTimeStamp:
          data.get(#validToTimeStamp, or: $value.validToTimeStamp));

  @override
  ExternalAppMessageCopyWith<$R2, ExternalAppMessage, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ExternalAppMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
