import 'package:flutter/foundation.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:universal_io/io.dart';

import '../../app_settings/app_constants.dart';
import '../../app_settings/globals.dart';
import '../../helpers/deviceid_helper.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../main.dart';
import '../../main.init.dart';
import '../../models/image_and_link.dart';

part 'app_start_notifier.g.dart';

//https://codewithandrea.com/articles/robust-app-initialization-riverpod/
@Riverpod(keepAlive: true)
class AppStartNotifier extends _$AppStartNotifier {
  @override
  Future<void> build() async {
    // Initially, load the database from JSON
    await _complexInitializationLogic();
  }

  Future<void> _complexInitializationLogic() async {
    if (kDebugMode) {
      print(
          '${DateTime.now().toIso8601String()} Starting _complexInitializationLogic');
    }
    initializeMappers();
    await Hive.initFlutter();
    Hive.registerAdapter(ColorAdapter());
    Hive.registerAdapter(ImageAndLinkAdapter());
    await Hive.openBox(hiveBoxSettingDbName);
    await Hive.openBox(hiveBoxLocationDbName);
    await Hive.openBox(hiveBoxServerConfigDBName);
    Globals.logToCrashlytics = HiveSettingsDB.chrashlyticsEnabled;
    await DeviceId.initAppId();
    await initLogger();
    initSettings();
    if (!kIsWeb) {
      await FMTCObjectBoxBackend().initialise();
    }
    //await Future.delayed(Duration(seconds: 10));
    if (Platform.isAndroid) {
      /// Register BackgroundGeolocation headless-task
      /* bg.BackgroundGeolocation.registerHeadlessTask(
          backgroundGeolocationHeadlessTask);*/

      /// Register BackgroundFetch headless-task.
      // BackgroundFetch.registerHeadlessTask(backgroundGeolocationHeadlessTask);
    }
    /*await SentryFlutter.init((options) {
        options.dsn =
            'https://260152b2325af41400820edd53e3a54c@o4507936224706560.ingest.de.sentry.io/4507936226541648';
        https: //examplePublicKey@o0.ingest.sentry.io/0';
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 1.0;
        // The sampling rate for profiling is relative to tracesSampleRate
        // Setting to 1.0 will profile 100% of sampled transactions:
        // Note: Profiling alpha is available for iOS and macOS since SDK version 7.12.0
        options.profilesSampleRate = 1.0;
      },
          appRunner: () => runApp(
                ProviderScope(
                  observers: [
                    LoggingObserver(),
                  ],
                  child: BladeNightApp(),
                ),
              ));
*/
    if (kDebugMode) {
      print(
          '${DateTime.now().toIso8601String()} Finished _complexInitializationLogic');
    }
  }

  Future<void> retry() async {
    // use AsyncValue.guard to handle errors gracefully
    state = await AsyncValue.guard(_complexInitializationLogic);
  }
}
