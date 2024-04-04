import 'package:dart_mappable/dart_mappable.dart';

import 'external_app_message.dart';

part 'external_app_messages.mapper.dart';

@MappableClass()
class ExternalAppMessages with ExternalAppMessagesMappable {
  //@MappableField(key: 'messages')
  final List<ExternalAppMessage> messages;

  ExternalAppMessages({required this.messages});

  static bool messageExists(ExternalAppMessages messages, ExternalAppMessage message) {
    for (var message in messages.messages) {
      if (message.uid.compareTo(message.uid) == 0) {
        return true;
      }
    }
    return false;
  }

  static bool messageExistsInList(
      List<ExternalAppMessage> messagesList, String messageName) {
    for (var element in messagesList) {
      if (element.uid.compareTo(messageName.toLowerCase()) == 0) {
        return true;
      }
    }
    return false;
  }
}
