import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:universal_io/io.dart';

import '../../app_settings/app_constants.dart';
import '../../headleass_task.dart';
import '../../helpers/debug_helper.dart';
import '../../helpers/device_id_helper.dart';
import '../../helpers/logger/logger.dart';
import '../../helpers/notification/notification_helper.dart';
import '../../helpers/notification/onesignal_handler.dart';
import '../../main.dart';
import '../get_images_and_links_provider.dart';
import '../messages_provider.dart';

part 'app_start_notifier.g.dart';

//https://codewithandrea.com/articles/robust-app-initialization-riverpod/
@Riverpod(keepAlive: true)
class AppStartNotifier extends _$AppStartNotifier {
  bool fMTCInitialized = false;

  @override
  Future<void> build() async {
    await _initializationLogic();
    ref.onDispose(() {
      BnLog.verbose(text: 'start notifier was disposed');
    });
  }

  Future<void> _initializationLogic() async {
    if (kDebugMode) {
      print(
          '${DateTime.now().toIso8601String()} Starting _complexInitializationLogic');
      await Future.delayed(Duration(seconds: 1));
    }
    //mappers and Hive Adapters must be initialized in main.app
    await Hive.openBox(hiveBoxSettingDbName);
    await Hive.openBox(hiveBoxLocationDbName);
    await Hive.openBox(hiveBoxServerConfigDBName);
    await DeviceId.initAppId();
    debugPrintTime('initLogger');
    await initLogger();
    initSettings();

    if (!kIsWeb && !fMTCInitialized) {
      await FMTCObjectBoxBackend().initialise();
      fMTCInitialized = true;
    }

    if (!kIsWeb) {
      await FMTCStore(fmtcTileStoreName).manage.create();
      Future.microtask(() async {
        await _initNotifications();
        await initOneSignal();
        ref.read(messagesLogicProvider).updateServerMessages();
      });
    }

    if (Platform.isAndroid) {
      ///TODO fix bgfetch
      //await initPlatformState();
    }
    if (Platform.isAndroid) {
      /// Register BackgroundGeolocation headless-task
      /* bg.BackgroundGeolocation.registerHeadlessTask(
          backgroundGeolocationHeadlessTask);*/

      /// Register BackgroundFetch headless-task.
      // BackgroundFetch.registerHeadlessTask(backgroundGeolocationHeadlessTask);
    }
    if (kDebugMode) {
      print(
          '${DateTime.now().toIso8601String()} Finished _initializationLogic');
    }
  }

  Future<bool> _initNotifications() async {
    try {
      await NotificationHelper().initialiseNotifications();
    } catch (e) {
      print('initNotifications failed + $e');
      return false;
    }
    return true;
  }

  Future<void> retry() async {
    // use AsyncValue.guard to handle errors gracefully
    state = await AsyncValue.guard(_initializationLogic);
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      // <-- Event handler
      // This is the fetch-event callback.
      BnLog.debug(text: '[BackgroundFetch] Event received $taskId');
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print('[BackgroundFetch] TASK TIMEOUT taskId: $taskId');
      BackgroundFetch.finish(taskId);
    });
    BnLog.info(text: '[BackgroundFetch] configure success: $status');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }
}
