import 'package:bladenight_app_flutter/helpers/hive_box/messages_db.dart';
import 'package:bladenight_app_flutter/helpers/uuid_helper.dart';
import 'package:bladenight_app_flutter/models/external_app_message.dart';

class MessageTest {
  void main() async {
    var messages =await MessagesDb.messagesList;
    var len = messages.length;
    MessagesDb.addMessage(ExternalAppMessage(
        uid: UUID.createUuid(),
        body:
        'huiahusdauhushdfoiehrwfuidsahöfaisjdfapoiöhgsfögniisdhgiojfgoöfsdijgofisdhg  njfjiisdfhgsifhgusdhfgiulsdhfsghdfguihsdfguihusdfhusdföjirsjfgiöofgjnsifdngisjfkjfiajfiöosjsdlh',
        title: 'Title00${UUID.createUuid()}',
        timeStamp: DateTime.now().millisecondsSinceEpoch,
        lastChange: DateTime.now().millisecondsSinceEpoch,
        read: false));
    var messages2 =await MessagesDb.messagesList;
    var len2 = messages2.length;
    assert(len != len2-1);
  }

}
