import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:hive_flutter/adapters.dart';

import '../../models/external_app_message.dart';
import '../../models/external_app_messages.dart';
import '../logger.dart';

class MessagesDb {
  static final MessagesDb instance = MessagesDb._();
  static Box? _messagesDbBox;
  static const String dbName = 'OneSignalMessagesDb';
  static const String _messagesUpdateTimeStampKey = 'MessagesUpdateTimeStampKey';

  MessagesDb._() {
    init();
  }

  void init() async {
    _messagesDbBox = await Hive.openBox(dbName);
  }

  ///get stored messages
  static Future<List<ExternalAppMessage>> get messagesList async {
    try {
      _messagesDbBox ??= await Hive.openBox(dbName);
      List<ExternalAppMessage> messageList = [];
      for (var key in _messagesDbBox!.keys) {
        var messageJson = _messagesDbBox!.get(key);
        if (messageJson == null) continue;
        messageList.add(MapperContainer.globals.fromJson<ExternalAppMessage>(messageJson));
      }
      return messageList;
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveMessages(ExternalAppMessages messages) async {
    try {
      _messagesDbBox ??= await Hive.openBox(dbName);
      for (var message in messages.messages) {
        _messagesDbBox!.put(message.uid, message.toJson());
      }
    } catch (e) {
      BnLog.error(text: 'Error saveMessages ${e.toString()}', exception: e);
    }
  }

  static Future<void> addMessage(ExternalAppMessage message) async {
    if (message.deleted) return;
    _messagesDbBox ??= await Hive.openBox(dbName);
    try {
      await _messagesDbBox!.put(message.uid, message.toJson());

    } catch (e) {
      BnLog.error(text: 'Error addMessage ${e.toString()}', exception: e);
    }
  }

  static Future<void> setReadMessage(ExternalAppMessage message, bool read) async {
    _messagesDbBox ??= await Hive.openBox(dbName);
    try {
      var messageCopy = message.copyWith(read: read);
      return _messagesDbBox!.put(message.uid, messageCopy.toJson());
    } catch (e) {
      BnLog.error(text: 'Error addMessage ${e.toString()}', exception: e);
    }
  }


  static Future<bool> updateMessages(ExternalAppMessages messages) async {
    _messagesDbBox ??= await Hive.openBox(dbName);
    try {
      int lastUpdateTimestamp = 0;
      for (var message in messages.messages){
        updateMessage(message);
        //log last update
        if (message.lastChange > lastUpdateTimestamp){
          lastUpdateTimestamp = message.lastChange;
        }
      }
      //update timestamp
      setLastMessagesUpdateTimestamp(lastUpdateTimestamp);
      return true;

    } catch (e) {
      BnLog.error(text: 'Error addMessage ${e.toString()}', exception: e);
    }
    return false;
  }

  static Future<void> updateMessage(ExternalAppMessage message) async {
    if (message.deleted) {
      deleteMessage(message);
    }
    else{
      addMessage(message);
    }
  }

  static Future<int> get getLastMessagesUpdateTimestamp async {
    try {
      _messagesDbBox ??= await Hive.openBox(dbName);
      return await _messagesDbBox!.get(_messagesUpdateTimeStampKey,defaultValue: 0);
    } catch (e) {
      BnLog.error(text: 'Error getLastMessagesUpdateTimestamp ${e.toString()}', exception: e);
    }
    return 0;
  }

  static Future<void>  setLastMessagesUpdateTimestamp(int lastUpdateTimestamp) async {
    try {
      _messagesDbBox ??= await Hive.openBox(dbName);
      return await _messagesDbBox!.put(_messagesUpdateTimeStampKey,lastUpdateTimestamp);
    } catch (e) {
      BnLog.error(text: 'Error setLastMessagesUpdateTimestamp ${e.toString()}', exception: e);
    }
  }

  ///helper to clear message store
  static Future<int> clearMessagesStore() async {
    _messagesDbBox ??= await Hive.openBox(dbName);
    return _messagesDbBox!.clear();
  }

  static Future<void> deleteMessage(ExternalAppMessage message) async {
    _messagesDbBox ??= await Hive.openBox(dbName);
    return _messagesDbBox!.delete(message.uid);
  }
}
