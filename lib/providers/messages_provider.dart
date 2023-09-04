import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/hive_box/messages_db.dart';
import '../models/message.dart';

final messagesProvider = Provider(
    (ref) => ref.watch(messagesLogicProvider).messages.values.toList());

final messagesReadProvider = FutureProvider<int>((ref) async {
  return await MessagesLogic.instance.readCount();
});

final messagesProvider1 = Provider(
        (ref) => ref.watch(messagesReadProvider));


final messageByIdProvider = Provider.family((ref, int id) =>
    ref.watch(messagesLogicProvider.select((l) => l.messages[id])));

final messagesLogicProvider =
    ChangeNotifierProvider((ref) => MessagesLogic.instance);

class MessagesLogic with ChangeNotifier {
  static final MessagesLogic instance = MessagesLogic._();

  MessagesLogic._() {
    _loadMessages();
  }

  final Map<String, Message> messages = {};
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

  Future<void> setReadMessage(Message message, bool read) async {
    MessagesDb.setReadMessage(message, read);
    _loadMessages();
  }

  Future<void> deleteMessage(Message message) async {
    MessagesDb.deleteMessage(message);
    messages.remove(message.uid);
    _loadMessages();
  }

  Future<void> reloadMessages() async {
    await _loadMessages();
  }
}

final filteredMessages = Provider<List<Message>>((ref) {
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
