import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../app_settings/server_connections.dart';
import '../helpers/crypt_helper.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/hive_box/messages_db.dart';
import '../helpers/logger.dart';
import '../models/external_app_message.dart';
import '../models/external_app_messages.dart';

final messagesProvider = Provider(
    (ref) => ref.watch(messagesLogicProvider).messages.values.toList());

final messagesReadProvider = FutureProvider<int>((ref) async {
  return await MessagesLogic.instance.readCount();
});

final messagesProvider1 = Provider((ref) => ref.watch(messagesReadProvider));

final messagesLogicProvider =
    ChangeNotifierProvider((ref) => MessagesLogic.instance);

class MessagesLogic with ChangeNotifier {
  static final MessagesLogic instance = MessagesLogic._();

  MessagesLogic._() {
    _loadMessages();
  }

  final Map<String, ExternalAppMessage> messages = {};
  int readMessages = 0;

  Future<void> _loadMessages() async {
    var messagesList = await MessagesDb.messagesList;
    messages.clear();
    for (var message in messagesList) {
      messages[message.uid] = message;
    }
    await readCount();
    notifyListeners();
  }

  Future<void> clearMessages() async {
    await MessagesDb.clearMessagesStore();
    _loadMessages();
  }

  Future<int> readCount() async {
    var messagesList = await MessagesDb.messagesList;
    int count = 0;
    for (var message in messagesList) {
      if (message.read == false) {
        count++;
      }
    }
    readMessages = count;
    return count;
  }

  Future<void> addMessage(ExternalAppMessage message) async {
    await MessagesDb.addMessage(message);
    _loadMessages();
  }

  Future<void> setReadMessage(ExternalAppMessage message, bool read) async {
    MessagesDb.setReadMessage(message, read);
    _loadMessages();
  }

  Future<void> deleteMessage(ExternalAppMessage message) async {
    MessagesDb.deleteMessage(message);
    messages.remove(message.uid);
    _loadMessages();
  }

  Future<void> reloadMessages() async {
    await _loadMessages();
  }

  Future<void> updateServerMessages() async {
    try {
      var lastTimeStamp = await MessagesDb.getLastMessagesUpdateTimestamp;
      var isBladeGuard = HiveSettingsDB.isBladeGuard;
      var teamId = HiveSettingsDB.teamId;
      var skmMember = HiveSettingsDB.rcvSkatemunichInfos;
      var oneSignalID = HiveSettingsDB.oneSignalId;
      var parameter = EncryptData.encryptAES(
          'lts=$lastTimeStamp&bg=$isBladeGuard&team=$teamId&skm=$skmMember&osID=$oneSignalID',
          messagePassword);
      if (parameter == null) {
        BnLog.error(text: "Couldn't encrypt Parameter");
        return;
      }
      var result = await http
          .get(Uri.parse('$bladenightMessageServerLink/?$parameter'));
      if (result.statusCode != 200) {
        await _loadMessages();
        return;
      }
      var messages = ExternalAppMessagesMapper.fromJson(result.body);
      await MessagesDb.updateMessages(messages);
      await _loadMessages();
      //var result = await http.get(Uri.parse("https://bladenight.app/api/?results=20"));
    } catch (ex) {
      BnLog.error(text: 'Error updateServerMessages', exception: ex);
    }
  }
}

final filteredMessages = Provider<List<ExternalAppMessage>>((ref) {
  final messages = ref.watch(messagesProvider);
  final searchStringProvider = ref.watch(messageNameProvider);

  if (searchStringProvider.isEmpty) {
    return messages;
  }

  var filteredMessagesList = messages.where((f) =>
      f.body.toLowerCase().contains(searchStringProvider.toLowerCase()) ||
      f.title.toLowerCase().contains(searchStringProvider.toLowerCase()));

  return filteredMessagesList.toList();
});

final messageNameProvider = StateProvider<String>((value) => '');
