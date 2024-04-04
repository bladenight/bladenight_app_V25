import 'package:dart_mappable/dart_mappable.dart';

part 'external_app_message.mapper.dart';

@MappableClass()
class ExternalAppMessage with ExternalAppMessageMappable {
  @MappableField(key: 'uid')
  final String uid;

  ///lastChange
  @MappableField(key: 'lch')
  final int lastChange;
  @MappableField(key: 'tim')
  final int timeStamp;
  @MappableField(key: 'title')
  final String title;
  @MappableField(key: 'bod')
  final String body;

  ///groupID
  @MappableField(key: 'gid')
  String? groupId;
  @MappableField(key: 'msgRead')
  bool read;
  @MappableField(key: 'del')
  bool deleted;
  @MappableField(key: 'validTo')
  int? validToTimeStamp;
  @MappableField(key: 'add')
  Map<String, dynamic>? additionalData;
  @MappableField(key: 'url')
  String? url;
  @MappableField(key: 'bt1')
  String? button1Text;
  @MappableField(key: 'bt2')
  String? button2Text;
  @MappableField(key: 'bt3')
  String? button3Text;
  @MappableField(key: 'btl1')
  String? button1Link;
  @MappableField(key: 'btl2')
  String? button2Link;
  @MappableField(key: 'btl3')
  String? button3Link;

  ExternalAppMessage(
      {required this.uid,
      required this.title,
      required this.body,
      required this.timeStamp,
      required this.lastChange,
      this.deleted = false,
      this.read = false,
      this.url,
      this.additionalData,
      this.button1Text,
      this.button2Text,
      this.button3Text,
      this.button1Link,
      this.button2Link,
      this.button3Link,
      this.groupId,
      this.validToTimeStamp});

  DateTime get getUtcIso8601DateTime {
    var dt = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    return DateTime.parse(dt.toIso8601String());
  }
}

/*
{
  "uid": "uuid-687687857688-fhgjtfjtz-67687345dfgh",
  "tit": "title",
  "bod": "body",
  "read":"false",
  "tim": "123456789",
  "additionalData":{"1st":"1st"},
  "url":"url",
  "bt1":"btn1",
  "bt2":"btn2",
  "bt3":"btn3"
}
 */
