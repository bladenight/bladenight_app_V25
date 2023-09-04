import 'package:dart_mappable/dart_mappable.dart';

import 'message.dart';

part 'messages.mapper.dart';

@MappableClass()
class Messages with MessagesMappable {
  final List<Message> messages;

  Messages({required this.messages});

  static bool messageExists(Messages messages, Message message) {
    for (var message in messages.messages) {
      if (message.uid.compareTo(message.uid) == 0) {
        return true;
      }
    }
    return false;
  }

  static bool messageExistsInList(
      List<Message> messagesList, String messageName) {
    for (var element in messagesList) {
      if (element.uid.compareTo(messageName.toLowerCase()) == 0) {
        return true;
      }
    }
    return false;
  }
}
