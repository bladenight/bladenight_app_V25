import 'dart:collection';
import 'dart:ffi';
import 'dart:ui' show IsolateNameServer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'dart:isolate' as di;
import 'dart:ui' as ui;

import '../../../app_settings/app_constants.dart';

final isolatedDbProvider =
    StateProvider<IsolatedHiveDb>((ref) => IsolatedHiveDb.instance);

class IsolatedHiveDb {
  static final IsolatedHiveDb instance = IsolatedHiveDb._();

  //static final IsolateNameServer isolatedNameServer;

  IsolatedHiveDb();

  IsolatedHiveDb._() {
    init();
  }

  static Box get _hiveBox {
    return Hive.box(isolatedHiveDbName);
  }

  void init() {
    IsolatedHive.initFlutter();
  }
}

class BnIsolatedNameServer_test extends IsolateNameServer {
  late Map<String, int> portMap;

  BnIsolatedNameServer() {
    portMap = <String, int>{};
  }

  @override
  lookupPortByName(String name) {
    // TODO: implement lookupPortByName
    throw UnimplementedError();
  }

  @override
  bool registerPortWithName(port, String name) {
    final receivePort = di.ReceivePort();
    final sendPort = receivePort.sendPort;
    final registered =
        ui.IsolateNameServer.registerPortWithName(sendPort, name);

    if (registered) {
      receivePort.listen((message) {
        //print('Received: $message');
      });
      portMap[name] = receivePort.sendPort.nativePort;
      return true;
    } else {
      print(
          'Failed to register SendPort with name: $name. Name already exists.');
      return false;
    }
  }

  @override
  bool removePortNameMapping(String name) {
    return ui.IsolateNameServer.removePortNameMapping(name);
  }
}
