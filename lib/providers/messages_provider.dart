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
import '../helpers/logger/logger.dart';
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
  int readMessagesCount = 0;

  Future<int> _loadMessages() async {
    var messagesList = await MessagesDb.messagesList;
    messages.clear();
    for (var message in messagesList) {
      messages[message.uid] = message;
    }
    var count = await readCount();
    notifyListeners();
    return count;
  }

  Future<void> clearMessages() async {
    await MessagesDb.clearMessagesStore();
    await updateServerMessages();
  }

  Future<int> readCount() async {
    var messagesList = await MessagesDb.messagesList;
    int count = 0;
    for (var message in messagesList) {
      if (message.read == false) {
        count++;
      }
    }
    readMessagesCount = count;
    return count;
  }

  Future<int> messagesCount() async {
    var messagesList = await MessagesDb.messagesList;

    return messagesList.length;
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
    //reset store if 1 item left
    if (await messagesCount() == 1) {
      await clearMessages();
    } else {
      MessagesDb.deleteMessage(message);
      _loadMessages();
    }
  }

  Future<void> reloadMessages() async {
    await _loadMessages();
  }

  Future<int> updateServerMessages() async {
    if (kIsWeb) {
      //due  CORS issue ignore messages
      return 0;
    }
    try {
      var lastTimeStamp = await MessagesDb.getLastMessagesUpdateTimestamp;
      var isBladeGuard = HiveSettingsDB.bgSettingVisible;
      var teamId = HiveSettingsDB.bgTeam;
      var skmMember = HiveSettingsDB.rcvSkatemunichInfos;
      var appId = HiveSettingsDB.appId;
      var oneSignalId = HiveSettingsDB.oneSignalId;
      var paraString =
          'lts=$lastTimeStamp&bg=$isBladeGuard&team=$teamId&skm=$skmMember&osID=$oneSignalId&plf=${Platform.operatingSystem}&aid=$appId';
      var parameter = CryptHelper.encryptAES(
          paraString, ServerConfigDb.restApiLinkPassword);
      if (parameter == null) {
        BnLog.error(text: "Couldn't encrypt Parameter");
        return -1;
      }

      var host = ServerConfigDb.restApiLinkMsg;
      var response =
          await dio.post('$host/getMessages?q=$parameter', options: options);
      if (response.statusCode != 200) {
        await _loadMessages();
        return -2;
      }
      var decodedMsg = CryptHelper.decryptAES(
          response.data, ServerConfigDb.restApiLinkPassword);
      if (decodedMsg == null) return -8;
      var msg = jsonDecode(decodedMsg);
      List<ExternalAppMessage> msgList = [];
      for (var mess in msg) {
        var detMsg = ExternalAppMessageMapper.fromMap(mess);
        msgList.add(detMsg);
      }
      var mgges = ExternalAppMessages(messages: msgList);
      //var messages = ExternalAppMessagesMapper.fromJson(decodedMsg);
      await MessagesDb.updateMessages(mgges);
      await _loadMessages();
      return mgges.messages.length;
      //var response = await http.get(Uri.parse("https://bladenight.app/api/?results=20"));
    } catch (ex) {
      BnLog.error(text: 'Error updateServerMessages', exception: ex);
      return -3;
    }
  }
}

final filteredMessages = Provider<List<ExternalAppMessage>>((ref) {
  final messages = ref.watch(messagesProvider);
  final searchStringProvider = ref.watch(messageNameProvider);

  if (searchStringProvider.isEmpty) {
    messages.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
    return messages;
  }

  var filteredMessagesList = messages.where((f) =>
      f.body.toLowerCase().contains(searchStringProvider.toLowerCase()) ||
      f.title.toLowerCase().contains(searchStringProvider.toLowerCase()));

  var fMsgList = filteredMessagesList.toList()
    ..sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
  return fMsgList;
});

final messageNameProvider = StateProvider<String>((value) => '');
