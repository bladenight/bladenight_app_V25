import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:hive_flutter/adapters.dart';

import '../../models/message.dart';
import '../../models/messages.dart';
import '../logger.dart';

class MessagesDb {
  static final MessagesDb instance = MessagesDb._();
  static Box? _messagesDbBox;
  static const String dbName = 'OneSignalMessagesDb';

  MessagesDb._() {
    init();
  }

  void init() async {
    _messagesDbBox = await Hive.openBox(dbName);
  }

  ///get stored messages
  static Future<List<Message>> get messagesList async {
    try {
      _messagesDbBox ??= await Hive.openBox(dbName);
      List<Message> messageList = [];
      for (var key in _messagesDbBox!.keys) {
        var messageJson = _messagesDbBox!.get(key);
        if (messageJson == null) continue;
        messageList.add(MapperContainer.globals.fromJson<Message>(messageJson));
      }
      return messageList;
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveMessages(Messages messages) async {
    try {
      _messagesDbBox ??= await Hive.openBox(dbName);
      for (var message in messages.messages) {
        _messagesDbBox!.put(message.uid, message.toJson());
      }
    } catch (e) {
      BnLog.error(text: 'Error saveMessages ${e.toString()}', exception: e);
    }
  }

  static Future<void> addMessage(Message message) async {
    _messagesDbBox ??= await Hive.openBox(dbName);
    try {
      _messagesDbBox!.put(message.uid, message.toJson());

    } catch (e) {
      BnLog.error(text: 'Error addMessage ${e.toString()}', exception: e);
    }
  }

  static Future<void> setReadMessage(Message message, bool read) async {
    _messagesDbBox ??= await Hive.openBox(dbName);
    try {
      var messageCopy = message.copyWith(read: read);
      return _messagesDbBox!.put(message.uid, messageCopy.toJson());
    } catch (e) {
      BnLog.error(text: 'Error addMessage ${e.toString()}', exception: e);
    }
  }

  ///helper to clear message store
  static Future<int> clearMessagesStore() async {
    _messagesDbBox ??= await Hive.openBox(dbName);
    return _messagesDbBox!.clear();
  }

  static Future<void> deleteMessage(Message message) async {
    _messagesDbBox ??= await Hive.openBox(dbName);
    return _messagesDbBox!.delete(message.uid);
  }
}
