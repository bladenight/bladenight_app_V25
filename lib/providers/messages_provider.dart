import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart';

import '../helpers/crypt_helper.dart';
import '../helpers/hive_box/app_server_config_db.dart';
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
  var dio = Dio();
  var options = Options(
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      contentType: 'application/json');
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
      var isBladeGuard = HiveSettingsDB.bgSettingVisible;
      var teamId = HiveSettingsDB.bgTeam;
      var skmMember = HiveSettingsDB.rcvSkatemunichInfos;
      var appId = HiveSettingsDB.appId;
      var paraString =
          'lts=$lastTimeStamp&bg=$isBladeGuard&team=$teamId&skm=$skmMember&osID=$appId&plf=${Platform.operatingSystem}';
      var parameter = CryptHelper.encryptAES(
          paraString, ServerConfigDb.restApiLinkPassword);
      if (parameter == null) {
        BnLog.error(text: "Couldn't encrypt Parameter");
        return;
      }

      var host = ServerConfigDb.restApiLinkMsg;
      var response =
          await dio.post('$host/getMessages?q=$parameter', options: options);
      if (response.statusCode != 200) {
        await _loadMessages();
        return;
      }
      var decodedMsg = CryptHelper.decryptAES(
          response.data, ServerConfigDb.restApiLinkPassword);
      if (decodedMsg == null) return;
      var msg = jsonDecode(decodedMsg);
      List<ExternalAppMessage> msgList = [];
      for (var mess in msg){
        var detMsg = ExternalAppMessageMapper.fromMap(mess);
        msgList.add(detMsg);
      }
      var mgges = ExternalAppMessages(messages: msgList);
      //var messages = ExternalAppMessagesMapper.fromJson(decodedMsg);
      await MessagesDb.updateMessages(mgges);
      await _loadMessages();
      //var response = await http.get(Uri.parse("https://bladenight.app/api/?results=20"));
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
