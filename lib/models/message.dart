import 'package:dart_mappable/dart_mappable.dart';

part 'message.mapper.dart';

@MappableClass()
class Message with MessageMappable {
  @MappableField(key: 'uid')
  final String uid;
  @MappableField(key: 'tit')
  final String title;
  @MappableField(key: 'bod')
  final String body;
  @MappableField(key: 'read')
  bool read;
  @MappableField(key: 'tim')
  final int timeStamp;
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

  Message(
      {
      required this.uid,
      required this.title,
      required this.body,
      required this.timeStamp,
      this.read = false});
}
