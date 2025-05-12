import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker/talker.dart' as tl;

import '../../app_settings/app_constants.dart';
import '../../app_settings/globals.dart';
import '../../firebase_options.dart';
import '../../geofence/geofence_helper.dart';
import '../../helpers/device_id_helper.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/logger/logger.dart';
import '../../helpers/notification/notification_helper.dart';
import '../../helpers/notification/onesignal_handler.dart';
import '../../helpers/watch_communication_helper.dart';
import '../../main.dart';
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
      BnLog.verbose(text: 'Start notifier was disposed');
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
    initCrashLogs();
    await initLogger();

    if (!kIsWeb && !fMTCInitialized) {
      await FMTCObjectBoxBackend().initialise();
      fMTCInitialized = true;
    }

    if (!kIsWeb) {
      await FMTCStore(fmtcTileStoreName).manage.create();
      Future.microtask(() async {
        await ref.read(messagesLogicProvider).updateServerMessages();
        if (await _initNotifications() == true) {
          GeofenceHelper().activateGeofencing();
          await initOneSignal();
        }
      });
      initWatchFlutterChannel();
    }
  }

  void initCrashLogs() async {
    if (kDebugMode && !kIsWeb && HiveSettingsDB.chrashlyticsEnabled) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FlutterError.onError = (details) {
        talker.log(
          details.exceptionAsString(),
          logLevel: tl.LogLevel.critical,
          stackTrace: details.stack,
        );
        FlutterError.presentError(details);
      };
    } else if (!kDebugMode && !kIsWeb && HiveSettingsDB.chrashlyticsEnabled) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FlutterError.onError = (details) {
        talker.log(
          details.exceptionAsString(),
          logLevel: tl.LogLevel.error,
          stackTrace: details.stack,
        );
        if (Globals.logToCrashlytics) {
          FirebaseCrashlytics.instance.recordFlutterFatalError(details);
        }
      };
      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        if (Globals.logToCrashlytics) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
        }
        talker.handle(error, stack, 'PlatformDispatcher Instance Error');
        return true;
      };
      talker.log('BladenightApp started');
      talker.configure(logger: tl.TalkerLogger());
    }
  }

  Future<bool> _initNotifications() async {
    try {
      await NotificationHelper().initialiseNotifications();
    } catch (e) {
      BnLog.warning(text: 'initNotifications failed + $e');
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
            requiredNetworkType: NetworkType.ANY), (String taskId) async {
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
